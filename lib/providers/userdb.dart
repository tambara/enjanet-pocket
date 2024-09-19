// Dart imports:
import 'dart:async';
import 'dart:convert';

// Package imports:
import 'package:enjanet_pocket/datas/metadata.dart';
import 'package:enjanet_pocket/db/db.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:enjanet_pocket/datas/appdata.dart';
import 'package:enjanet_pocket/datas/env.dart';

// ブックマークなどユーザー情報を保存するDB
class UserDbNotifier extends StateNotifier<UserDatabase?> {
  UserDbNotifier() : super(null) {
    // load();
  }

  // 新しい値を設定するメソッド
  bool load() {
    if (kDebugMode) {
      print("UserDb load");
      print(AppData().userDbFile.path);
    }

    try {
      // state?.close();
      final db = initDatabase(
          AppData().userDbFile.path, kDebugMode ? null : Env.userDbPass);
      // final db = initDatabase(AppData().UserDbFile.path, null);
      // final db = sqlite3.open(AppData().UserDbFile.path);

      // user_bookmarks テーブル
      db.execute('''
      CREATE TABLE IF NOT EXISTS user_bookmarks (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        item_id INTEGER NOT NULL,
        table_type INTEGER NOT NULL,
        created_at INTEGER NOT NULL,
        UNIQUE (item_id, table_type)
      );
    ''');

      // user_settings テーブル
      db.execute('''
      CREATE TABLE IF NOT EXISTS user_settings (
        name TEXT NOT NULL,
        value TEXT NOT NULL,
        UNIQUE (name)
      );
    ''');

      // user_data テーブル
      db.execute('''
      CREATE TABLE IF NOT EXISTS user_data (
        name TEXT NOT NULL,
        value TEXT NOT NULL,
        UNIQUE (name)
      );
    ''');

      final userDb = UserDatabase(db);
      userDb.insertOrIgnoreSettings('darkMode', 'false');
      userDb.insertOrIgnoreSettings('primaryMap', 'online');
      userDb.insertOrIgnoreSettings('checkUpdates', 'true');
      userDb.insertOrIgnoreSettings('languageType', 'ja');
      // userDb.insertOrIgnoreSettings('enjenetDbLastUpdatedAt', '');
      // userDb.insertOrIgnoreSettings('rasterMapLastUpdatedAt', '');
      // userDb.insertOrIgnoreSettings('vectorMapLastUpdatedAt', '');

      state = userDb;
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }
}

// ユーザーDB
final userDbProvider =
    StateNotifierProvider<UserDbNotifier, UserDatabase?>((ref) {
  return UserDbNotifier();
});

// ユーザーDBのセッティング情報の各プロバイダー
class SettingNotifier<T> extends StateNotifier<T?> {
  final UserDatabase db;
  final String settingName;
  final T? Function(String?) fromString;
  final String? Function(T?) convertString;

  SettingNotifier(
      this.db, this.settingName, this.fromString, this.convertString)
      : super(null) {
    _initializeSetting();
  }

  Future<void> _initializeSetting() async {
    final value = db.getSetting(settingName);
    state = fromString(value as String?);
  }

  Future<void> update(T? value) async {
    db.upsertSetting(settingName, convertString(value));
    state = value;
  }
}

final settingLanguageTypeProvider =
    StateNotifierProvider<SettingNotifier<String>, String?>((ref) {
  final db = ref.watch(userDbProvider);
  if (db == null) throw Exception('Database not initialized');
  return SettingNotifier<String>(
    db,
    'languageType',
    (value) => value,
    (value) => value,
  );
});

final settingDarkModeProvider =
    StateNotifierProvider<SettingNotifier<bool>, bool?>((ref) {
  final db = ref.watch(userDbProvider);
  if (db == null) {
    throw Exception('Database not initialized');
  }
  return SettingNotifier<bool>(
    db,
    'darkMode',
    (value) => value?.toLowerCase() == 'true',
    (value) => value?.toString(),
  );
});

final intSettingProvider =
    StateNotifierProvider.family<SettingNotifier<int>, int?, String>(
        (ref, key) {
  final db = ref.watch(userDbProvider);
  if (db == null) throw Exception('Database not initialized');
  return SettingNotifier<int>(
    db,
    key,
    (value) => value != null ? int.tryParse(value) : null,
    (value) => value.toString(),
  );
});

final settingPrimaryMapProvider =
    StateNotifierProvider<SettingNotifier<String>, String?>((ref) {
  final db = ref.watch(userDbProvider);
  if (db == null) throw Exception('Database not initialized');
  return SettingNotifier<String>(
    db,
    'primaryMap',
    (value) => value,
    (value) => value,
  );
});

final settingCheckUpdatesProvider =
    StateNotifierProvider<SettingNotifier<bool>, bool?>((ref) {
  final db = ref.watch(userDbProvider);
  if (db == null) throw Exception('Database not initialized');
  return SettingNotifier<bool>(
    db,
    'checkUpdates',
    (value) => value?.toLowerCase() == 'true',
    (value) => value?.toString(),
  );
});

final boolSettingProvider =
    StateNotifierProvider.family<SettingNotifier<bool>, bool?, String>(
        (ref, key) {
  final db = ref.watch(userDbProvider);
  if (db == null) throw Exception('Database not initialized');
  return SettingNotifier<bool>(
    db,
    key,
    (value) => value?.toLowerCase() == 'true',
    (value) => value?.toString(),
  );
});

typedef MetadataJsonSettingProvider
    = StateNotifierProvider<SettingNotifier<MetadataJson?>, MetadataJson?>;

final metadataJsonSettingProvider = StateNotifierProvider.family<
    SettingNotifier<MetadataJson?>, MetadataJson?, String>((ref, key) {
  final db = ref.watch(userDbProvider);
  if (db == null) throw Exception('Database not initialized');

  return SettingNotifier<MetadataJson?>(
    db,
    key,
    (value) =>
        (value != null ? MetadataJson.fromJson(jsonDecode(value)) : null),
    (value) => jsonEncode(value?.toJson()),
  );
});

// え〜んじゃネットの情報が入ったDB

class EnjanetDbNotifier extends StateNotifier<EnjanetDatabase?> {
  EnjanetDbNotifier() : super(null) {
    // load();
  }

  // 新しい値を設定するメソッド
  bool load() {
    if (state != null) {
      state!.db.dispose();
    }

    // DBを読み込む
    try {
      state = EnjanetDatabase(
          initDatabase(AppData().enjanetDbFile.path, Env.enjanetDbPass));
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
