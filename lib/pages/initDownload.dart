// Dart imports:

// Flutter imports:
import 'package:download_task/download_task.dart';
import 'package:enjanet_pocket/providers/downloadNotifier.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';

// Project imports:
import 'package:enjanet_pocket/providers/providers.dart';

class DbDownloadPage extends ConsumerStatefulWidget {
  const DbDownloadPage({
    super.key,
    required this.onComplete,
  });

  final void Function(bool success) onComplete;

  @override
  ConsumerState<DbDownloadPage> createState() => _DbDownloadPageState();
}

class _DbDownloadPageState extends ConsumerState<DbDownloadPage> {
  bool disableButton = false;
  String? exceptionMsg;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final downloadNotifier = ref.read(downloadEnjaDbProvider.notifier);

        final success = await downloadNotifier.download();
        if (success) {
          ref.read(enjanetDbProvider.notifier).load();
        }

        //TODO: 読み込めなかった時にトーストなどで表示
        widget.onComplete(success);
      } catch (e) {
        setState(() {
          exceptionMsg = e.toString();
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget buildRetryButton() {
    return ElevatedButton(
      onPressed: () async {
        final downloadNotifier = ref.watch(downloadEnjaDbProvider.notifier);
        widget.onComplete(await downloadNotifier.download());
      },
      child: const Text("再ダウンロード"),
    );
  }

  LinearProgressIndicator buildProgressIndicator(double? value) {
    return LinearProgressIndicator(
      value: value,
      backgroundColor: Colors.blue[50],
      color: Colors.blue[400],
    );
  }

  Widget buildTaskEvent(TaskEvent e) {
    switch (e.state) {
      case TaskState.downloading:
        double progress =
            e.totalBytes! == -1 ? 0.0 : e.bytesReceived! / e.totalBytes!;

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("ダウンロード中"),
            const SizedBox(
              height: 10,
            ),
            Text(
                "${e.bytesReceived! ~/ 1024} KB / ${e.totalBytes! ~/ 1024} KB}"),
            const SizedBox(
              height: 10,
            ),
            buildProgressIndicator(progress),
          ],
        );
      case TaskState.paused:
        double progress =
            e.totalBytes! == -1 ? 0.0 : e.bytesReceived! / e.totalBytes!;
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildProgressIndicator(progress),
            const SizedBox(
              height: 10,
            ),
            const Text('一時停止中'),
            const SizedBox(
              height: 10,
            ),
            buildRetryButton()
          ],
        );
      case TaskState.success:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('完了'),
            const SizedBox(
              height: 10,
            ),
            buildProgressIndicator(1),
          ],
        );
      case TaskState.canceled:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('キャンセルされました'),
            const SizedBox(
              height: 10,
            ),
            buildRetryButton()
          ],
        );
      case TaskState.error:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('エラー'),
            const SizedBox(
              height: 10,
            ),
            buildRetryButton()
          ],
        );
    }
  }

  Widget buildChild() {
    if (exceptionMsg != null) {
      return Text("DBのダウンロード中にエラーが発生しました。\n${exceptionMsg!}");
    }

    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final download = ref.watch(downloadEnjaDbProvider);

        switch (download) {
          case AsyncData(:final value):
            return buildTaskEvent(value);
          case AsyncError(:final error):
            return Text('Error: $error');
          case AsyncLoading():
            return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('ダウンロード準備中'),
                  const SizedBox(
                    height: 10,
                  ),
                  buildProgressIndicator(null),
                ]);
          case null:
          default:
            return const Text("");
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 225, 227, 228),
        body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          double containerWidth = double.infinity;
          if (ResponsiveBreakpoints.of(context).isDesktop) {
            containerWidth = 500;
          } else if (ResponsiveBreakpoints.of(context).isTablet) {
            containerWidth = 400;
          } else if (ResponsiveBreakpoints.of(context).isMobile) {
            containerWidth = 300;
          } else {
            // if(ResponsiveBreakpoints.of(context).isMobile)
          }
          return Center(
              child: Container(
                  padding: const EdgeInsets.all(10),
                  width: containerWidth,
                  child: buildChild()));
        }));
  }
}
