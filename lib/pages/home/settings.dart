// Dart imports:
import 'dart:async';
import 'dart:core';

// Flutter imports:
import 'package:enjanet_pocket/datas/appdata.dart';
import 'package:enjanet_pocket/pages/home/settings/checkUpdates.dart';
import 'package:enjanet_pocket/pages/home/settings/language.dart';
import 'package:enjanet_pocket/pages/home/settings/primaryMap.dart';
import 'package:enjanet_pocket/providers/downloadNotifier.dart';
import 'package:enjanet_pocket/providers/userdb.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

// Project imports:
import 'package:enjanet_pocket/providers/providers.dart';

final downloadEnjaDbProgressProvider =
    StateProvider<StreamController<double>?>((ref) => null);

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  String? getEnjaDbVesion() {
    final enjanetDb = ref.watch(enjanetDbProvider);
    final metaData = enjanetDb?.getDatabaseMtime();

    int? mtime = metaData != null ? int.tryParse(metaData.value!) : null;

    if (mtime == null) return null;

    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
      mtime * 1000,
    );

    // DateFormatを用いて日時を指定フォーマットの文字列に変換
    return DateFormat('yyyy-MM-dd版').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final languageType = ref.watch(settingLanguageTypeProvider);
    final darkMode = ref.watch(settingDarkModeProvider);
    final checkUpdates = ref.watch(settingCheckUpdatesProvider);
    final primaryMap = ref.watch(settingPrimaryMapProvider);
    final enjenetDbLastUpdatedAt =
        ref.watch(intSettingProvider("enjenetDbLastUpdatedAt"));

    String? dbLastUpdatedAt;

    if (enjenetDbLastUpdatedAt != null) {
      dbLastUpdatedAt = DateFormat('yyyy/MM/dd HH:mm:ss')
          .format(DateTime.fromMillisecondsSinceEpoch(
        enjenetDbLastUpdatedAt,
      ));
    }

    final enjaVersion = getEnjaDbVesion();
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        // foregroundColor: Theme.of(context).textTheme.headline?.color,
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: const Text('一般'),
            tiles: [
              SettingsTile.navigation(
                leading: const Icon(Icons.language),
                title: const Text('言語'),
                trailing: const FaIcon(FontAwesomeIcons.chevronRight),
                value: Text(
                    SettingsLanguageTypePage.options[languageType] ?? "-"), // /

                onPressed: (c) {
                  context.push("/home/settings/languageType");
                },
              ),
              SettingsTile.switchTile(
                title: const Text('ダークモード'),
                leading: const Icon(Icons.dark_mode),
                initialValue: darkMode,
                onToggle: (value) async {
                  final darkModeNotifier =
                      ref.read(settingDarkModeProvider.notifier);
                  darkModeNotifier.update(value);
                },
              ),
            ],
          ),
          SettingsSection(
            title: const Text('データベース'),
            tiles: [
              SettingsTile.navigation(
                  title: const Text('更新チェック'),
                  trailing: const FaIcon(FontAwesomeIcons.chevronRight),
                  leading: const Icon(Icons.update),
                  value: Text(
                      SettingsCheckUpdatesPage.options[checkUpdates] ?? "-"),
                  onPressed: (BuildContext context) {
                    context.push("/home/settings/checkUpdates");
                  }),
              SettingsTile(
                title: const Text('バージョン'),
                value: Text(enjaVersion ?? "-"),
                leading: const Icon(Icons.calendar_today),
              ),
              buildDetabaseDownloadSectionTile(dbLastUpdatedAt),
            ],
          ),

          SettingsSection(
            title: const Text('地図'),
            tiles: [
              SettingsTile.navigation(
                  title: const Text('優先的に使用する地図'),
                  trailing: const FaIcon(FontAwesomeIcons.chevronRight),
                  leading: const FaIcon(FontAwesomeIcons.map),
                  value:
                      Text(SettingsPrimaryMapPage.options[primaryMap] ?? "-"),
                  onPressed: (c) {
                    context.push("/home/settings/primaryMap");
                  }),
              // buildMapDownloadSectionTile(SettingDownloadType.vectorMap),
              buildMapDownloadSectionTile(SettingDownloadType.rasterMap),
              SettingsTile.navigation(
                  title: const Text('地図の削除'),
                  trailing: const FaIcon(FontAwesomeIcons.chevronRight),
                  leading: const FaIcon(FontAwesomeIcons.xmark),
                  description: const Text("ダウンロード済みの地図を削除します"),
                  onPressed: (c) {
                    context.push("/home/settings/deleteMap");
                  }),
            ],
          ),

          SettingsSection(
            title: const Text('情報'),
            tiles: [
              SettingsTile(
                title: const Text('え〜んじゃネット'),
                // trailing: const FaIcon(FontAwesomeIcons.chevronRight),
                description: const Text(
                    "え〜んじゃネットは、精神障がいがある当事者の団体『ピアサポーターグループ クローバー』が運営管理を行っています。 （岡山市障害者自立支援協議会から委託を受けています）"),

                // onPressed: (c) {
                // },
              ),
              SettingsTile(
                title: const Text('アプリ'),
                // trailing: const FaIcon(FontAwesomeIcons.chevronRight),
                description: Text(
                    "え〜んじゃネットポケット v${AppData().packageInfo.version}(${AppData().packageInfo.buildNumber})"),

                // onPressed: (c) {
                // },
              ),
              SettingsTile.navigation(
                title: const Text('ライセンス'),
                trailing: const FaIcon(FontAwesomeIcons.chevronRight),
                // trailing: const FaIcon(FontAwesomeIcons.chevronRight),
                onPressed: (c) {
                  showLicensePage(context: context);
                },
              ),
            ],
          ),
          // CustomSection(
          //   child: Column(
          //     children: [
          //       Padding(
          //         padding: const EdgeInsets.only(top: 22, bottom: 8),
          //         child: Image.asset(
          //           'assets/app_icon.png',
          //           height: 50,
          //           width: 50,
          //         ),
          //       ),
          //       Text(
          //         'アプリ名 v1.0.0',
          //         style: TextStyle(color: Color(0xFF777777)),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  SettingsTile buildDetabaseDownloadSectionTile(String? dbLastUpdatedAt) {
    return SettingsTile(
        title: const Text('データベースのダウンロードと更新確認'),
        leading: const Icon(Icons.sync),
        description: Text(
          "最終更新確認: ${dbLastUpdatedAt ?? "-"}",
        ),
        trailing: const FaIcon(FontAwesomeIcons.chevronRight),
        onPressed: (BuildContext context) async {
          context.push(
              '/home/settings/download/${SettingDownloadType.enjaDb.index}',
              extra: {"title": "データベースのダウンロードと更新確認"});
        });
  }

  SettingsTile buildMapDownloadSectionTile(
    SettingDownloadType mapType,
  ) {
    final downloadProvider = mapType == SettingDownloadType.vectorMap
        ? downloadVectorProvider
        : downloadRasterProvider;

    final downloadNotifier = ref.read(downloadProvider.notifier);

    String status = "";
    if (downloadNotifier.exists()) {
      status = "(ダウンロード済)";
    }

    // if (downloadNotifier.hasIncomplete()) {
    //   if (downloadNotifier.isDownloding) {
    //     status = "(ダウンロード中)";
    //   } else {
    //     status = "(ダウンロード停止中)";
    //   }
    // }

    // return SettingsTile(
    //     title: Text(
    //         '${mapType == SettingDownloadType.vectorMap ? "ベクター" : "ラスター"}形式のダウンロードと更新確認'),
    //     leading: const FaIcon(FontAwesomeIcons.database),
    //     description: Text(mapType == SettingDownloadType.vectorMap
    //         ? "$statusファイルサイズは小さい（約140M）が、描画時にCPU負荷が高い地図"
    //         : "$statusファイルサイズは大きいが、高速に表示できる地図"),
    //     // ダウンロード進行状況を表示する
    //     trailing: const FaIcon(FontAwesomeIcons.chevronRight),
    //     // ダウンロードが開始しているならクリックさせない
    //     onPressed: (BuildContext context) async {
    //       context.push('/home/settings/download/${mapType.index}', extra: {
    //         "title":
    //             "${mapType == SettingDownloadType.vectorMap ? "ベクター" : "ラスター"}形式のダウンロード"
    //       });
    //     });

    return SettingsTile(
        title: Text('オフラインマップのダウンロードと更新確認'),
        leading: const FaIcon(FontAwesomeIcons.database),
        description: Text(status),
        // ダウンロード進行状況を表示する
        trailing: const FaIcon(FontAwesomeIcons.chevronRight),
        // ダウンロードが開始しているならクリックさせない
        onPressed: (BuildContext context) async {
          context.push('/home/settings/download/${mapType.index}',
              extra: {"title": "オフラインマップのダウンロードと更新確認"});
        });
  }
}
