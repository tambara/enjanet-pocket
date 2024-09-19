import 'package:enjanet_pocket/providers/userdb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingsPrimaryMapPage extends ConsumerWidget {
  static final Map<String, String> options = {
    'online': 'オンライン',
    'raster': 'オフラインs',
    // 'raster': 'ラスター形式',
    // 'vector': 'ベクター形式',
  };
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primaryMap = ref.watch(settingPrimaryMapProvider);
    return Scaffold(
        appBar: AppBar(
          title: const Text('優先的に使用する地図'),
          elevation: 0,
          backgroundColor: Colors.transparent,
          // foregroundColor: Theme.of(context).textTheme.headline?.color,
        ),
        body: SettingsList(
          sections: [
            SettingsSection(
              title: const Text('選択'),
              tiles: <SettingsTile>[
                for (final e in options.entries)
                  SettingsTile(
                    title: Text(e.value),
                    trailing: primaryMap == e.key
                        ? const FaIcon(FontAwesomeIcons.check)
                        : null,
                    onPressed: (_) {
                      final primaryMapNotifier =
                          ref.read(settingPrimaryMapProvider.notifier);
                      primaryMapNotifier.update(e.key);
                      // userDb?.setSettings("primaryMap", e.key);
                      Navigator.pop(context);
                    },
                  ),
              ],
            ),
          ],
        ));
  }
}
