// Dart imports:
import 'dart:async';
import 'dart:io';

// Flutter imports:
import 'package:enjanet_pocket/providers/userdb.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

// Project imports:
import 'package:enjanet_pocket/datas/env.dart';
import 'package:enjanet_pocket/providers/providers.dart';

/*
* アプリ全体で使用するシステムデータ（Singleton）
* */
class AppData {
  static final AppData _instance = AppData._internal();

  factory AppData() {
    return _instance;
  }

  AppData._internal();

  // アプリのデータを保存するローカルディレクトリ
  late String _appDataDir;
  // アプリの一時データを保存するローカルディレクトリ
  late String _appTempDir;

  Future<bool> init(WidgetRef ref) async {
    print("init");
    // TODO: Flyweight

    // パッケージ情報（保存ディレクトリ等で使用）
    packageInfo = await PackageInfo.fromPlatform();

    //ディレクトリを取得
    _appDataDir = await _getAppDataDir();
    _appTempDir = await _getAppTempDir();
    // updateSub = fileDownloader.updates.listen(broadcastUpdates.add);

    // ユーザーDBを開始
    // _userDb = UserDatabase(openConnection(UserDbFile));
    // if (existsUserDb()) {
    final db = ref.read(userDbProvider.notifier);
    if (!db.load()) {
      print("UserDb load failed");
      // TODO:
    }
    // }

    if (existsEnjanetDb()) {
      final db = ref.read(enjanetDbProvider.notifier);
      return db.load();
    }

    return true;
  }

  late PackageInfo packageInfo;

  void dispose() {}

  // user.dbが存在するか
  bool existsUserDb() {
    // .dbへのファイル（パス）
    return File("$_appDataDir/${Env.userDbName}").existsSync();
  }

  // enjanet.dbが存在するか
  bool existsEnjanetDb() {
    // Enjanet.dbへのファイル（パス）
    return File("$_appDataDir/${Env.enjanetEnjanetDbName}").existsSync();
  }

  File genTmpFile() {
    return File(p.join(
        _appTempDir, 'temp_${DateTime.now().millisecondsSinceEpoch}.tmp'));
  }

  String get appDir => _appDataDir;

  File get vectorPmtilesFile =>
      File("$_appDataDir/${Env.enjanetVectorName}"); // アップデートDB。起動時に差し替える
  File get rasterPmtilesFile =>
      File("$_appDataDir/${Env.enjanetRasterName}"); // アップデートMETADATA。起動時に差し替える

  File get enjanetDbFile =>
      File("$_appDataDir/${Env.enjanetEnjanetDbName}"); // データベース
  File get userDbFile => File("$_appDataDir/${Env.userDbName}"); // データベース

  Future<String> _getAppDataDir() async {
    Directory directory;

    if (Platform.isLinux) {
      directory = await getApplicationSupportDirectory();
    } else if (Platform.isWindows) {
      // directory = await getApplicationSupportDirectory();
      // return path.join(Directory(Platform.resolvedExecutable).parent.path,
      //       packageInfo.packageName);
    } else if (Platform.isAndroid) {
      directory = await getApplicationSupportDirectory();
    } else if (Platform.isIOS) {
      // directory = await getLibraryDirectory();
      directory = await getApplicationSupportDirectory();
    } else if (Platform.isMacOS) {
      directory = await getApplicationSupportDirectory();
    }

    directory = await getApplicationSupportDirectory();
    return directory.path;
  }

  // 機種によって一時ファイルディレクトリ取得方法が違うのを未考慮
  Future<String> _getAppTempDir() async {
    Directory directory = await getTemporaryDirectory();
    return directory.path;
  }
}

Map<int, String> servideMap = {
  1: '地域活動支援センターⅠ型',
  2: '地域活動支援センターⅡ型',
  3: '地域活動支援センターⅢ型',
  4: '就労移行支援',
  5: '就労継続支援A型',
  6: '就労継続支援B型',
  7: '生活介護',
  8: '療養介護',
  9: '自立訓練',
  10: 'ホームヘルプ',
  12: '施設入所支援',
  13: '短期入所',
  14: 'グループホーム',
  15: '日中一時支援',
  16: '児童発達支援',
  17: '計画相談（相談支援事業所）',
  18: '放課後等デイサービス',
  19: '訪問看護',
  20: '病院・クリニック',
  21: '就労定着支援',
  9000: 'その他',
};

class ServiceInfo {
  final IconData icon;
  Color color;
  final String name;

  ServiceInfo(this.icon, this.color, this.name);
}

enum ProviderCategory {
  work, // 働きたい&tags='4,5,6'
  medical, //（精神科）医療を受けたい.list 19,20
  rest, // 短期入所・施設入所を探したい.list 12,13,14
  child, //子ども・子育て・日中一時支援.list 15,16,17,18
  activity, // 日中活動をしたい.list 1,2,3,7,8,9
  plan,
  helper,

  // all,
}

class CategoryInfo {
  final IconData icon;
  final Color color;

  CategoryInfo(this.icon, this.color);
}

String convertServiceCategoryStr(String? val) {
  if (val == null) return "-";

  try {
    return val.split('||').map((n) => servideMap[int.parse(n)] ?? n).join(', ');
  } catch (e) {
    return "-";
  }
}

List<int> getServices(ProviderCategory p) {
  switch (p) {
    case ProviderCategory.work:
      return [4, 5, 6];
    case ProviderCategory.medical:
      return [19, 20];
    case ProviderCategory.rest:
      return [12, 13, 14];
    case ProviderCategory.child:
      return [15, 16, 17, 18];
    case ProviderCategory.activity:
      return [1, 2, 3, 7, 8, 9];
    case ProviderCategory.plan:
      return [17];
    case ProviderCategory.helper:
      return [10];
  }
}

enum FormatCategory {
  disabilityServices,
  childServices,
  //group_homes,
  helperStations,
  planningConsultations,
  hospitalsClinics,
}

List<int> getFormatCategoryServices(FormatCategory p) {
  switch (p) {
    case FormatCategory.disabilityServices:
      return [
        1, // '地域活動支援センターⅠ型' を bool に変更
        2, // '地域活動支援センターⅡ型' を bool に変更
        3, // '地域活動支援センターⅢ型' を bool に変更
        4, // '就労移行支援' を bool に変更
        5, // '就労継続支援A型' を bool に変更
        6, // '就労継続支援B型' を bool に変更
        7, // '生活介護' を bool に変更
        8, // '療養介護' を bool に変更
        9, // '自立訓練' を bool に変更
        12, // '施設入所支援' を bool に変更
        13, // '短期入所' を bool に変更
        15, // '日中一時支援' を bool に変更
        21, // '就労定着支援' を bool に変更
        9000, // 'その他' を bool に変更
      ];
    case FormatCategory.childServices:
      return [
        15, // '日中一時支援' を bool に変更
        16, // '児童発達支援' を bool に変更
        18, // '放課後等デイサービス' を bool に変更
      ];
    case FormatCategory.helperStations:
      return [
        10, // 'ホームヘルプ' を bool に変更
      ];
    case FormatCategory.planningConsultations:
      return [
        17, // '計画相談（相談支援事業所）' を bool に変更
      ];
    case FormatCategory.hospitalsClinics:
      return [
        19, // '訪問看護' を bool に変更
        20, // '病院・クリニック' を bool に変更
      ];
    // case ProviderCategory.group_homes:
    // case ProviderCategory.all:
    //   return [
    //     1, // '地域活動支援センターⅠ型' を bool に変更
    //     2, // '地域活動支援センターⅡ型' を bool に変更
    //     3, // '地域活動支援センターⅢ型' を bool に変更
    //     4, // '就労移行支援' を bool に変更
    //     5, // '就労継続支援A型' を bool に変更
    //     6, // '就労継続支援B型' を bool に変更
    //     7, // '生活介護' を bool に変更
    //     8, // '療養介護' を bool に変更
    //     9, // '自立訓練' を bool に変更
    //     10, // 'ホームヘルプ' を bool に変更
    //     12, // '施設入所支援' を bool に変更
    //     13, // '短期入所' を bool に変更
    //     14, // 'グループホーム' を bool に変更
    //     15, // '日中一時支援' を bool に変更
    //     16, // '児童発達支援' を bool に変更
    //     17, // '計画相談（相談支援事業所）' を bool に変更
    //     18, // '放課後等デイサービス' を bool に変更
    //     19, // '訪問看護' を bool に変更
    //     20, // '病院・クリニック' を bool に変更
    //     21, // '就労定着支援' を bool に変更
    //     9000, // 'その他' を bool に変更
    //   ];*/
  }
}
