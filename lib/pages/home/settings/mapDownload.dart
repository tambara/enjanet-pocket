import 'package:download_task/download_task.dart';
import 'package:enjanet_pocket/providers/downloadNotifier.dart';
import 'package:enjanet_pocket/providers/providers.dart';
import 'package:enjanet_pocket/widgets/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsDownloadPage extends ConsumerStatefulWidget {
  final SettingDownloadType type;
  final String title;
  const SettingsDownloadPage({
    super.key,
    required this.type,
    required this.title,
  });

  @override
  ConsumerState<SettingsDownloadPage> createState() =>
      _SettingsMapDownloadPage();
}

class _SettingsMapDownloadPage extends ConsumerState<SettingsDownloadPage> {
  late StateNotifierProvider<DownloadNotifier, AsyncValue<TaskEvent>?>
      downloadrProvider;

  @override
  void initState() {
    super.initState();

    downloadrProvider = getDownloadNotifierFromEnum(widget.type);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final downloadNotifier = ref.read(downloadrProvider.notifier);
      // ダウンロード中なら何もしない
      if (downloadNotifier.isDownloding) return;

      // 未完了のダウンロードがあるなら
      if (downloadNotifier.hasIncomplete()) {
        // 未完了より新しい更新があれば未完了のファイルを削除
        if (await downloadNotifier.updateCheckForIncompleteFile()) {
          downloadNotifier.deleteIncompleteFile();
        }
      }

      var message = "";
      // データの存在をチェック
      if (downloadNotifier.exists()) {
        // 更新確認
        if (!await downloadNotifier.updateCheck()) {
          await showOk(context, "更新はありませんでした");
          Navigator.of(context).pop();
          return;
        }
        message = "更新があります。ダウンロードを開始しますか？";
      } else {
        message = "ダウンロードを開始しますか？";
      }

      if (downloadNotifier.hasIncomplete()) {
        message = "ダウンロードを再開しますか？";
      }

      if (await showOkCancel(context, message) != true) {
        Navigator.of(context).pop();
        return;
      }
      if (await downloadNotifier.download()) {
        if (widget.type == SettingDownloadType.enjaDb) {
          ref.read(enjanetDbProvider.notifier).load();
          // TODO: loadのエラー処理
        }
      }
    });
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
            Text("${e.bytesReceived!} / ${e.totalBytes}"),
            buildProgressIndicator(progress),
            const SizedBox(
              height: 10,
            ),
            buildCancelButton()
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
            buildCancelButton()
          ],
        );
      case TaskState.success:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildProgressIndicator(1),
            const SizedBox(
              height: 10,
            ),
            const Text('完了'),
            const SizedBox(
              height: 10,
            ),
            buildReturnButton()
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
            buildReturnButton()
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
            buildReturnButton()
          ],
        );
    }
  }

  Widget buildChild() {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final download = ref.watch(downloadrProvider);
        switch (download) {
          case AsyncData(:final value):
            return buildTaskEvent(value);
          case AsyncError(:final error):
            return Text('Error: $error');
          case AsyncLoading():
            return buildProgressIndicator(null);
          case null:
          default:
            return const Text("");
        }
      },
    );
  }

  Widget buildCancelButton() {
    return ElevatedButton(
      onPressed: () async {
        await ref.read(downloadrProvider.notifier).downloadCancel();
      },
      child: const Text("キャンセル"),
    );
  }

  Widget buildReturnButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: const Text("戻る"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          // double containerWidth = double.infinity;
          // if (ResponsiveBreakpoints.of(context).isDesktop) {
          //   containerWidth = 500;
          // } else if (ResponsiveBreakpoints.of(context).isTablet) {
          //   containerWidth = 400;
          // } else if (ResponsiveBreakpoints.of(context).isMobile) {
          //   containerWidth = 300;
          // } else {
          //   // if(ResponsiveBreakpoints.of(context).isMobile)
          // }
          return Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: buildChild(),
              ));
        }));
  }
}
