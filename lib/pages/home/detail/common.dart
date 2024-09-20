// Flutter imports:
import 'package:enjanet_pocket/thema/color.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:enjanet_pocket/datas/env.dart';

Widget buildYuMu(String? text) {
  if (text == null || text.trim().isEmpty) return const SelectableText('-');
  switch (text) {
    case "有":
      return const SelectableText("あり");

    case "無":
    default:
      return const SelectableText('-');
  }
}

Widget buildPhoto(BuildContext context, String? text, String pageUrl) {
  if (text == null || text.trim().isEmpty) return const SelectableText('-');

  final num = text.split("||").length;

  var url = p.normalize("${Env.enjanetUrl}/$pageUrl");

  return Row(children: [
    Text("$num枚"),
    IconButton(
        iconSize: 16,
        onPressed: () async {
          await launchUrl(Uri.parse(url));
        },
        color: Colors.blue,
        icon: const FaIcon(
          FontAwesomeIcons.upRightFromSquare,
        ))
  ]);
}

Widget buildSpecificDisability(BuildContext context, String? text) {
  if (text == null || text.trim().isEmpty) return const SelectableText('-');

  final thema = Theme.of(context).extension<DetailsColors>();
  if (thema == null) {
    throw Exception("DetailsColors is null");
  }

  return Wrap(
      children: text.split("||").map((e) {
    Color color = Colors.grey;

    switch (e) {
      case "身体":
        color = thema.physicalDisabilityColor;
      case "知的":
        color = thema.intellectualDisabilityColor;
      case "精神":
        color = thema.mentalDisabilityColor;
      case "児童":
        color = thema.childDisabilityColor;
      case "難病":
        color = thema.intractableDiseaseColor;
    }
    return Container(
      margin: const EdgeInsets.only(right: 5),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(32)),
        border: Border.all(
          width: 2,
          color: Colors.white,
        ),
        color: color,
      ),
      child: SelectableText(e,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          )),
    );
  }).toList());
}

Widget buildBrochure(BuildContext context, String? text, String pageUrl) {
  if (text == null || text.trim().isEmpty) return const SelectableText('-');

  var url = p.normalize("${Env.enjanetUrl}/$pageUrl");

  return Row(children: [
    const SelectableText("あり"),
    IconButton(
        iconSize: 16,
        onPressed: () async {
          await launchUrl(Uri.parse(url));
        },
        color: Colors.blue,
        icon: const FaIcon(
          FontAwesomeIcons.upRightFromSquare,
        ))
  ]);
}

Widget buildCircleCrossTriangleWidget(int? num) {
  if (num == null) {
    return const SelectableText("-");
  }
  Color color = Colors.black;
  String text = "-";
  switch (num) {
    case 1:
      color = Colors.blue;
      text = "○";
    case 2:
      color = Colors.red;
      text = "△";

    case 3:
      color = Colors.yellow;
      text = "×";
  }
  return SelectableText(
    text,
    style: TextStyle(
      color: color,
      fontFeatures: const [FontFeature.tabularFigures()],
      fontSize: 32,
      fontWeight: FontWeight.bold,
    ),
  );
}

Widget buildText(String? text) {
  if (text == null || text.trim().isEmpty) return const SelectableText('-');

  return SelectableText(text);
}

Widget buildUrl(String? text) {
  if (text == null || text.trim().isEmpty) return const SelectableText('-');

  return Linkify(
    linkStyle: const TextStyle(color: Colors.blue),
    onOpen: (link) async {
      if (!await launchUrl(Uri.parse(link.url))) {
        throw Exception('Could not launch ${link.url}');
      }
    },
    text: text,
  );
}

Widget buildPresenceAbsenceWidget(String? value) {
  if (value == null || value.trim().isEmpty) return const SelectableText('-');
  switch (value) {
    case "1":
      return const SelectableText(
        '○',
        style: TextStyle(fontSize: 22),
      );
    case "0":
      return const SelectableText(
        '×',
        style: TextStyle(fontSize: 22),
      );
    default:
      return SelectableText('想定外の値:$value');
  }
}

// Map<String, Widget>の各行
Widget buildLine(String title, Widget value) {
  return Padding(
      padding: const EdgeInsets.only(left: 16.0, bottom: 16.0, top: 16.0),
      child: Row(
        children: [
          Expanded(
              flex: 3,
              child: Text(title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center)),
          const SizedBox(
            width: 10,
          ),
          Flexible(flex: 6, child: value),
        ],
      ));
}
