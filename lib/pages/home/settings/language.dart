import 'package:enjanet_pocket/providers/userdb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingsLanguageTypePage extends ConsumerWidget {
  static final Map<String, String> options = {
    'ja': '日本語',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final languageType = ref.watch(settingLanguageTypeProvider);
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
                    trailing: languageType == e.key
                        ? const FaIcon(FontAwesomeIcons.check)
                        : null,
                    onPressed: (_) {
                      Navigator.pop(context);
                    },
                  ),
              ],
            ),
          ],
        ));
  }
}
