import 'package:enjanet_pocket/providers/downloadNotifier.dart';
import 'package:enjanet_pocket/widgets/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingsDeleteMapPage extends ConsumerWidget {
  static final Map<SettingDownloadType, String> options = {
    SettingDownloadType.rasterMap: 'オフライン',
    // SettingDownloadType.rasterMap: 'ラスター形式',
    // SettingDownloadType.vectorMap: 'ベクター形式',
  };

  const SettingsDeleteMapPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('更新チェック'),
          elevation: 0,
          backgroundColor: Colors.transparent,
          // foregroundColor: Theme.of(context).textTheme.headline?.color,
        ),
        body: SettingsList(
          sections: [
            SettingsSection(
              title: const Text('選択'),
              tiles: <SettingsTile>[
                for (final e in options.entries) buildTile(ref, e),
              ],
            ),
          ],
        ));
  }

  SettingsTile buildTile(
      WidgetRef ref, MapEntry<SettingDownloadType, String> e) {
    final notifier = ref.read(getDownloadNotifierFromEnum(e.key).notifier);
    return SettingsTile(
      title: Text(e.value + (notifier.hasIncomplete() ? "(未完了ファイルあり)" : "")),
      trailing: notifier.exists() ? const FaIcon(FontAwesomeIcons.check) : null,
      onPressed: (BuildContext context) async {
        if (await showOkCancel(context, "本当に削除しますか？") == true) {
          if (notifier.isDownloding) {
            await showOk(context, "ダウンロード中のため削除できません");
            Navigator.pop(context);
          }
          notifier.deleteDownloadedFile();
          notifier.deleteIncompleteFile();
        }
        Navigator.pop(context);
      },
    );
  }
}
