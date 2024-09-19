// Flutter imports:
import 'package:enjanet_pocket/providers/userdb.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:vector_map_tiles_pmtiles/vector_map_tiles_pmtiles.dart' as pmt;
import 'package:vector_tile_renderer/vector_tile_renderer.dart' as vtr;

// Project imports:
import 'package:enjanet_pocket/providers/providers.dart';
import 'package:enjanet_pocket/datas/search_result.dart';
import 'package:enjanet_pocket/pages/home/map/attr.dart';
import 'package:enjanet_pocket/pages/home/map/mapwidget.dart';

// import 'package:flutter_map_animations/flutter_map_animations.dart';

enum MapMode {
  none,
  online,
  raster,
  vector,
}

// UserDbのプライマリマップの値を扱う
// final primaryMaProvider = StreamProvider<MapMode>((ref) {
//   final userDb = ref.watch(userDbProvider);
//   return userDb?.gePrimaryMap() ?? Stream.value(MapMode.online);
// });

final currentMapModeProvider = StateProvider<MapMode?>((ref) => null);

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  final vtr.Theme mapTheme = pmt.ProtomapsThemes.light();

  @override
  Widget build(BuildContext context) {
    // final primaryMap = ref.watch(primaryMaProvider);

    return Scaffold(
        body: Stack(
      children: [
        Positioned.fill(
          child: buildMain(context),
        ),
        // buildSlideUp(context),
      ],
    ));
  }

  Widget buildMain(BuildContext context) {
    final searchResults = ref.watch(searchResultsProvider);
    final primaryMap = ref.watch(settingPrimaryMapProvider);

    return Stack(children: [
      // 優先的に使う地図を取得
      // StreamProviderで書くと原因不明でDrowerが表示されなくなるためBuilderで書く
      searchResults.when(
        data: (results) {
          // 優先的に使う地図を取得
          // StreamProviderで書くと原因不明でDrowerが表示されなくなるためBuilderで書く
          MapMode? mapState = ref.watch(currentMapModeProvider);
          mapState ??= MapMode.values.firstWhere((e) {
            return e.name == primaryMap;
          }, orElse: () => MapMode.online);

          return MapWidget(
            center: const LatLng(34.6551, 133.9195),
            zoom: 10,
            facilities: results,
            onPress: (SearchResult r) {
              context.push(
                '/home/detail/${r.tableType.value}/${r.itemId}',
              );
            },
            mode: mapState,
          );
        },
        loading: () => const CircularProgressIndicator(),
        error: (error, stack) => Text('Error: $error'),
      ),
      MapModeSelectButton(),
    ]);
  }
}

/// SVGのアイコンを表示します
class IcooonMonoIcon extends StatelessWidget {
  /// [path]のアセットのSVGファイルを[size]の大きさ、[color]の色で表示します。
  const IcooonMonoIcon({
    super.key,
    required this.path,
    required this.size,
    required this.color,
  });

  final String path;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      path,
      width: size,
      height: size,
      color: color,
    );
  }
}

// mixin SlideUpDetail<T extends StatefulWidget> on State<T> {
//   PanelController panelController = PanelController();
//   final double _initFabHeight = 120.0;
//   double _fabHeight = 0;
//   double _panelHeightOpen = 0;
//   double _panelHeightClosed = 25.0;
//   ScrollController scrollController = ScrollController();
//   SearchResult? drawerData;

//   Widget _panel() {
//     if (drawerData == null) return const Text("");

//     return DetailPage(
//       itemId: drawerData!.itemId,
//       type: drawerData!.tableType,
//     );
//     // return MediaQuery.removePadding(
//     //   context: context,
//     //   removeTop: true,
//     //   child: buildDetail(),

//     // child: ListView(
//     //   physics: PanelScrollPhysics(controller: panelController),
//     //   controller: scrollController,
//     //   children: <Widget>[
//     //     SizedBox(
//     //       height: 12.0,
//     //     ),
//     //     SizedBox(
//     //       height: 18.0,
//     //     ),
//     //     Row(
//     //       mainAxisAlignment: MainAxisAlignment.center,
//     //       children: <Widget>[
//     //         Text(
//     //           "Explore Pittsburgh",
//     //           style: TextStyle(
//     //             fontWeight: FontWeight.normal,
//     //             fontSize: 24.0,
//     //           ),
//     //         ),
//     //       ],
//     //     ),
//     //     SizedBox(
//     //       height: 36.0,
//     //     ),
//     //     Row(
//     //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//     //     ),
//     //     SizedBox(
//     //       height: 36.0,
//     //     ),
//     //     // SizedBox(
//     //     //   height: 100,
//     //     //   child: HorizontalScrollableWidget(
//     //     //     child: ListView.builder(
//     //     //       scrollDirection: Axis.horizontal,
//     //     //       itemBuilder: (context, i) => SizedBox(
//     //     //         width: 100,
//     //     //         height: 100,
//     //     //         child: Placeholder(),
//     //     //       ),
//     //     //     ),
//     //     //   ),
//     //     // ),
//     //     // Container(
//     //     //   padding: const EdgeInsets.only(left: 24.0, right: 24.0),
//     //     //   child: Column(
//     //     //     crossAxisAlignment: CrossAxisAlignment.start,
//     //     //     children: <Widget>[
//     //     //       Text("Images",
//     //     //           style: TextStyle(
//     //     //             fontWeight: FontWeight.w600,
//     //     //           )),
//     //     //       SizedBox(
//     //     //         height: 12.0,
//     //     //       ),
//     //     //       Row(
//     //     //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     //     //         children: <Widget>[
//     //     //           Expanded(
//     //     //             child: ForceDraggableWidget(
//     //     //               child: Placeholder(
//     //     //                 fallbackHeight: 120,
//     //     //                 child: Center(
//     //     //                     child: Padding(
//     //     //                   padding: const EdgeInsets.all(8.0),
//     //     //                   child: Text('ForceDraggableWidget'),
//     //     //                 )),
//     //     //               ),
//     //     //             ),
//     //     //           ),
//     //     //           Expanded(
//     //     //             child: IgnoreDraggableWidget(
//     //     //               child: Placeholder(
//     //     //                 fallbackHeight: 120,
//     //     //                 child: Center(
//     //     //                   child: Padding(
//     //     //                     padding: const EdgeInsets.all(8.0),
//     //     //                     child: Text('IgnoreDraggableWidget'),
//     //     //                   ),
//     //     //                 ),
//     //     //               ),
//     //     //             ),
//     //     //           )
//     //     //         ],
//     //     //       ),
//     //     //     ],
//     //     //   ),
//     //     // ),
//     //     // SizedBox(
//     //     //   height: 36.0,
//     //     // ),
//     //     // Container(
//     //     //   padding: const EdgeInsets.only(left: 24.0, right: 24.0),
//     //     //   child: Column(
//     //     //     crossAxisAlignment: CrossAxisAlignment.start,
//     //     //     children: <Widget>[
//     //     //       Text("About",
//     //     //           style: TextStyle(
//     //     //             fontWeight: FontWeight.w600,
//     //     //           )),
//     //     //       SizedBox(
//     //     //         height: 12.0,
//     //     //       ),
//     //     //     ],
//     //     //   ),
//     //     // ),
//     //     SizedBox(
//     //       height: 24,
//     //     ),
//     //   ],
//     // )
//     // );
//   }

//   // Widget buildDetail(BuildContext context, ref) {
//   //   if (drawerData == null) return const Text("");
//   //   final userDb = AppData().userDb;
//   //   final bookmarkStream =
//   //       userDb.watchBookmark(drawerData!.itemId, drawerData!.tableType);

//   //   return Column(
//   //     children: <Widget>[
//   //       const SizedBox(
//   //         height: 12.0,
//   //       ),
//   //       const SizedBox(
//   //         height: 18.0,
//   //       ),
//   //       Row(
//   //         mainAxisAlignment: MainAxisAlignment.center,
//   //         children: <Widget>[
//   //           Text(
//   //             drawerData!.office_name,
//   //             style: const TextStyle(
//   //               fontWeight: FontWeight.normal,
//   //               fontSize: 24.0,
//   //             ),
//   //           ),
//   //         ],
//   //       ),
//   //       const SizedBox(
//   //         height: 9.0,
//   //       ),
//   //       Row(
//   //         crossAxisAlignment: CrossAxisAlignment.center,
//   //         mainAxisAlignment: MainAxisAlignment.center,
//   //         children: [
//   //           // DrawerHeaderの下の内容を記述
//   //           IconButton(
//   //             icon: const FaIcon(FontAwesomeIcons.circleInfo),
//   //             onPressed: () {
//   //               context.push(
//   //                   '/home/detail/${drawerData!.tableType.value}/${drawerData!.itemId}/${drawerData!.latitude_longitude}',
//   //                   extra: {"title": drawerData!.office_name});
//   //             },
//   //             color: Colors.blue,
//   //           ),
//   //           StreamBuilder<Bookmark?>(
//   //             stream: bookmarkStream,
//   //             builder: (context, snapshot) {
//   //               final bookmark = snapshot.data;

//   //               return IconButton(
//   //                   visualDensity: const VisualDensity(),
//   //                   onPressed:
//   //                       snapshot.connectionState == ConnectionState.waiting
//   //                           ? null
//   //                           : () {
//   //                               userDb.toggleBookmark(
//   //                                   drawerData!.itemId, drawerData!.tableType);
//   //                             },
//   //                   icon: FaIcon(
//   //                     bookmark != null
//   //                         ? FontAwesomeIcons.solidBookmark
//   //                         : FontAwesomeIcons.bookmark,
//   //                     color: Colors.blue,
//   //                   ));
//   //             },
//   //           ),
//   //         ],
//   //       ),
//   //       const SizedBox(
//   //         height: 9.0,
//   //       ),
//   //       Expanded(
//   //         child: FutureBuilder<Map<String, dynamic>>(
//   //           future: makeDetail(
//   //               context, ref, drawerData!.itemId, drawerData!.tableType),
//   //           builder: (BuildContext context,
//   //               AsyncSnapshot<Map<String, dynamic>> snapshot) {
//   //             if (snapshot.hasData) {
//   //               var items = snapshot.data!;
//   //               var entries = items.entries.toList();

//   //               return ListView.builder(
//   //                 itemCount: entries.length,
//   //                 itemBuilder: (BuildContext context, int index) {
//   //                   var e = entries[index];
//   //                   return buildLine(e.key, e.value);
//   //                 },
//   //               );
//   //             } else if (snapshot.hasError) {
//   //               return Center(
//   //                 child: Text(snapshot.error.toString()),
//   //               );
//   //             }
//   //             return const Center(
//   //               child: CircularProgressIndicator(),
//   //             );
//   //           },
//   //         ),
//   //       )
//   //     ],
//   //   );
//   // }

//   Widget buildSlideUp(BuildContext context) {
//     _panelHeightOpen = MediaQuery.of(context).size.height * .80;
//     BorderRadiusGeometry radius = const BorderRadius.only(
//       topLeft: Radius.circular(10.0),
//       topRight: Radius.circular(10.0),
//     );

//     return SlidingUpPanel(
//       backdropEnabled: true,
//       snapPoint: .5,
//       disableDraggableOnScrolling: false,
//       // footer: SizedBox(
//       //   width: MediaQuery.of(context).size.width,
//       //   height: 100,
//       // child: IgnoreDraggableWidget(
//       //   child: BottomNavigationBar(
//       //     backgroundColor: Colors.blue[50],
//       //     items: [
//       //       BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//       //       BottomNavigationBarItem(
//       //           icon: Icon(Icons.man), label: 'Profile'),
//       //       BottomNavigationBarItem(
//       //           icon: Icon(Icons.settings), label: 'Settings'),
//       //     ],
//       //   ),
//       // ),
//       // ),
//       // collapsed: Container(
//       //   decoration:
//       //       BoxDecoration(color: Colors.blueGrey, borderRadius: radius),
//       //   child: Center(
//       //     child: Text(
//       //       _drawerData?.office_name ?? "-",
//       //       style: TextStyle(color: Colors.white),
//       //     ),
//       //   ),
//       // ),

//       header: SizedBox(
//         width: MediaQuery.of(context).size.width,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ForceDraggableWidget(
//               child: Container(
//                 width: 100,
//                 height: 40,
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     const SizedBox(
//                       height: 12.0,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         Container(
//                           width: 30,
//                           height: 7,
//                           decoration: const BoxDecoration(
//                               color: Colors.blueAccent,
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(12.0))),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       maxHeight: _panelHeightOpen,
//       minHeight: _panelHeightClosed,
//       parallaxEnabled: true,
//       parallaxOffset: .5,
//       controller: panelController,
//       scrollController: scrollController,
//       panelBuilder: () => _panel(),
//       borderRadius: radius,
//       onPanelSlide: (double pos) => setState(() {
//         _fabHeight =
//             pos * (_panelHeightOpen - _panelHeightClosed) + _initFabHeight;
//       }),
//     );
//   }
// }
