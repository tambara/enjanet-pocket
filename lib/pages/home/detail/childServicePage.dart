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

Future<DetailData?> buildMapChildService(
    BuildContext context, WidgetRef ref, int itemId) async {
  // TODO: implement buildMap
  final db = ref.watch(enjanetDbProvider);

  final data = await db?.getFirstChildServiceByItemId(itemId);
  if (data == null) return null;

  return DetailData(
      title: data.officeName ?? "-",
      pageUrl: data.pageUrl ?? "",
      latlang: data.latitudeLongitude != null
          ? parseLatLang(data.latitudeLongitude!)
          : null,
      widgets: <String, Widget>{
        // 'ID': buildText(data.itemId.toString()),
        // '更新日': buildText(data.lastUpdate?.toString() ?? ''),
        'サービス分類': buildText(convertServiceCategoryStr(data.serviceCategory)),
        '対象者': buildText(data.targetPerson),
        '児童待機状況': buildText(data.waitStatus),
        '事業所名': buildText(data.officeName),
        '事業所名・ホーム名のふりがな': buildText(data.officeNameFurigana),
        '運営主体': buildText(data.operatingEntity),
        '住所': buildText(data.address),
        '電話番号': buildText(data.phoneNumber),
        'FAX': buildText(data.fax),
        'メール': buildText(data.email),
        'ホームページ': buildUrl(data.homepageUrl),
        '定員人数': buildText(data.capacity),
        '職員配置': buildText(data.staffConfiguration),
        '交通手段': buildText(data.transportation),
        'サービス提供日時': buildText(data.serviceProvisionTime),
        '利用料等': buildText(data.usageFee),
        '事業の内容': buildText(data.businessContent),
        '事業所の特徴・コメント・PR': buildText(data.officeFeatures),
        // '緯度経度': buildText(data.latitudeLongitude),
        '事業所の写真': buildPhoto(context, data.officePhoto, data.pageUrl!),
        '事業所の外観画像':
            buildPhoto(context, data.officeExteriorImage, data.pageUrl!),
        '事業所の略地図画像': buildPhoto(context, data.officeMapImage, data.pageUrl!),
        'パンフレット': buildBrochure(context, data.brochure, data.pageUrl!),
      });
}

Future<Map<String, pw.Widget>?> buildChildServicePdf(
    BuildContext context, WidgetRef ref, int itemId) async {
  final db = ref.watch(enjanetDbProvider);

  final data = await db?.getFirstChildServiceByItemId(itemId);
  if (data == null) return null;

  return <String, pw.Widget>{
    // 'ID': buildTextPdf(data.itemId.toString()),
    // '更新日': buildText(data.lastUpdate?.toString() ?? ''),
    'サービス分類': buildTextPdf(convertServiceCategoryStr(data.serviceCategory)),
    '対象者': buildTextPdf(data.targetPerson),
    '児童待機状況': buildTextPdf(data.waitStatus),
    '事業所名': buildTextPdf(data.officeName),
    '事業所名・ホーム名のふりがな': buildTextPdf(data.officeNameFurigana),
    '運営主体': buildTextPdf(data.operatingEntity),
    '住所': buildTextPdf(data.address),
    '電話番号': buildTextPdf(data.phoneNumber),
    'FAX': buildTextPdf(data.fax),
    'メール': buildTextPdf(data.email),
    'ホームページ': buildLinkPdf(data.homepageUrl),
    '定員人数': buildTextPdf(data.capacity),
    '職員配置': buildTextPdf(data.staffConfiguration),
    '交通手段': buildTextPdf(data.transportation),
    'サービス提供日時': buildTextPdf(data.serviceProvisionTime),
    '利用料等': buildTextPdf(data.usageFee),
    '事業の内容': buildTextPdf(data.businessContent),
    '事業所の特徴・コメント・PR': buildTextPdf(data.officeFeatures),
    // '緯度経度': buildTextPdf(data.latitudeLongitude),
    '事業所の写真': buildTextPdf(data.officePhoto),
    '事業所の外観画像': buildTextPdf(data.officeExteriorImage),
    '事業所の略地図画像': buildTextPdf(data.officeMapImage),
    'パンフレット': buildBrochurePdf(data.brochure),
  };
}
