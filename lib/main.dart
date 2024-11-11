// Flutter imports:
import 'dart:io';

import 'package:enjanet_pocket/providers/userdb.dart';
import 'package:enjanet_pocket/thema/color.dart';
import 'package:enjanet_pocket/widgets/snackbar.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';

// Project imports:
import 'package:enjanet_pocket/route.dart';
import 'package:sqlcipher_flutter_libs/sqlcipher_flutter_libs.dart';
import 'package:sqlite3/open.dart';
import 'package:windows_single_instance/windows_single_instance.dart';
import 'datas/appdata.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows) {
    await WindowsSingleInstance.ensureSingleInstance(
        args, "com.okjiritsushien.com/enjanetpocket", onSecondWindow: (args) {
      // ignore: avoid_print
      print(args);
    });
  }

  if (Platform.isAndroid) {
    open.overrideFor(OperatingSystem.android, openCipherOnAndroid);
  }
  // アプリケーションの状態変更を監視するオブザーバーを追加
  // WidgetsBinding.instance.addObserver(_AppLifecycleObserver());

/*TDO: DBのエラーがあってもそのままHOMEへ行き、プロバイダーを使って、
画面上部にエラーの帯を表示し、設定からバックアップの復元や、再更新で乗り切れるようにする 
UPDATEの有無も同じように*/
  runApp(ProviderScope(child: Consumer(
    builder: (BuildContext context, WidgetRef ref, Widget? child) {
      return FutureBuilder<bool>(
        future: AppData().init(ref),
        builder: (BuildContext _, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            return _buildRouter();
          } else if (snapshot.hasError) {
            throw Exception('${snapshot.error!}');
          } else {
            return const MaterialApp();
          }
        },
      );
    },
  )));
}

BottomSheetNavColors _buildBottomSheetNavColors(int v) {
  return BottomSheetNavColors(
    workButtonColor: Colors.blue[v]!,
    medicalButtonColor: Colors.green[v]!,
    restButtonColor: Colors.orange[v]!,
    childButtonColor: Colors.purple[v]!,
    activityButtonColor: Colors.red[v]!,
    planButtonColor: Colors.teal[v]!,
    helperButtonColor: Colors.indigo[v]!,
    bookmarksButtonColor: Colors.yellow[v]!,
    settingsButtonColor: Colors.brown[v]!,
    websiteButtonColor: Colors.lightBlue[v]!,
  );
}

DetailsColors _buildDetailsColors(int v) {
  final colors = DisabilityColors(v);
  return DetailsColors(
    physicalDisabilityColor: colors.physical(),
    intellectualDisabilityColor: colors.intellectual(),
    mentalDisabilityColor: colors.mental(),
    childDisabilityColor: colors.child(),
    intractableDiseaseColor: colors.intractableDisease(),
  );
}

ThemeData _buildDarkTheme() {
  final ThemeData base = ThemeData.dark(
    useMaterial3: true,
  );
  return base.copyWith(
    extensions: [
      _buildBottomSheetNavColors(700),
      _buildDetailsColors(700),
    ],
  );
}

ThemeData _buildLightTheme() {
  ThemeData base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    // その他のライトモードの設定
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Color.fromARGB(255, 225, 227, 228), // ライトモードでの背景色
    ),
  );
  return base.copyWith(
    extensions: [
      _buildBottomSheetNavColors(300),
      _buildDetailsColors(300),
    ],
  );
}

Widget _buildRouter() {
  //  const Color.fromARGB(255, 225, 227, 228), // AppBarの背景を透明に

  return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
    final darkModeStream = ref.watch(settingDarkModeProvider);
    final goRouter = ref.read(goRouterProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: scaffoldMessengerKey,
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      // localizationsDelegates: const [
      //   DefaultMaterialLocalizations.delegate,
      //   DefaultCupertinoLocalizations.delegate,
      //   DefaultWidgetsLocalizations.delegate,
      // ],
      routerConfig: goRouter,
      // theme: const MaterialThemeData(brightness: Brightness.light),
      themeMode: darkModeStream != null && darkModeStream
          ? ThemeMode.dark
          : ThemeMode.system,
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 520, name: MOBILE),
          const Breakpoint(start: 521, end: 960, name: TABLET),
          const Breakpoint(start: 961, end: double.infinity, name: DESKTOP),
        ],
      ),
    );
  });
}

class _AppLifecycleObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      // アプリケーションが終了する直前
      AppData().dispose();
    }
  }
}
