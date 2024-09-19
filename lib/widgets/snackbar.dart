// part 'main.g.dart';
import 'package:flutter/material.dart';

final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

void globalShowSnackBar(String msg) {
  ScaffoldMessengerState scaffoldMessangerState =
      scaffoldMessengerKey.currentState!;

  SnackBar snackBar = SnackBar(
    duration: const Duration(minutes: 3),
    content: Text(msg),
    action: SnackBarAction(
      label: '閉じる',
      onPressed: () {
        //閉じるが押された時行いたい処理
      },
    ),
  );

  scaffoldMessangerState.showSnackBar(snackBar);
}

void globalShowSnackBarAfterBuild(String msg) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    globalShowSnackBar(msg);
  });
}

void showSnackBar(ScaffoldMessengerState s, String msg) {
  SnackBar snackBar = SnackBar(
    duration: const Duration(minutes: 3),
    content: Text(msg),
    action: SnackBarAction(
      label: '閉じる',
      onPressed: () {
        //閉じるが押された時行いたい処理
      },
    ),
  );

  s.showSnackBar(snackBar);
}

void showUpdateNotify() {
  ScaffoldMessengerState scaffoldMessangerState =
      scaffoldMessengerKey.currentState!;

  SnackBar snackBar = SnackBar(
    duration: const Duration(seconds: 15),
    content: const Text("新しいデータベースをダウンロードできます。"),
    action: SnackBarAction(
      label: '閉じる',
      onPressed: () {
        //閉じるが押された時行いたい処理
      },
    ),
  );

  scaffoldMessangerState.showSnackBar(snackBar);
}
