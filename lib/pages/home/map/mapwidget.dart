// Dart imports:
import 'dart:ui';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_map/flutter_map.dart' as fm;
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:flutter_map_pmtiles/flutter_map_pmtiles.dart' as fmp;
import 'package:flutter_map_supercluster/flutter_map_supercluster.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart' as vmp;
import 'package:vector_map_tiles_pmtiles/vector_map_tiles_pmtiles.dart' as pmt;
import 'package:vector_tile_renderer/vector_tile_renderer.dart';

// Project imports:
import 'package:enjanet_pocket/datas/appdata.dart';
import 'package:enjanet_pocket/datas/search_result.dart';
import 'package:enjanet_pocket/functions.dart';
import 'package:enjanet_pocket/layout/layout.dart';
import 'package:enjanet_pocket/pages/home/map.dart';
import 'package:enjanet_pocket/pages/home/map/attr.dart';
import 'package:enjanet_pocket/pages/home/map/style.dart';

// import 'package:flutter_map_animations/flutter_map_animations.dart';

class MapWidget extends ConsumerStatefulWidget {
  final List<SearchResult> facilities;
  final Function(SearchResult r) onPress;
  final MapMode mode;
  final LatLng center;
  final double zoom;

  const MapWidget(
      {super.key,
      required this.facilities,
      required this.onPress,
      required this.center,
      required this.zoom,
      required this.mode});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return MapWidgetState();
  }
}

class MapWidgetState extends ConsumerState<MapWidget>
    with TickerProviderStateMixin, HybridMap {
  late final SuperclusterMutableController _superclusterController =
      SuperclusterMutableController();
  late final AnimatedMapController _animatedMapController =
      AnimatedMapController(vsync: this);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _superclusterController.dispose();
    _animatedMapController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildMapWidget(
        context, widget.facilities, buildLayer(context, widget.mode));
  }

  Widget buildMapWidget(
    BuildContext context,
    List<SearchResult> facilities,
    Widget layer,
  ) {
    return fm.FlutterMap(
      mapController: _animatedMapController.mapController,
      options: fm.MapOptions(
        keepAlive: true,
        initialCenter: widget.center,
        interactionOptions: const fm.InteractionOptions(
            flags: fm.InteractiveFlag.all & ~fm.InteractiveFlag.rotate),
        initialZoom: widget.zoom,
        maxZoom: 20,
        onTap: (_, __) {
          _superclusterController.collapseSplayedClusters();
        },
      ),
      children: [
        layer,
        const OsmAttributionWidget(),
        SuperclusterLayer.mutable(
          initialMarkers: buildMarker(context, facilities),
          indexBuilder: IndexBuilders.rootIsolate,
          controller: _superclusterController,
          moveMap: (center, zoom) => _animatedMapController.animateTo(
            dest: center,
            zoom: zoom,
          ),
          onMarkerTap: (marker) {
            // _superclusterController.remove(marker);
          },
          clusterWidgetSize: const Size(35, 35),
          calculateAggregatedClusterData: true,
          builder: (context, position, markerCount, extraClusterData) =>
              Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              // border: Border.all(color: Colors.white, width: 3),
              color: Colors.amber.withOpacity(0.8),
            ),
            child: Center(
              child: Text(
                markerCount.toString(),
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<fm.Marker> buildMarker(
      BuildContext context, List<SearchResult> facilities) {
    return facilities.where((e) => e.latitude_longitude.isNotEmpty).map((e) {
      final latlong = parseLatLang(e.latitude_longitude);
      //TODO: latlongのnullチェック

      return fm.Marker(
          width: 30.0,
          height: 30.0,
          // ピンの位置を設定
          point: latlong ?? const LatLng(34.6551, 133.9195),
          rotate: true,
          child: GestureDetector(
            onTap: () {
              widget.onPress(e);
            },
            child: getCycleAvatarFromTableType(e.tableType, 30),
          ));
    }).toList();
  }
}

class DetailMap extends ConsumerStatefulWidget {
  final MapMode mode;
  final LatLng center;
  final double zoom;
  final List<LatLng> latlngs;

  const DetailMap(
      {super.key,
      required this.center,
      required this.zoom,
      required this.latlngs,
      required this.mode});

  @override
  ConsumerState<DetailMap> createState() {
    return DetailMapState();
  }
}

class DetailMapState extends ConsumerState<DetailMap>
    with TickerProviderStateMixin, HybridMap {
  late final AnimatedMapController _animatedMapController =
      AnimatedMapController(vsync: this);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _animatedMapController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildMapWidget(
        context, buildLayer(context, widget.mode), buildMarkerLayer(context));
  }

  Widget buildMapWidget(BuildContext context, Widget layer, Widget marker) {
    return fm.FlutterMap(
      mapController: _animatedMapController.mapController,
      options: fm.MapOptions(
        keepAlive: true,
        initialCenter: widget.center,
        interactionOptions: const fm.InteractionOptions(
            flags: fm.InteractiveFlag.all & ~fm.InteractiveFlag.rotate),
        initialZoom: widget.zoom,
        maxZoom: 18,
      ),
      children: [
        layer,
        marker,
        const OsmAttributionWidget(),
      ],
    );
  }

  Widget buildMarkerLayer(
    BuildContext context,
  ) {
    return MarkerLayer(markers: buildMarker(context));
  }

  List<fm.Marker> buildMarker(BuildContext context) {
    return widget.latlngs.map((latlong) {
      return fm.Marker(
        width: 48.0,
        height: 48.0,
        alignment: Alignment.topCenter,
        point: latlong,
        child: const FaIcon(
          FontAwesomeIcons.locationDot,
          color: Colors.red,
          size: 48,
        ),
      );
    }).toList();
  }
}

mixin HybridMap<T extends StatefulWidget> on State<T> {
  Widget buildLayer(BuildContext context, MapMode mapState) {
    switch (mapState) {
      case MapMode.online:
      case MapMode.none:
        return fm.TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        );
      case MapMode.raster:
        // final data = generateSolidColorImage(1, 1, Colors.red);
        return FutureBuilder<fmp.PmTilesTileProvider>(
            future: fmp.PmTilesTileProvider.fromSource(
                AppData().rasterPmtilesFile.path),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final tileProvider = snapshot.data!;
                return fm.TileLayer(
                  // maxNativeZoom:18
                  tileProvider: tileProvider,
                  // errorImage: null,
                  evictErrorTileStrategy: EvictErrorTileStrategy.none,
                  errorTileCallback: (tile, error, stackTrace) {},
                );
              }
              return const Text("");
            });
      case MapMode.vector:
        return FutureBuilder<pmt.PmTilesVectorTileProvider>(
            future: pmt.PmTilesVectorTileProvider.fromSource(
                AppData().vectorPmtilesFile.path),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final tileProvider = snapshot.data!;

                return vmp.VectorTileLayer(
                  fileCacheTtl: Duration.zero,
                  theme: ThemeReader().read(osmBrightJaStyle()),
                  tileProviders: vmp.TileProviders({
                    'openmaptiles': vmp.MemoryCacheVectorTileProvider(
                        delegate: tileProvider, maxSizeBytes: 1024 * 1024 * 2),
                  }),
                );
              }
              return const Text("");
            });
    }
  }
}

Uint8List generateSolidColorImage(int width, int height, Color color) {
  final int bytesPerPixel = 4; // RGBA
  final int stride = width * bytesPerPixel;
  final Uint8List pixels = Uint8List(width * height * bytesPerPixel);

  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      final int index = y * stride + x * bytesPerPixel;
      pixels[index] = color.red;
      pixels[index + 1] = color.green;
      pixels[index + 2] = color.blue;
      pixels[index + 3] = color.alpha;
    }
  }

  return pixels;
}
