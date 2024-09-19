import 'package:enjanet_pocket/providers/userdb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingsCheckUpdatesPage extends ConsumerWidget {
  static final Map<bool, String> options = {
    true: '起動時',
    false: '手動',
  };
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkUpdates = ref.watch(settingCheckUpdatesProvider);
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
                for (final e in options.entries)
                  SettingsTile(
                    title: Text(e.value),
                    trailing: checkUpdates == e.key
                        ? const FaIcon(FontAwesomeIcons.check)
                        : null,
                    onPressed: (_) {
                      final checkUpdatesNotifier =
                          ref.read(settingCheckUpdatesProvider.notifier);
                      checkUpdatesNotifier.update(e.key);
                      // userDb?.setSettings("checkUpdates", e.key);
                      Navigator.pop(context);
                    },
                  ),
              ],
            ),
          ],
        ));
  }
}
