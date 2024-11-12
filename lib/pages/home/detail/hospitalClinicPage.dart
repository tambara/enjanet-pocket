// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf/widgets.dart' as pw;

// Project imports:
import 'package:enjanet_pocket/datas/appdata.dart';
import 'package:enjanet_pocket/providers/providers.dart';
import 'package:enjanet_pocket/functions.dart';
import 'package:enjanet_pocket/pages/home/detail.dart';
import 'package:enjanet_pocket/pages/home/detail/common.dart';
import 'package:enjanet_pocket/pages/home/detail/pdf.dart';

Future<DetailData?> buildHospitalClinic(
    BuildContext context, WidgetRef ref, int itemId) async {
  // TODO: implement buildMap
  final db = ref.watch(enjanetDbProvider);
  final data = await db?.getFirstHospitalClinicByItemId(itemId);
  if (data == null) return null;

  return DetailData(
      eyecatch: data.eyecatch,
      latlang: data.latitudeLongitude != null
          ? parseLatLang(data.latitudeLongitude!)
          : null,
      title: data.officeName ?? "-",
      pageUrl: data.pageUrl ?? "",
      widgets: <String, Widget>{
        // 'ID': buildText(data.itemId.toString()),
        // '更新日': buildText(data.lastUpdate?.toString() ?? ''),
        'サービス分類': buildText(convertServiceCategoryStr(data.serviceCategory)),
        '事業所名': buildText(data.officeName),
        '事業所名・ホーム名のふりがな': buildText(data.officeNameFurigana),
        '郵便番号': buildText(data.postalCode),
        '住所': buildText(data.address),
        '電話番号': buildText(data.phoneNumber),
        'FAX': buildText(data.fax),
        'ホームページ': buildUrl(data.homepageUrl),
        '科': buildText(data.department),
        // '緯度経度': buildText(data.latitudeLongitude),
        'パンフレット': buildBrochure(context, data.brochure, data.pageUrl!),
      });
}

Future<Map<String, pw.Widget>?> buildHospitalClinicPdf(
    BuildContext context, WidgetRef ref, int itemId) async {
  // TODO: implement buildMap
  final db = ref.watch(enjanetDbProvider);
  final data = await db?.getFirstHospitalClinicByItemId(itemId);
  if (data == null) return null;

  return <String, pw.Widget>{
    // 'ID': buildTextPdf(data.itemId.toString()),
    // '更新日': buildText(data.lastUpdate?.toString() ?? ''),
    'サービス分類': buildTextPdf(convertServiceCategoryStr(data.serviceCategory)),
    '事業所名': buildTextPdf(data.officeName),
    '事業所名・ホーム名のふりがな': buildTextPdf(data.officeNameFurigana),
    '郵便番号': buildTextPdf(data.postalCode),
    '住所': buildTextPdf(data.address),
    '電話番号': buildTextPdf(data.phoneNumber),
    'FAX': buildTextPdf(data.fax),
    'ホームページ': buildLinkPdf(data.homepageUrl),
    '科': buildTextPdf(data.department),
    // '緯度経度': buildTextPdf(data.latitudeLongitude),
    'パンフレット': buildTextPdf(data.brochure),
  };
}
