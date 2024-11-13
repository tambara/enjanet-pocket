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

Future<DetailData?> buildDisabilityService(
    BuildContext context, WidgetRef ref, int itemId) async {
  // TODO: implement buildMap
  final db = ref.watch(enjanetDbProvider);
  final data = db?.getFirstDisabilityServiceByItemId(itemId);
  if (data == null) return null;

  // leading: result.service.eyecatch != null
  //     ? Image.memory(result.service.eyecatch)
  //     : getCycleAvatarFromTableType(result.service.tableType, 30),

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
        '事業所名・ホーム名のふりがな（平仮名）': buildText(data.officeNameFurigana),
        '運営主体（バックアップ施設・病院（法人名））': buildText(data.operatingEntity),
        '郵便番号': buildText(data.postalCode),
        '住所': buildText(data.address),
        '電話番号': buildText(data.phoneNumber),
        'FAX': buildText(data.fax),
        'メール': buildText(data.email),
        'ホームページ': buildUrl(data.homepageUrl),
        '定員人数': buildText(data.capacity),
        '交通手段': buildText(data.transportation),
        'サービス提供日時': buildText(data.serviceProvisionTime),
        '利用料等': buildText(data.usageFee),
        '工賃等': buildText(data.wage),
        '医療ケアの可否': buildYuMu(data.medicalCareAvailability),
        'オプションサービス・入浴': buildYuMu(data.optionalServiceBath),
        'オプションサービス・送迎': buildYuMu(data.optionalServiceTransportation),
        'オプションサービス・具体的な内容': buildText(data.optionalServiceDetails),
        '事業の内容（活動・作業等の内容）': buildText(data.businessContent),
        '事業所の特徴・コメント・PR': buildText(data.officeFeatures),
        // '緯度経度': buildText(data.latitudeLongitude),
        '事業所の写真': buildPhoto(context, data.officePhoto, data.pageUrl!),
        '事業所の外観画像':
            buildPhoto(context, data.officeExteriorImage, data.pageUrl!),
        '事業所の略地図画像': buildPhoto(context, data.officeMapImage, data.pageUrl!),
        'パンフレット': buildBrochure(context, data.brochure, data.pageUrl!),
      });
}

Future<Map<String, pw.Widget>?> buildDisabilityServicePdf(
    BuildContext context, WidgetRef ref, int itemId) async {
  // TODO: implement buildMap
  final db = ref.watch(enjanetDbProvider);
  final data = db?.getFirstDisabilityServiceByItemId(itemId);
  if (data == null) return null;

  return <String, pw.Widget>{
    // 'ID': buildTextPdf(data.itemId.toString()),
    // '更新日': buildText(data.lastUpdate?.toString() ?? ''),
    'サービス分類': buildTextPdf(convertServiceCategoryStr(data.serviceCategory)),
    '事業所名': buildTextPdf(data.officeName),
    '事業所名・ホーム名のふりがな（平仮名）': buildTextPdf(data.officeNameFurigana),
    '運営主体（バックアップ施設・病院（法人名））': buildTextPdf(data.operatingEntity),
    '郵便番号': buildTextPdf(data.postalCode),
    '住所': buildTextPdf(data.address),
    '電話番号': buildTextPdf(data.phoneNumber),
    'FAX': buildTextPdf(data.fax),
    'メール': buildTextPdf(data.email),
    'ホームページ': buildLinkPdf(data.homepageUrl),
    '定員': buildTextPdf(data.capacity),
    '交通手段': buildTextPdf(data.transportation),
    'サービス提供日時': buildTextPdf(data.serviceProvisionTime),
    '利用料等': buildTextPdf(data.usageFee),
    '工賃等': buildTextPdf(data.wage),
    '医療ケアの可否': buildYuMuPdf(data.medicalCareAvailability),
    'オプションサービス・入浴': buildYuMuPdf(data.optionalServiceBath),
    'オプションサービス・送迎': buildYuMuPdf(data.optionalServiceTransportation),
    'オプションサービス・具体的な内容': buildTextPdf(data.optionalServiceDetails),
    '事業の内容（活動・作業等の内容）': buildTextPdf(data.businessContent),
    '事業所の特徴・コメント・PR': buildTextPdf(data.officeFeatures),
    // '緯度経度': buildTextPdf(data.latitudeLongitude),
    // '事業所の写真': buildTextPdf(data.officePhoto),
    // '事業所の外観画像': buildTextPdf(data.officeExteriorImage),
    // '事業所の略地図画像': buildTextPdf(data.officeMapImage),
    'パンフレット': buildBrochurePdf(data.brochure),
  };
}
