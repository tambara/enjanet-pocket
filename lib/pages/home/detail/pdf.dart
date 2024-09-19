// Package imports:
import 'package:path/path.dart' as p;
import 'package:pdf/src/pdf/color.dart';
import 'package:pdf/src/pdf/colors.dart';
import 'package:pdf/widgets.dart';

// Project imports:
import 'package:enjanet_pocket/datas/env.dart';

Widget buildSpecificDisabilityPdf(String? text) {
  if (text == null) return Text('-');
  return Row(
      children: text.split("||").map((e) {
    PdfColor color = PdfColors.grey;

    double saturation = 0.99;
    double light = 0.80;
    switch (e) {
      case "身体":
        color = PdfColorHsl(120.0, saturation, light);
      case "知的":
        color = PdfColorHsl(0.0, saturation, light); // 赤
      case "精神":
        color = PdfColorHsl(240.0, saturation, light); // 赤
      case "児童":
        color = PdfColorHsl(60.0, saturation, light); // 赤
      case "難病":
        color = PdfColorHsl(270.0, saturation, light); // 紫
    }
    return Container(
      margin: const EdgeInsets.only(right: 5),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(32)),
        border: Border.all(
          width: 2,
          color: PdfColors.white,
        ),
        color: color,
      ),
      child: Text(e,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          )),
    );
  }).toList());
}

Widget buildBrochurePdf(String? text) {
  if (text == null) return Text('-');

  var url = text.trim();

  try {
    if (url.isNotEmpty) {
      url = p.normalize(Env.enjanetUrl + "/" + url);

      return Text(
        url,
        // color: Colors.blue,
        // icon: FaIcon(
        //   FontAwesomeIcons.download,
        // )
      );
    }
  } catch (e) {}
  return Text("-");

  // return buildLink(p.normalize(Env.enjanetUrl + "/" + text));
}

Widget buildPresenceAbsencePdf(String? value) {
  if (value == null || value.trim().isEmpty) return Text('-');
  switch (value) {
    case "1":
      return Text(
        '○',
        style: const TextStyle(fontSize: 22),
      );
    case "0":
      return Text(
        '×',
        style: const TextStyle(fontSize: 22),
      );
    default:
      return Text('想定外の値:$value');
  }
}

Widget buildCircleCrossTriangleWidgetPdf(int? num) {
  if (num == null) {
    return Text("-");
  }
  PdfColor color = PdfColors.black;
  String text = "-";
  switch (num) {
    case 1:
      color = PdfColors.blue;
      text = "○";
    case 2:
      color = PdfColors.red;
      text = "△";

    case 3:
      color = PdfColors.yellow;
      text = "×";
  }
  return Text(
    text,
    style: TextStyle(
      color: color,
      // fontFeatures: const [FontFeature.tabularFigures()],
      fontSize: 32,
      fontWeight: FontWeight.bold,
    ),
  );
}

Widget buildLinePdf(String title, Widget value) {
  return Column(
    children: [
      Padding(
          padding: const EdgeInsets.only(left: 16.0, bottom: 16.0, top: 16.0),
          child: Row(
            children: [
              Expanded(
                  flex: 3,
                  child: Text(title,
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center)),
              SizedBox(
                width: 10,
              ),
              Flexible(flex: 6, child: value),
            ],
          )),
      Divider(
        height: 1,
        indent: 16,
        endIndent: 16,
        color: PdfColors.grey,
      )
    ],
  );
}

Widget buildTextPdf(String? text) {
  if (text == null) return Text('-');

  text = text.trim();
  return Text(text.isNotEmpty ? text : '-');
}

Widget buildLinkPdf(String? url) {
  if (url == null) return Text("-");

  url = url.trim();
  try {
    if (url.isNotEmpty) {
      return Text(
        // linkStyle: const TextStyle(color: PdfColors.blue),
        // onOpen: (link) async {
        //   if (!await launchUrl(Uri.parse(link.url))) {
        //     throw Exception('Could not launch ${link.url}');
        //   }
        // },
        url,
      );
    }
  } catch (e) {}
  return Text("-");
}

Widget buildYuMuPdf(String? text) {
  if (text == null || text.trim().isEmpty) return Text('-');
  switch (text) {
    case "有":
      return Text("あり");

    case "無":
    default:
      return Text('-');
  }
}
