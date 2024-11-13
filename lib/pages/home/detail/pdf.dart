// Package imports:
import 'package:path/path.dart' as p;
import 'package:pdf/src/pdf/color.dart';
import 'package:pdf/src/pdf/colors.dart';
import 'package:pdf/widgets.dart';

// Project imports:
import 'package:enjanet_pocket/datas/env.dart';

const pdfTextStyle = TextStyle(lineSpacing: 5, fontSize: 8);

Widget buildSpecificDisabilityPdf(String? text) {
  if (text == null || text.trim().isEmpty) {
    return Text("-", style: pdfTextStyle);
  }

  return Row(
      children: text.split("||").map((e) {
    PdfColor color = PdfColors.grey;

    double saturation = 0.99;
    double light = 0.80;
    switch (e) {
      case "身体":
        color = PdfColorHsl(120.0, saturation, light);
        break;
      case "知的":
        color = PdfColorHsl(0.0, saturation, light);
        break;
      case "精神":
        color = PdfColorHsl(240.0, saturation, light);
        break;
      case "児童":
        color = PdfColorHsl(60.0, saturation, light);
        break;
      case "難病":
        color = PdfColorHsl(270.0, saturation, light);
        break;
    }
    return Container(
      margin: const EdgeInsets.only(right: 5),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color,
      ),
      child: Text(e, style: pdfTextStyle),
    );
  }).toList());
}

Widget buildBrochurePdf(String? text) {
  text = text == null || text.trim().isEmpty ? "-" : "${Env.enjanetUrl}/$text";

  return Text(
    text,
    style: pdfTextStyle,
  );
}

Widget buildPresenceAbsencePdf(String? value) {
  if (value == null || value.trim().isEmpty) value = '-';

  switch (value) {
    case "0":
      value = '×';
      break;
    case "1":
      value = '○';
      break;
  }

  return Text(
    value,
    style: pdfTextStyle,
  );
}

Widget buildCircleCrossTriangleWidgetPdf(int? num) {
  String text = "-";
  switch (num) {
    case 1:
      text = "○";
      break;
    case 2:
      text = "△";
      break;
    case 3:
      text = "×";
      break;
    default:
      text = "-";
      break;
  }

  return Text(
    text,
    style: pdfTextStyle,
  );
}

Widget buildLinePdf(String title, Widget value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 6, top: 6, right: 3),
    child: Row(
      children: [
        Expanded(
            flex: 3,
            child: Text(
              title,
              style: TextStyle(
                  lineSpacing: 5, fontSize: 8, fontWeight: FontWeight.bold),
            )),
        SizedBox(
          width: 10,
        ),
        Flexible(flex: 6, child: value),
      ],
    ),
  );
}

Widget buildTextPdf(String? text) {
  text ??= '-';
  text = text.replaceAll('\r\n', '\n').replaceAll('\r', '\n').trim();
  return Text(text, style: pdfTextStyle);
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
          style: pdfTextStyle);
    }
  } catch (e) {}
  return Text("-", style: pdfTextStyle);
}

Widget buildYuMuPdf(String? text) {
  if (text == null || text.trim().isEmpty)
    return Text('-', style: pdfTextStyle);
  switch (text) {
    case "有":
      return Text("あり", style: pdfTextStyle);

    case "無":
    default:
      return Text('-', style: pdfTextStyle);
  }
}
