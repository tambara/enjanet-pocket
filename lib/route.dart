// Flutter imports:
import 'package:enjanet_pocket/pages/home/settings/checkUpdates.dart';
import 'package:enjanet_pocket/pages/home/settings/deleteMap.dart';
import 'package:enjanet_pocket/pages/home/settings/language.dart';
import 'package:enjanet_pocket/pages/home/settings/primaryMap.dart';
import 'package:enjanet_pocket/pages/initDownload.dart';
import 'package:enjanet_pocket/providers/downloadNotifier.dart';
import 'package:enjanet_pocket/pages/home/settings/mapDownload.dart';
import 'package:enjanet_pocket/providers/userdb.dart';
import 'package:enjanet_pocket/widgets/snackbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:enjanet_pocket/datas/searchtable.dart';
import 'package:enjanet_pocket/pages/home.dart';
import 'package:enjanet_pocket/pages/home/detail.dart';
import 'package:enjanet_pocket/pages/home/settings.dart';
import 'datas/appdata.dart';

Widget buildError(String msg, String? stackTrace) {
  return ErrorPage(message: msg, stackTrace: stackTrace);
}

void pushError(BuildContext context, String msg) {
  context.push('/error', extra: {"message": msg});
}

// 内部状態を維持するためにProvider化
final goRouterProvider = Provider<GoRouter>(
  (ref) {
    return GoRouter(
      initialLocation: "/",
      errorPageBuilder: (context, state) => MaterialPage(
          key: state.pageKey, child: ErrorPage(message: state.toString())),
      routes: <RouteBase>[
        // 一番最初に呼ばれ処理を振り分ける
        GoRoute(
          path: '/',
          redirect: (context, state) {
            // Enjanet.dbが存在するか
            if (!AppData().existsEnjanetDb()) {
              // ダウンロードへ
              return '/download';
            }

            // DBの更新確認
            final checkUpdate = ref.read(settingCheckUpdatesProvider);
            if (checkUpdate == true) {
              // 最終更新確認から12時間経過しているなら更新確認をする
              final enjenetDbLastUpdatedAt =
                  ref.read(intSettingProvider("enjenetDbLastUpdatedAt"));

              if (kDebugMode) {
                print("enjenetDbLastUpdatedAt $enjenetDbLastUpdatedAt");
              }

              if (enjenetDbLastUpdatedAt == null ||
                  (DateTime.now().difference(
                              DateTime.fromMillisecondsSinceEpoch(
                                  enjenetDbLastUpdatedAt)))
                          .inHours >=
                      12) {
                // 更新確認
                final downloadEnjaDbProviderNotifier =
                    ref.read(downloadEnjaDbProvider.notifier);
                downloadEnjaDbProviderNotifier.updateCheck().then((onValue) {
                  if (onValue) {
                    // 通知
                    showUpdateNotify();
                  }
                });
              }
            }
            // メイン
            return '/home';
          },
        ),
        // 初期処理。DBのダウンロード
        GoRoute(
          path: '/download',
          builder: (BuildContext context, GoRouterState state) {
            return DbDownloadPage(onComplete: (bool success) {
              if (!success) {
                globalShowSnackBarAfterBuild("DBの初期化に失敗しました。");
              }
              context.go('/home');
            });
          },
        ),
        GoRoute(
          path: '/error',
          builder: (BuildContext context, GoRouterState state) {
            // context.go('/error', extra: {"message": 'エラーのため再起動してください'});
            String? msg;
            if (state.extra != null) {
              final extra = state.extra as Map<String, dynamic>;

              if (extra.containsKey('message')) {
                final msgValue = extra['message'];
                if (msgValue is String) {
                  msg = msgValue;
                } else {
                  print('Warning: "msg" is not a String');
                }
              }
            }

            return ErrorPage(message: msg!);
          },
        ),
        GoRoute(
            path: '/home',
            builder: (BuildContext context, GoRouterState state) {
              return const HomeScreen();
            },
            routes: [
              GoRoute(
                path: 'settings',
                builder: (BuildContext context, GoRouterState state) {
                  return const SettingsPage();
                },
                routes: [
                  GoRoute(
                    path: 'languageType',
                    builder: (BuildContext context, GoRouterState state) {
                      return SettingsLanguageTypePage();
                    },
                  ),
                  GoRoute(
                    path: 'primaryMap',
                    builder: (BuildContext context, GoRouterState state) {
                      return SettingsPrimaryMapPage();
                    },
                  ),
                  GoRoute(
                    path: 'checkUpdates',
                    builder: (BuildContext context, GoRouterState state) {
                      return SettingsCheckUpdatesPage();
                    },
                  ),
                  GoRoute(
                    path: 'download/:type',
                    builder: (BuildContext context, GoRouterState state) {
                      final type = SettingDownloadType
                          .values[int.parse(state.pathParameters['type']!)];

                      String? title;
                      if (state.extra != null) {
                        final extra = state.extra as Map<String, dynamic>;

                        if (extra.containsKey('title')) {
                          final msgValue = extra['title'];
                          if (msgValue is String) {
                            title = msgValue;
                          } else {
                            print('Warning: "title" is not a String');
                          }
                        }
                      }

                      return SettingsDownloadPage(
                          type: type, title: title ?? "");
                    },
                  ),
                  GoRoute(
                    path: 'deleteMap',
                    builder: (BuildContext context, GoRouterState state) {
                      return SettingsDeleteMapPage();
                    },
                  ),
                ],
              ),
              GoRoute(
                path: 'detail/:type/:id',
                builder: (BuildContext context, GoRouterState state) {
                  try {
                    final type = int.parse(state.pathParameters['type']!);
                    final id = int.parse(state.pathParameters['id']!);
                    return DetailPage(
                        itemId: id, type: SearchTableNameEnum.fromInt(type)!);
                  } catch (e) {
                    return ErrorPage(message: e.toString());
                  }
                },
              ),
            ]),
      ],
    );
  },
);

class ErrorPage extends StatefulWidget {
  const ErrorPage({super.key, required this.message, this.stackTrace});

  final String message;
  final String? stackTrace;

  @override
  State<ErrorPage> createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const SelectableText("エラー"),
      ),
      body: Center(
        child: ListView(children: [
          SelectableText(widget.message),
          ...buildStackTraceWidget(),
        ]),
      ),
    );
  }

  List<Widget> buildStackTraceWidget() {
    if (widget.stackTrace == null) {
      return [];
    }
    return [
      const SelectableText("StackTrace:"),
      SelectableText(widget.stackTrace!),
    ];
  }
}
