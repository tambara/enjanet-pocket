// Dart imports:
import 'dart:ui' as ui;
import 'dart:ui';

// Flutter imports:
import 'package:enjanet_pocket/providers/userdb.dart';
import 'package:enjanet_pocket/widgets/dialogs.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:path/path.dart' as p;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:enjanet_pocket/datas/env.dart';
import 'package:enjanet_pocket/providers/providers.dart';
import 'package:enjanet_pocket/datas/searchtable.dart';
import 'package:enjanet_pocket/pages/home/detail/common.dart';
import 'package:enjanet_pocket/pages/home/detail/disabilityService.dart';
import 'package:enjanet_pocket/pages/home/detail/helperStationPage.dart';
import 'package:enjanet_pocket/pages/home/detail/hospitalClinicPage.dart';
import 'package:enjanet_pocket/pages/home/detail/panningConsultationPage.dart';
import 'package:enjanet_pocket/pages/home/detail/pdf.dart';
import 'package:enjanet_pocket/pages/home/map.dart';
import 'package:enjanet_pocket/pages/home/map/attr.dart';
import 'package:enjanet_pocket/pages/home/map/mapwidget.dart';
import 'package:enjanet_pocket/route.dart';
import 'detail/childServicePage.dart';

// ignore: unused_import

class DetailData {
  String title;
  Map<String, dynamic> widgets;
  String pageUrl;
  final LatLng? latlang;
  final Uint8List? eyecatch;

  DetailData(
      {required this.title,
      required this.widgets,
      required this.pageUrl,
      required this.latlang,
      required this.eyecatch});
}

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  const _StickyTabBarDelegate({required this.tabBar});

  final TabBar tabBar;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Material(
      color: Colors.grey[200],
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_StickyTabBarDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar;
  }
}

class DetailPage extends ConsumerWidget {
  final int itemId;
  final SearchTableNameEnum type;

  const DetailPage({super.key, required this.itemId, required this.type});

  Widget buildMap(BuildContext context, WidgetRef ref, LatLng latLng) {
    final primaryMap = ref.watch(settingPrimaryMapProvider);
    MapMode? mapState = ref.watch(currentMapModeProvider);
    mapState ??= MapMode.values.firstWhere((e) {
      return e.name == primaryMap;
    }, orElse: () => MapMode.online);

    return Stack(children: [
      DetailMap(
        center: latLng,
        zoom: 14,
        latlngs: [latLng],
        mode: mapState,
      ),
      MapModeSelectButton(),
    ]);
  }

  Widget buildTab() {
    return const SliverPersistentHeader(
      pinned: true,
      delegate: _StickyTabBarDelegate(
        tabBar: TabBar(
          tabs: [
            Tab(
              child: FaIcon(
                FontAwesomeIcons.info,
                color: Colors.black,
              ),
            ),
            Tab(
              child: FaIcon(
                FontAwesomeIcons.map,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBody(BuildContext context, WidgetRef ref, DetailData items) {
    var entries = items.widgets.entries.toList();

    return CustomScrollView(slivers: [
      SliverAppBar(
        pinned: true,
        title: Row(
          children: [
            Expanded(
              child: Text(items.title,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            Consumer(
              builder: (BuildContext context, WidgetRef ref, Widget? child) {
                final bookmark =
                    ref.watch(bookmarkProvider((itemId: itemId, table: type)));

                return bookmark != null
                    ? IconButton(
                        // iconSize: 24 * 0.9,
                        visualDensity: const VisualDensity(),
                        onPressed: () {
                          final bookmarkNotifier = ref.read(
                              bookmarkProvider((itemId: itemId, table: type))
                                  .notifier);
                          bookmarkNotifier.toggleBookmark();
                        },
                        icon: Icon(
                          bookmark
                              ? FontAwesomeIcons.solidBookmark
                              : FontAwesomeIcons.bookmark,
                          color: Colors.blue,
                        ))
                    : const Text("");
              },
            ),
          ],
        ),
      ),
      SliverToBoxAdapter(
          child: Column(children: [
        const SizedBox(height: 20),
        const Text(
          "事業所情報",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        const SizedBox(height: 20),
        if (items.eyecatch != null)
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white, // 枠の色
                width: 2.0, // 枠の太さ
              ),
            ),
            child: CircleAvatar(
              radius: 32,
              backgroundImage: MemoryImage(items.eyecatch!),
            ),
          ),
        const SizedBox(height: 20),
      ])),
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            final e = entries[index];
            return buildLine(e.key, e.value);
          },
          childCount: entries.length,
        ),
      ),
      SliverToBoxAdapter(
        child: Column(
          children: [
            Divider(
              height: 1,
              indent: 16,
              endIndent: 16,
              color: Colors.grey[200],
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Text(
                  "※空白（または-）部分は事業所からの情報を頂いておりません。詳細につきましては直接事業所にお問い合わせください"),
            ),
            const SizedBox(height: 20),
            const Text(
              "周辺地図",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 20),
            Container(
                height: 400,
                color: Colors.grey[200],
                child: (items.latlang != null) // 緯度経度が未入力なら 未入力 を表示
                    ? buildMap(context, ref, items.latlang!)
                    : const Text("未入力")),
          ],
        ),
      ),
    ]);

    //   return NestedScrollView(
    //     headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
    //       return [
    //         SliverAppBar(
    //           pinned: true,
    //           title: Row(
    //             children: [
    //               // getCycleAvatarFromTableType(type, 18),
    //               // const SizedBox(
    //               //   width: 10,
    //               // ),
    //               Expanded(
    //                 child: Text(items.title,
    //                     style: const TextStyle(fontWeight: FontWeight.bold)),
    //               ),

    //               Consumer(
    //                 builder:
    //                     (BuildContext context, WidgetRef ref, Widget? child) {
    //                   final bookmark = ref
    //                       .watch(bookmarkProvider((itemId: itemId, table: type)));

    //                   return bookmark != null
    //                       ? IconButton(
    //                           // iconSize: 24 * 0.9,
    //                           visualDensity: const VisualDensity(),
    //                           onPressed: () {
    //                             final bookmarkNotifier = ref.read(
    //                                 bookmarkProvider(
    //                                     (itemId: itemId, table: type)).notifier);
    //                             bookmarkNotifier.toggleBookmark();
    //                           },
    //                           icon: Icon(
    //                             bookmark
    //                                 ? FontAwesomeIcons.solidBookmark
    //                                 : FontAwesomeIcons.bookmark,
    //                             color: Colors.blue,
    //                           ))
    //                       : const Text("");
    //                 },
    //               ),
    //             ],
    //           ),
    //         ),
    //         // buildTab(),
    //       ];
    //     },
    //     // body: TabBarView(children: [
    //     body: ListView(children: [
    //       const SizedBox(height: 20),
    //       const Text(
    //         "事業所情報",
    //         textAlign: TextAlign.center,
    //         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
    //       ),
    //       const SizedBox(height: 20),
    //       // buildDetail(makeDetail(context, ref, itemId, type)),
    //       ListView.separated(
    //         shrinkWrap: true,
    //         physics: ClampingScrollPhysics(),
    //         itemBuilder: (BuildContext context, int index) {
    //           final e = entries[index];
    //           return buildLine(e.key, e.value);
    //         },
    //         separatorBuilder: (BuildContext context, int index) {
    //           return Divider(
    //             height: 1,
    //             indent: 16,
    //             endIndent: 16,
    //             color: Colors.grey[200],
    //           );
    //         },
    //         itemCount: entries.length,
    //       ),
    //       Divider(
    //         height: 1,
    //         indent: 16,
    //         endIndent: 16,
    //         color: Colors.grey[200],
    //       ),
    //       const SizedBox(height: 20),
    //       const Padding(
    //         padding: EdgeInsets.symmetric(
    //           horizontal: 16,
    //         ),
    //         child:
    //             Text("※空白（または-）部分は事業所からの情報を頂いておりません。詳細につきましては直接事業所にお問い合わせください"),
    //       ),
    //       const SizedBox(height: 20),

    //       const Text(
    //         "周辺地図",
    //         textAlign: TextAlign.center,
    //         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
    //       ),

    //       const SizedBox(height: 20),
    //       Container(
    //           height: 400,
    //           color: Colors.grey[200],
    //           child: (items.latlang != null) // 緯度経度が未入力なら 未入力 を表示
    //               ? buildMap(context, ref, items.latlang!)
    //               : const Text("未入力")),
    //     ]),
    //   );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final bookmarkStream = userDb?.watchBookmark(itemId, type);

    return FutureBuilder<DetailData?>(
      future: makeDetail(context, ref, itemId, type),
      builder: (BuildContext context, AsyncSnapshot<DetailData?> snapshot) {
        if (snapshot.hasData) {
          var items = snapshot.data!;

          return Scaffold(
              bottomNavigationBar: BottomAppBar(
                height: 50,
                notchMargin: 0,
                elevation: 0,
                padding: EdgeInsets.zero,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton.icon(
                        label: const Text("印刷"),
                        onPressed: () async {
                          // final r =
                          //     await showDialog<MapConfirmationDialogResult?>(
                          //   context: context,
                          //   builder: (context) => Dialog.fullscreen(
                          //       child: MapConfirmationDialog(
                          //           latlng: items.latlang)),
                          // );
                          // if (r == null) {
                          //   return;
                          // }
                          await context
                              .push("/home/print/${type.value}/$itemId");
                        },
                        icon: const FaIcon(
                          FontAwesomeIcons.print,
                          color: Colors.blue,
                        )),
                    TextButton.icon(
                        label: const Text("え〜んじゃネットへ"),
                        onPressed: () async {
                          if (await showOkCancel(
                                  context, "え〜んじゃネットにアクセスしますか？") ==
                              true) {
                            // 外部リンクを開く
                            final url = p.normalize(
                                "${Env.enjanetUrl}/${items.pageUrl}");

                            await launchUrl(Uri.parse(url));
                          }
                        },
                        icon: const FaIcon(
                          color: Colors.blue,
                          FontAwesomeIcons.globe,
                        )), // IconButton(
                  ],
                ),
              ),
              body: buildBody(context, ref, items));
          //  buildDetail(appDb),
        } else if (snapshot.hasError) {
          return buildError(
              snapshot.error.toString(), snapshot.stackTrace.toString());
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

Future<DetailData?> makeDetail(BuildContext context, WidgetRef ref, int itemId,
    SearchTableNameEnum type) async {
  if (type == SearchTableNameEnum.hospitalsClinics) {
    return buildHospitalClinic(context, ref, itemId);
  }
  // if (type == SearchTable.groupHomes.value) {
  //   return ChildServicePage(itemId: id);
  // }
  if (type == SearchTableNameEnum.childServices) {
    return buildMapChildService(context, ref, itemId);
  }
  if (type == SearchTableNameEnum.planningConsultations) {
    return buildPlanningConsultation(context, ref, itemId);
  }
  if (type == SearchTableNameEnum.helperStations) {
    return buildHelperStation(context, ref, itemId);
  }
  if (type == SearchTableNameEnum.disabilityServices) {
    return buildDisabilityService(context, ref, itemId);
  }

  return null;
}

Future<Uint8List> buildPdf(String title, PdfPageFormat format,
    Map<String, pw.Widget> map, pw.MemoryImage? mapImage) async {
  pw.Document doc = pw.Document();
  // doc.addPage(
  //   pw.Page(
  //     pageFormat: format,
  //     build: (pw.Context context) {
  //       return pw.ConstrainedBox(
  //         constraints: pw.BoxConstraints.expand(),
  //         child: pw.FittedBox(
  //           child: pw.Text('Hello World'),
  //         ),
  //       );
  //     },
  //   ),
  // );
  // final font1 = data.testing
  //     ? pw.Font.helvetica()
  //     : await PdfGoogleFonts.openSansRegular();
  // final font2 = data.testing
  //     ? pw.Font.helveticaBold()

  final entries = map.entries.toList();
  var font1 = pw.Font.ttf(
      await rootBundle.load("assets/fonts/BIZUDPGothic-Regular.ttf"));
  var font2 =
      pw.Font.ttf(await rootBundle.load("assets/fonts/BIZUDPGothic-Bold.ttf"));

  doc.addPage(pw.MultiPage(
      theme: pw.ThemeData.withFont(
        base: font1,
        bold: font2,
      ),
      pageFormat: format,
      // orientation: pw.PageOrientation.portrait,
      // crossAxisAlignment: pw.CrossAxisAlignment.start,
      header: (pw.Context context) {
        if (context.pageNumber == 1) {
          return pw.SizedBox();
        }

        return pw.Container(
            alignment: pw.Alignment.centerRight,
            // margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            // padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            // decoration: const pw.BoxDecoration(
            //     border: pw.Border(
            //         bottom: pw.BorderSide(width: 0.5, color: PdfColors.grey))),
            child: pw.Text(title,
                style: pw.Theme.of(context)
                    .defaultTextStyle
                    .copyWith(fontSize: 8, color: PdfColors.grey)));
      },
      footer: (pw.Context context) {
        return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
            child: pw.Text('${context.pageNumber} / ${context.pagesCount}',
                style: pw.Theme.of(context)
                    .defaultTextStyle
                    .copyWith(fontSize: 8, color: PdfColors.grey)));
      },
      build: (pw.Context context) {
        var items = <pw.Widget>[
          pw.Header(
              level: 0,
              title: title,
              decoration: const pw.BoxDecoration(
                border: pw.Border(
                  bottom: pw.BorderSide(
                    color: PdfColors.grey100, // 下線の色を変更
                    width: 1.0, // 下線の太さを指定
                  ),
                ),
              ),
              child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: <pw.Widget>[
                    pw.Text(title, textScaleFactor: 2),
                  ])),
          pw.ListView.separated(
            itemCount: entries.length,
            itemBuilder: (pw.Context context, int index) {
              var e = entries[index];
              return buildLinePdf(e.key, e.value);
            },
            separatorBuilder: (pw.Context context, int index) {
              return pw.Divider(
                height: 1,
                color: PdfColors.grey100,
              );
            },
          ),
          pw.SizedBox(
            height: 8,
          ),
          pw.Paragraph(
              style: pdfTextStyle,
              text: '※空白（または-）部分は事業所からの情報を頂いておりません。詳細につきましては直接事業所にお問い合わせください')
        ];
        // if (mapImage != null) {
        //   items.addAll(<pw.Widget>[
        //     pw.Text('周辺地図',
        //         style: pw.Theme.of(context).header0,
        //         textAlign: pw.TextAlign.center),
        //     pw.SizedBox(height: 20),
        //     pw.Center(
        //       child: pw.Container(
        //         color: PdfColors.grey,
        //         child: pw.Image(mapImage),
        //       ),
        //     ),
        //   ]);
        // }

        return items;
      }));
  if (mapImage != null) {
    doc.addPage(
      pw.Page(
        theme: pw.ThemeData.withFont(
          base: font1,
          bold: font2,
        ),
        pageFormat: format,
        // orientation: pw.PageOrientation.portrait,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('周辺地図', style: pw.Theme.of(context).header0),
              pw.SizedBox(height: 20),
              pw.Center(
                child: pw.Container(
                  color: PdfColors.grey,
                  child: pw.Image(mapImage),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  return await doc.save();
}

enum PrintMode {
  none,
  print,
  preview,
}

class MapConfirmationDialogResult {
  Uint8List? image;
  bool printMap;
  PrintMode printMode;

  MapConfirmationDialogResult(this.image, this.printMap, this.printMode);
}

class PrintPage extends ConsumerStatefulWidget {
  final int itemId;
  final SearchTableNameEnum type;

  PrintPage({super.key, required this.itemId, required this.type});

  @override
  ConsumerState<PrintPage> createState() => _MapConfirmationDialogState();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

class _MapConfirmationDialogState extends ConsumerState<PrintPage> {
  bool _excludeMap = false;
  final repaintBoundaryKey = GlobalKey();

  Future<Uint8List?> captureMap(BuildContext context) async {
    try {
      final boundary = repaintBoundaryKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) return null;
      ui.Image image = await boundary.toImage(pixelRatio: 1.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      if (kDebugMode) {
        print('Error capturing map: $e');
      }
      return null;
    }
  }

  Widget buildMap(BuildContext context, WidgetRef ref, LatLng? latlng) {
    final primaryMap = ref.watch(settingPrimaryMapProvider);
    var mapState = ref.watch(currentMapModeProvider);
    mapState ??= MapMode.values.firstWhere((e) {
      return e.name == primaryMap;
    }, orElse: () => MapMode.online);

    return Stack(children: [
      RepaintBoundary(
        key: repaintBoundaryKey,
        child: DetailMap(
          center: latlng ?? defaltLatLng,
          zoom: 14,
          mode: mapState,
          latlngs: [latlng ?? defaltLatLng],
        ),
      ),
      MapModeSelectButton(),
    ]);
  }

/*

 */

  Widget buildBody(DetailData data) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('印刷する地図の範囲を確認・修正してください。'),
          const SizedBox(height: 16),
          Container(
            width: 500,
            height: 500,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
            ),
            child: FittedBox(
              child: RepaintBoundary(
                child: Container(
                  width: 1000,
                  height: 1000,
                  color: Colors.blue,
                  child: buildMap(context, ref, data.latlang),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Checkbox(
              value: _excludeMap,
              onChanged: (bool? value) {
                setState(() {
                  _excludeMap = value ?? false;
                });
              },
            ),
            const Text('地図を印刷しない'),
          ]),
          const SizedBox(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(
              onPressed: () async {
                Uint8List? mapData;
                if (!_excludeMap) {
                  mapData = await captureMap(context);
                }
                await _printAdvancedDocument(data.title, context, ref,
                    widget.itemId, widget.type, mapData);
              },
              child: const Text('印刷する'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () async {
                Uint8List? mapData;
                if (!_excludeMap) {
                  mapData = await captureMap(context);
                }
                await _previewAdvancedDocument(data.title, context, ref,
                    widget.itemId, widget.type, mapData);
              },
              child: const Text('印刷プレビュー'),
            ),
          ]),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('印刷'),
        ),
        body: FutureBuilder<DetailData?>(
            future: makeDetail(context, ref, widget.itemId, widget.type),
            builder:
                (BuildContext context, AsyncSnapshot<DetailData?> snapshot) {
              if (snapshot.hasData) {
                var items = snapshot.data!;
                return buildBody(items!);
              } else if (snapshot.hasError) {
                throw Exception('${snapshot.error!}');
              } else {
                return const CircularProgressIndicator();
              }
            }));
  }

  Future<void> _printAdvancedDocument(
    String title,
    BuildContext context,
    WidgetRef ref,
    int itemId,
    SearchTableNameEnum type,
    Uint8List? byteData,
  ) async {
    Map<String, pw.Widget>? data;

    if (type == SearchTableNameEnum.hospitalsClinics) {
      data = await buildHospitalClinicPdf(context, ref, itemId);
    }
    // if (type == SearchTable.groupHomes.value) {
    //   return ChildServicePage(itemId: id);
    // }
    if (type == SearchTableNameEnum.childServices) {
      data = await buildChildServicePdf(context, ref, itemId);
    }
    if (type == SearchTableNameEnum.planningConsultations) {
      data = await buildPlanningConsultationPdf(context, ref, itemId);
    }
    if (type == SearchTableNameEnum.helperStations) {
      data = await buildHelperStationPdf(context, ref, itemId);
    }
    if (type == SearchTableNameEnum.disabilityServices) {
      data = await buildDisabilityServicePdf(context, ref, itemId);
    }

    if (data == null) {
      throw Exception("データがありません");
    }

    // 地図
    pw.MemoryImage? mapImage;
    if (byteData != null) {
      mapImage = pw.MemoryImage(
        byteData.buffer.asUint8List(),
      );
    }

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) {
        return buildPdf(title, format, data!, mapImage);
      },
    );
  }

  Future<void> _previewAdvancedDocument(
    String title,
    BuildContext context,
    WidgetRef ref,
    int itemId,
    SearchTableNameEnum type,
    Uint8List? byteData,
  ) async {
    Map<String, pw.Widget>? data;

    if (type == SearchTableNameEnum.hospitalsClinics) {
      data = await buildHospitalClinicPdf(context, ref, itemId);
    }
    // if (type == SearchTable.groupHomes.value) {
    //   return ChildServicePage(itemId: id);
    // }
    if (type == SearchTableNameEnum.childServices) {
      data = await buildChildServicePdf(context, ref, itemId);
    }
    if (type == SearchTableNameEnum.planningConsultations) {
      data = await buildPlanningConsultationPdf(context, ref, itemId);
    }
    if (type == SearchTableNameEnum.helperStations) {
      data = await buildHelperStationPdf(context, ref, itemId);
    }
    if (type == SearchTableNameEnum.disabilityServices) {
      data = await buildDisabilityServicePdf(context, ref, itemId);
    }

    if (data == null) {
      throw Exception("データがありません");
    }

    // 地図
    pw.MemoryImage? mapImage;
    if (byteData != null) {
      mapImage = pw.MemoryImage(
        byteData.buffer.asUint8List(),
      );
    }
    final r = await showDialog<bool?>(
      context: context,
      builder: (context) => Dialog.fullscreen(
        child: Scaffold(
            appBar: AppBar(
              title: const Text("印刷プレビュー"),
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(null),
              ),
            ),
            body: PdfPreview(
              build: (format) async {
                return buildPdf(title, format, data!, mapImage);
              },
            )),
      ),
    );

    if (r == null) {
      return;
    }
  }
}
