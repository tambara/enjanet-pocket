// Dart imports:
import 'dart:async';
import 'dart:convert';
import 'dart:io';

// Package imports:
import 'package:download_task/download_task.dart';
import 'package:enjanet_pocket/datas/metadata.dart';
import 'package:enjanet_pocket/db/db.dart';
import 'package:enjanet_pocket/functions.dart';
import 'package:enjanet_pocket/providers/userdb.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

// Project imports:
import 'package:enjanet_pocket/datas/appdata.dart';
import 'package:enjanet_pocket/datas/env.dart';

// ダウンロード進捗を管理するStateNotifier
class DownloadNotifier extends StateNotifier<AsyncValue<TaskEvent>?> {
  SettingNotifier<int> lastUpdatedAt;
  UserDatabase userDb;
  String jsonUrl;
  String downloadingSettingColumnName;
  String downloadedSettingColumnName;
  String downloadUrl;
  File downloadedFile;

  late File downloadingFile;

  DownloadNotifier(
      {required this.lastUpdatedAt,
      required this.userDb,
      required this.jsonUrl,
      required this.downloadingSettingColumnName,
      required this.downloadedSettingColumnName,
      required this.downloadUrl,
      required this.downloadedFile})
      : super(null) {
    downloadingFile = File(downloadedFile.path + Env.incompleteDwnloadExt);

    // ダウンロード済のデータがないのにjson情報があるならデータを空にする
    if (!downloadedFile.existsSync()) {
      userDb.upsertSetting(downloadedSettingColumnName, "");
    }

    // ダウンロード中のデータがないのにjson情報があるならデータを空にする
    if (!downloadingFile.existsSync()) {
      userDb.upsertSetting(downloadingSettingColumnName, "");
    }
  }

  // ダウンロード済みのファイルが存在するか
  bool exists() {
    return downloadedFile.existsSync();
  }

  // ダウンロード中・中断中のファイルが存在するか
  bool hasIncomplete() {
    return downloadingFile.existsSync();
  }

  // ダウンロードファイルにまつわるメターデータをダウンロード
  Future<MetadataJson?> downloadMetadataJson(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return MetadataJson.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }

  // ダウンロード済みファイルのアップデートチェック(保存しているJSONと照会)
  Future<bool> updateCheck() async {
    // TODO: キャッシング
    var json = await downloadMetadataJson(jsonUrl);
    if (json == null) {
      return false;
    }

    lastUpdatedAt.update(DateTime.now().millisecondsSinceEpoch);

    try {
      final value = userDb.getSetting(downloadedSettingColumnName);
      if (value == null) {
        return true;
      }

      return (json.sha256 != MetadataJson.fromJson(jsonDecode(value)).sha256);
    } catch (e) {
      // DBかJSONデコードのエラーがでたらアップデートが必要だと判断
      return true;
    }
  }

  // ダウンロード中（中断）ファイルのアップデートチェック(保存しているJSONと照会)
  Future<bool> updateCheckForIncompleteFile() async {
    // TODO: キャッシング
    var json = await downloadMetadataJson(jsonUrl);
    if (json == null) {
      return false;
    }

    try {
      final value = userDb.getSetting(downloadingSettingColumnName);
      if (value == null) {
        throw Exception("$downloadingSettingColumnName is null");
      }

      return (json.sha256 != MetadataJson.fromJson(jsonDecode(value)).sha256);
    } catch (e) {
      // DBかJSONデコードのエラーがでたらアップデートが必要だと判断
      return true;
    }
  }

  // ダウンロードする
  Future<bool> download() async {
    state = const AsyncLoading();

    var json = await downloadMetadataJson(jsonUrl);
    if (json == null) return false;

    // ダウンロードをスタートした日時
    final startDate = DateTime.now().millisecondsSinceEpoch;

    // ダウンロード中データのMetadataを記録
    userDb.upsertSetting(
        downloadingSettingColumnName, jsonEncode(json.toJson()));

    // ダウンロード
    bool r = await _resumebableDownload();

    if (r) {
      // TODO: このあたりのユーザーへのエラー表示

      // チェックサムを比較
      if (computeFileSha256(downloadingFile) == json.sha256) {
        // 古いデータを削除と差し替え
        if (downloadedFile.existsSync()) {
          downloadedFile.deleteSync();
        }
        downloadingFile.renameSync(downloadedFile.path);

        // ダウンロード中データのMetadataは不要にする
        userDb.upsertSetting(downloadingSettingColumnName, "");
        // ダウンロードしたデータのMetadataを記録
        userDb.upsertSetting(
            downloadedSettingColumnName, jsonEncode(json.toJson()));
        // 最終更新確認日をアップデート
        lastUpdatedAt.update(startDate);
        return true;
      } else {
        // 不正なら削除
        downloadingFile.deleteSync();
        return false;
      }
    }

    return false;
  }

  // ダウンロード中か
  DownloadTask? downloadTask;

  bool get isDownloding {
    final task = downloadTask;
    return (task != null &&
        task.event != null &&
        task.event!.state == TaskState.downloading);
  }

  Future<bool> _resumebableDownload() async {
    final downloadingFile =
        File(downloadedFile.path + Env.incompleteDwnloadExt);
    downloadTask = await DownloadTask.download(Uri.parse(downloadUrl),
        file: downloadingFile);

    await for (final event in downloadTask!.events) {
      state = AsyncData(event);
      switch (event.state) {
        case TaskState.downloading:
        case TaskState.paused:
          break;
        case TaskState.success:
          return true;
        case TaskState.canceled:
          break;
        case TaskState.error:
          break;
      }
    }
    return false;
  }

  Future<bool?> downloadCancel() async {
    if (downloadTask == null) {
      return null;
    }

    return downloadTask!.cancel();
  }

  bool deleteIncompleteFile() {
    try {
      userDb.insertOrIgnoreSettings(downloadingSettingColumnName, "");
      downloadingFile.deleteSync();
      return true;
    } catch (e) {
      return false;
    }
  }

  bool deleteDownloadedFile() {
    try {
      userDb.insertOrIgnoreSettings(downloadedSettingColumnName, "");
      downloadedFile.deleteSync();
      return true;
    } catch (e) {
      return false;
    }
  }
}

// StateNotifierProviderの定義
final downloadEnjaDbProvider =
    StateNotifierProvider<DownloadNotifier, AsyncValue<TaskEvent>?>((ref) {
  final db = ref.watch(userDbProvider);
  if (db == null) {
    throw Exception("userDb is null");
  }

  final enjenetDbLastUpdatedAt =
      ref.read(intSettingProvider("enjenetDbLastUpdatedAt").notifier);

  return DownloadNotifier(
      lastUpdatedAt: enjenetDbLastUpdatedAt,
      userDb: db,
      jsonUrl: Env.enjanetDbJsonUrl,
      downloadingSettingColumnName: "downloadingEnjenetDbMapJson",
      downloadedSettingColumnName: "downloadedEnjenetDbMapJson",
      downloadUrl: Env.enjanetDbUrl,
      downloadedFile: AppData().enjanetDbFile);
});

final downloadVectorProvider =
    StateNotifierProvider<DownloadNotifier, AsyncValue<TaskEvent>?>((ref) {
  final db = ref.watch(userDbProvider);
  if (db == null) {
    throw Exception("userDb is null");
  }
  final vectorMapLastUpdatedAt =
      ref.read(intSettingProvider("vectorMapLastUpdatedAt").notifier);
  return DownloadNotifier(
      lastUpdatedAt: vectorMapLastUpdatedAt,
      userDb: db,
      jsonUrl: Env.enjanetVectorJsonUrl,
      downloadingSettingColumnName: "downloadingVectorMapJson",
      downloadedSettingColumnName: "downloadedVectorMapJson",
      downloadUrl: Env.enjanetVectorUrl,
      downloadedFile: AppData().vectorPmtilesFile);
});
final downloadRasterProvider =
    StateNotifierProvider<DownloadNotifier, AsyncValue<TaskEvent>?>((ref) {
  final db = ref.watch(userDbProvider);
  if (db == null) {
    throw Exception("userDb is null");
  }
  final rasterMapLastUpdatedAt =
      ref.read(intSettingProvider("rasterMapLastUpdatedAt").notifier);
  return DownloadNotifier(
      lastUpdatedAt: rasterMapLastUpdatedAt,
      userDb: db,
      jsonUrl: Env.enjanetRasterJsonUrl,
      downloadingSettingColumnName: "downloadingRasterMapJson",
      downloadedSettingColumnName: "downloadedRasterMapJson",
      downloadUrl: Env.enjanetRasterUrl,
      downloadedFile: AppData().rasterPmtilesFile);
});

enum SettingDownloadType { rasterMap, vectorMap, enjaDb }

StateNotifierProvider<DownloadNotifier, AsyncValue<TaskEvent>?>
    getDownloadNotifierFromEnum(SettingDownloadType type) {
  switch (type) {
    case SettingDownloadType.enjaDb:
      return downloadEnjaDbProvider;
    case SettingDownloadType.rasterMap:
      return downloadRasterProvider;
    case SettingDownloadType.vectorMap:
      return downloadVectorProvider;
  }
}
