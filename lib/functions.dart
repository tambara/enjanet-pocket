/*
 アプリ全体で利用できる関数
 */

// Dart imports:
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// Package imports:
import 'package:crypto/crypto.dart';
import 'package:image/image.dart' as img;
import 'package:latlong2/latlong.dart';

// Project imports:
import 'package:enjanet_pocket/datas/metadata.dart';

String? computeFileSha256(File file) {
  if (!file.existsSync()) {
    return null;
  }
  return sha256.convert(file.readAsBytesSync()).toString();
}

bool checkDb(File mdFile, File dbFile) {
  final md = MetadataJson.fromJson(
      jsonDecode(mdFile.readAsStringSync()) as Map<String, dynamic>);

  return computeFileSha256(dbFile) != md.sha256;
}

Future<img.Image?> getWidgetsImage(
    BuildContext context, Size imageSize, Widget widget) async {
  // 描画、再描画を効率的に行えるようにする Class
  // ただし、ここでは Widget を画像化する機能を利用するために使っている
  final repaintBoundary = RenderRepaintBoundary();

  // 描画する場所
  // 写真のサイズで Widget が描画されるようにパラメータを渡している
  final renderView = RenderView(
    view: View.of(context),
    child: RenderPositionedBox(
        alignment: Alignment.center, child: repaintBoundary),
    configuration: ViewConfiguration(
      // size: imageSize,
      logicalConstraints: BoxConstraints(
          maxWidth: imageSize.width, maxHeight: imageSize.height),

      devicePixelRatio: 1.0,
    ),
  );

  // Widget Tree の描画を制御する Class
  final pipelineOwner = PipelineOwner();

  pipelineOwner.rootNode = renderView;
  renderView.prepareInitialFrame();

  // Widget Tree の構築、再構築を制御する Class
  final buildOwner = BuildOwner(focusManager: FocusManager());

  // 描画するもの
  // CameraOverlay() を画像化したものが最終的に欲しいもの
  final element = RenderObjectToWidgetAdapter<RenderBox>(
    container: repaintBoundary,
    child: widget,
  ).attachToRenderTree(buildOwner);

  // BuildOwner に構築する Widget Tree のスコープを指定
  buildOwner.buildScope(element);
  buildOwner.finalizeTree();

  // PipelineOwner で描画
  pipelineOwner.flushLayout();
  pipelineOwner.flushCompositingBits();
  pipelineOwner.flushPaint();

  // 画像に変換して返却する
  final ui.Image widgetImage = await repaintBoundary.toImage();
  final ByteData? byteData =
      await widgetImage.toByteData(format: ui.ImageByteFormat.png);
  return img.decodeImage(byteData!.buffer.asUint8List());
}

// Future<void> _renderOffscreenAndSave(BuildContext context) async {
//   // オフスクリーンでウィジェットを作成
//   final RenderRepaintBoundary boundary = RenderRepaintBoundary();
//   final BuildOwner buildOwner = BuildOwner();
//   final RenderView renderView = RenderView(
//     child: RenderPositionedBox(child: boundary),
//     configuration: ViewConfiguration(
//       size: Size(2000, 300), // 描画したいサイズ
//       devicePixelRatio: 1.0,
//     ),
//     window: WidgetsBinding.instance.window,
//   );

//   final PipelineOwner pipelineOwner = PipelineOwner();
//   final BuildOwner buildOwner = BuildOwner(focusManager: FocusManager());

//   pipelineOwner.rootNode = renderView;
//   renderView.prepareInitialFrame();

//   // ウィジェットツリーを構築
//   final RenderObjectToWidgetElement<RenderBox> rootElement =
//       RenderObjectToWidgetAdapter<RenderBox>(
//     container: boundary,
//     child: Container(
//       width: 2000,
//       height: 300,
//       color: Colors.blue,
//       child: Center(
//         child: Text(
//           'This is a 2000px wide widget rendered offscreen',
//           style: TextStyle(color: Colors.white, fontSize: 24),
//         ),
//       ),
//     ),
//   ).attachToRenderTree(buildOwner);

//   buildOwner.buildScope(rootElement);
//   buildOwner.finalizeTree();

//   pipelineOwner.flushLayout();
//   pipelineOwner.flushCompositingBits();
//   pipelineOwner.flushPaint();

//   final ui.Image image = await boundary.toImage(pixelRatio: 1.0);
//   final ByteData? byteData =
//       await image.toByteData(format: ui.ImageByteFormat.png);

//   if (byteData != null) {
//     // ここで byteData を使用して画像を保存したり、表示したりできます
//     // 例: 画像をファイルに保存する場合（path_providerプラグインが必要）
//     // final directory = await getApplicationDocumentsDirectory();
//     // final file = File('${directory.path}/offscreen_image.png');
//     // await file.writeAsBytes(byteData.buffer.asUint8List());

//     // 画像を表示する例
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Rendered Image'),
//         content: Image.memory(byteData.buffer.asUint8List()),
//         actions: [
//           TextButton(
//             child: Text('Close'),
//             onPressed: () => Navigator.of(context).pop(),
//           ),
//         ],
//       ),
//     );
//   }
// }

LatLng? parseLatLang(String str) {
  try {
    final latlngParts = str.split(',');
    final latitude = double.parse(latlngParts[0]);
    final longitude = double.parse(latlngParts[1]);

    return LatLng(latitude, longitude);
  } catch (e) {
    // TODO:
    return null;
  }
}
