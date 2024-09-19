// Flutter imports:
import 'package:enjanet_pocket/providers/userdb.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

// Project imports:
import 'package:enjanet_pocket/pages/home/map.dart';

class OsmAttributionWidget extends StatelessWidget {
  const OsmAttributionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleAttributionWidget(
      onTap: () => launchUrlString('https://openstreetmap.org/copyright'),
      source: const Text('OpenStreetMap contributors'),
    );
  }
}
// class FloatingMenuButton extends ConsumerWidget {
//   const FloatingMenuButton({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return PositionedDirectional(
//       start: 16,
//       top: 16,
//       child: SafeArea(
//         child: Container(
//           decoration: BoxDecoration(
//             // color: Theme.of(context).colorScheme.surface,
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(999),
//           ),
//           padding: const EdgeInsets.all(8),
//           child: Row(
//             children: [
//               // IconButton(
//               //   onPressed: () => Scaffold.of(context).openDrawer(),
//               //   icon: const Icon(Icons.menu),
//               // ),
//               IconButton(
//                 icon: FaIcon(FontAwesomeIcons.globe, size: 32),
//                 onPressed: () {
//                   var mapModeProviderNotifier =
//                       ref.read(mapModeProvider.notifier);
//                   mapModeProviderNotifier.state = MapMode.online;
//                 },
//               ),
//               const SizedBox(width: 8),
//               // Image.asset('assets/ProjectIcon.png', height: 32, width: 32),
//               IconButton(
//                 icon: FaIcon(FontAwesomeIcons.image, size: 32),
//                 onPressed: () {
//                   var mapModeProviderNotifier =
//                       ref.read(mapModeProvider.notifier);
//                   mapModeProviderNotifier.state = MapMode.raster;
//                 },
//               ),
//               const SizedBox(width: 8),
//               IconButton(
//                 icon: FaIcon(FontAwesomeIcons.vectorSquare, size: 32),
//                 onPressed: () {
//                   var mapModeProviderNotifier =
//                       ref.read(mapModeProvider.notifier);
//                   mapModeProviderNotifier.state = MapMode.vector;
//                 },
//               ),
//               const SizedBox(width: 8),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class MapModeSelectButton extends ConsumerStatefulWidget {
  @override
  ConsumerState<MapModeSelectButton> createState() => _IconRadioButtonState();
}

class _IconRadioButtonState extends ConsumerState<MapModeSelectButton> {
  final Map<MapMode, IconData> _icons = {
    MapMode.online: FontAwesomeIcons.globe,
    MapMode.raster: FontAwesomeIcons.image,
    // MapMode.vector: FontAwesomeIcons.vectorSquare,
  };

  @override
  Widget build(BuildContext context) {
    var mapState = ref.watch(currentMapModeProvider);
    var primaryMap = ref.watch(settingPrimaryMapProvider);
    MapMode mapMode = mapState ??= MapMode.values.firstWhere((e) {
      return e.name == primaryMap;
    }, orElse: () => MapMode.online);
    return PositionedDirectional(
      start: 16,
      top: 16,
      child: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            // color: Theme.of(context).colorScheme.surface,
            color: Colors.white,
            borderRadius: BorderRadius.circular(999),
          ),
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_icons.length, (index) {
              return IconButton(
                icon: FaIcon(
                  _icons.values.elementAt(index),
                  size: 32,
                  color: mapMode == _icons.keys.elementAt(index)
                      ? Colors.blue
                      : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    var mapModeProviderNotifier =
                        ref.read(currentMapModeProvider.notifier);

                    mapModeProviderNotifier.state =
                        _icons.keys.elementAt(index);
                  });
                },
              );
            }),
          ),
        ),
      ),
    );
  }
}

class MapSelectButton extends ConsumerStatefulWidget {
  @override
  _MapSelectButtonState createState() => _MapSelectButtonState();
}

class _MapSelectButtonState extends ConsumerState<MapSelectButton> {
  final Map<MapMode, IconData> _icons = {
    MapMode.online: FontAwesomeIcons.globe,
    MapMode.raster: FontAwesomeIcons.image,
    // MapMode.vector: FontAwesomeIcons.vectorSquare,
  };

  @override
  Widget build(BuildContext context) {
    var mapState = ref.watch(currentMapModeProvider);
    var primaryMap = ref.watch(settingPrimaryMapProvider);
    MapMode mapMode = mapState ??= MapMode.values.firstWhere((e) {
      return e.name == primaryMap;
    }, orElse: () => MapMode.online);

    return PositionedDirectional(
      start: 16,
      top: 16,
      child: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            // color: Theme.of(context).colorScheme.surface,
            color: Colors.white,
            borderRadius: BorderRadius.circular(999),
          ),
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_icons.length, (index) {
              return IconButton(
                icon: FaIcon(
                  _icons.values.elementAt(index),
                  size: 32,
                  color: mapMode == _icons.keys.elementAt(index)
                      ? Colors.blue
                      : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    var mapModeProviderNotifier =
                        ref.read(currentMapModeProvider.notifier);

                    mapModeProviderNotifier.state =
                        _icons.keys.elementAt(index);
                  });
                },
              );
            }),
          ),
        ),
      ),
    );
  }
}
