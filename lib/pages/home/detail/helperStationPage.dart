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

Future<DetailData?> buildHelperStation(
    BuildContext context, WidgetRef ref, int itemId) async {
  // TODO: implement buildMap
  final db = ref.watch(enjanetDbProvider);
  final data = await db?.getFirstHelperStationByItemId(itemId);
  if (data == null) return null;

  return DetailData(
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
        '住所': buildText(data.address),
        '電話番号': buildText(data.phoneNumber ?? ''),
        '岡山市北区（御津・建部地域を除く）へのサービス提供': buildCircleCrossTriangleWidget(
            data.serviceInOkayamaNorthExceptMitsuAndTakebe),
        '岡山市北区（御津・建部地域を除く）へのサービス提供 備考':
            buildText(data.serviceInOkayamaNorthExceptMitsuAndTakebeNotes),
        '岡山市北区（御津・建部地域）へのサービス提供': buildCircleCrossTriangleWidget(
            data.serviceInOkayamaNorthInMitsuAndTakebe),
        '岡山市北区（御津・建部地域）へのサービス提供 備考':
            buildText(data.serviceInOkayamaNorthInMitsuAndTakebeNotes),
        '岡山市中区へのサービス提供':
            buildCircleCrossTriangleWidget(data.serviceInOkayamaMiddle),
        'サービス提供地域（中区）備考': buildText(data.serviceInOkayamaMiddleNotes),
        '岡山市東区へのサービス提供':
            buildCircleCrossTriangleWidget(data.serviceInOkayamaEast),
        '岡山市東区へのサービス提供 備考': buildText(data.serviceInOkayamaEastNotes),
        '岡山市南区へのサービス提供':
            buildCircleCrossTriangleWidget(data.serviceInOkayamaSouth),
        '岡山市南区へのサービス提供 備考': buildText(data.serviceInOkayamaSouthNotes),
        '居宅介護（家事援助・身体介護等）サービス提供':
            buildCircleCrossTriangleWidget(data.homeCareServiceProvision),
        '居宅介護（家事援助・身体介護等）サービス提供 備考':
            buildText(data.homeCareServiceProvisionNotes),
        '重度訪問介護サービス提供': buildCircleCrossTriangleWidget(
            data.severeVisitCareServiceProvision),
        '重度訪問介護サービス提供 備考': buildText(data.severeVisitCareServiceProvisionNotes),
        '同行援護サービス提供': buildCircleCrossTriangleWidget(
            data.accompanimentSupportServiceProvision),
        '同行援護サービス提供 備考':
            buildText(data.accompanimentSupportServiceProvisionNotes),
        '行動援護サービス提供': buildCircleCrossTriangleWidget(
            data.behaviorSupportServiceProvision),
        '行動援護サービス提供 備考': buildText(data.behaviorSupportServiceProvisionNotes),
        '移動支援サービス提供': buildCircleCrossTriangleWidget(
            data.movementSupportServiceProvision),
        '移動支援サービス提供 備考': buildText(data.movementSupportServiceProvisionNotes),
        '介護保険サービス（訪問介護）提供':
            buildCircleCrossTriangleWidget(data.careInsuranceServiceProvision),
        '介護保険サービス（訪問介護）提供 備考':
            buildText(data.careInsuranceServiceProvisionNotes),
        '一部医療ケア（※1）への対応\n ※1 対象となる医療行為：○たんの吸引（口膣内、鼻腔内、気管カニューレ内部）○経管栄養（胃ろうまたは経鼻経）':
            buildCircleCrossTriangleWidget(data.partialMedicalCareResponse),
        '一部医療ケアへの対応 備考': buildText(data.partialMedicalCareResponseNotes),
        '土曜日・日曜日・祝日のサービス提供':
            buildCircleCrossTriangleWidget(data.weekendHolidaysService),
        '土曜日・日曜日・祝日のサービス提供 備考': buildText(data.weekendHolidaysServiceNotes),
        '早朝（6～8時）のサービス提供':
            buildCircleCrossTriangleWidget(data.earlyMorningService),
        '早朝（6～8時）のサービス提供 備考': buildText(data.earlyMorningServiceNotes),
        '夜間（18時～22時）のサービス提供':
            buildCircleCrossTriangleWidget(data.eveningService),
        '夜間（18時～22時）のサービス提供 備考': buildText(data.eveningServiceNotes),
        '深夜（22時～8時）のサービス提供':
            buildCircleCrossTriangleWidget(data.overnightService),
        '深夜（22時～8時）のサービス提供 備考': buildText(data.overnightServiceNotes),
        // '緯度経度': buildText(data.latitudeLongitude),
        'パンフレット': buildBrochure(context, data.brochure, data.pageUrl!),
      });
  //
}

Future<Map<String, pw.Widget>?> buildHelperStationPdf(
    BuildContext context, WidgetRef ref, int itemId) async {
  // TODO: implement buildMap
  final db = ref.watch(enjanetDbProvider);
  final data = await db?.getFirstHelperStationByItemId(itemId);
  if (data == null) return null;
  return <String, pw.Widget>{
    // 'ID': buildTextPdf(data.itemId.toString()),
    // '更新日': buildText(data.lastUpdate?.toString() ?? ''),
    'サービス分類': buildTextPdf(convertServiceCategoryStr(data.serviceCategory)),
    '事業所名': buildTextPdf(data.officeName),
    '事業所名・ホーム名のふりがな': buildTextPdf(data.officeNameFurigana),
    '住所': buildTextPdf(data.address),
    '電話番号': buildTextPdf(data.phoneNumber ?? ''),
    '岡山市北区（御津・建部地域を除く）へのサービス提供': buildCircleCrossTriangleWidgetPdf(
        data.serviceInOkayamaNorthExceptMitsuAndTakebe),
    '岡山市北区（御津・建部地域を除く）へのサービス提供 備考':
        buildTextPdf(data.serviceInOkayamaNorthExceptMitsuAndTakebeNotes),
    '岡山市北区（御津・建部地域）へのサービス提供': buildCircleCrossTriangleWidgetPdf(
        data.serviceInOkayamaNorthInMitsuAndTakebe),
    '岡山市北区（御津・建部地域）へのサービス提供 備考':
        buildTextPdf(data.serviceInOkayamaNorthInMitsuAndTakebeNotes),
    '岡山市中区へのサービス提供':
        buildCircleCrossTriangleWidgetPdf(data.serviceInOkayamaMiddle),
    'サービス提供地域（中区）備考': buildTextPdf(data.serviceInOkayamaMiddleNotes),
    '岡山市東区へのサービス提供':
        buildCircleCrossTriangleWidgetPdf(data.serviceInOkayamaEast),
    '岡山市東区へのサービス提供 備考': buildTextPdf(data.serviceInOkayamaEastNotes),
    '岡山市南区へのサービス提供':
        buildCircleCrossTriangleWidgetPdf(data.serviceInOkayamaSouth),
    '岡山市南区へのサービス提供 備考': buildTextPdf(data.serviceInOkayamaSouthNotes),
    '居宅介護（家事援助・身体介護等）サービス提供':
        buildCircleCrossTriangleWidgetPdf(data.homeCareServiceProvision),
    '居宅介護（家事援助・身体介護等）サービス提供 備考':
        buildTextPdf(data.homeCareServiceProvisionNotes),
    '重度訪問介護サービス提供':
        buildCircleCrossTriangleWidgetPdf(data.severeVisitCareServiceProvision),
    '重度訪問介護サービス提供 備考': buildTextPdf(data.severeVisitCareServiceProvisionNotes),
    '同行援護サービス提供': buildCircleCrossTriangleWidgetPdf(
        data.accompanimentSupportServiceProvision),
    '同行援護サービス提供 備考':
        buildTextPdf(data.accompanimentSupportServiceProvisionNotes),
    '行動援護サービス提供':
        buildCircleCrossTriangleWidgetPdf(data.behaviorSupportServiceProvision),
    '行動援護サービス提供 備考': buildTextPdf(data.behaviorSupportServiceProvisionNotes),
    '移動支援サービス提供':
        buildCircleCrossTriangleWidgetPdf(data.movementSupportServiceProvision),
    '移動支援サービス提供 備考': buildTextPdf(data.movementSupportServiceProvisionNotes),
    '介護保険サービス（訪問介護）提供':
        buildCircleCrossTriangleWidgetPdf(data.careInsuranceServiceProvision),
    '介護保険サービス（訪問介護）提供 備考':
        buildTextPdf(data.careInsuranceServiceProvisionNotes),
    '一部医療ケアへの対応':
        buildCircleCrossTriangleWidgetPdf(data.partialMedicalCareResponse),
    '一部医療ケアへの対応 備考': buildTextPdf(data.partialMedicalCareResponseNotes),
    '土曜日・日曜日・祝日のサービス提供':
        buildCircleCrossTriangleWidgetPdf(data.weekendHolidaysService),
    '土曜日・日曜日・祝日のサービス提供 備考': buildTextPdf(data.weekendHolidaysServiceNotes),
    '早朝（6～8時）のサービス提供':
        buildCircleCrossTriangleWidgetPdf(data.earlyMorningService),
    '早朝（6～8時）のサービス提供 備考': buildTextPdf(data.earlyMorningServiceNotes),
    '夜間（18時～22時）のサービス提供':
        buildCircleCrossTriangleWidgetPdf(data.eveningService),
    '夜間（18時～22時）のサービス提供 備考': buildTextPdf(data.eveningServiceNotes),
    '深夜（22時～8時）のサービス提供':
        buildCircleCrossTriangleWidgetPdf(data.overnightService),
    '深夜（22時～8時）のサービス提供 備考': buildTextPdf(data.overnightServiceNotes),
    // '緯度経度': buildTextPdf(data.latitudeLongitude),
    'パンフレット': buildBrochurePdf(data.brochure),
  };
}

/*
以下、のMAPの各キーに対応するbuildを呼ぶよう再構成したい。
引数はそのままでbuild〜を各キーの名前にして_付きのプライベートの関数にしてbuild〜の最後の部分をWidgetからPdfに置き換えて。
また、同時に最後の部分をWidgetからPdfにしたバージョンも作って。
各関数も書いて
省略せずに書いて。

 <String, Widget>{
          'ID': buildText(data.itemId.toString()),
          // '更新日': buildText(data.lastUpdate?.toString() ?? ''),
          'サービス分類': buildText(getServiceCategoryStr(data.serviceCategory)),
          '事業所名': buildText(data.officeName),
          '事業所名・ホーム名のふりがな': buildText(data.officeNameFurigana),
          '住所': buildText(data.address),
          '電話番号': buildText(data.phoneNumber ?? ''),
          '岡山市北区（御津・建部地域を除く）へのサービス提供': buildCircleCrossTriangleWidget(
              data.serviceInOkayamaNorthExceptMitsuAndTakebe),
          '岡山市北区（御津・建部地域を除く）へのサービス提供 備考':
              buildText(data.serviceInOkayamaNorthExceptMitsuAndTakebeNotes),
          '岡山市北区（御津・建部地域）へのサービス提供': buildCircleCrossTriangleWidget(
              data.serviceInOkayamaNorthInMitsuAndTakebe),
          '岡山市北区（御津・建部地域）へのサービス提供 備考':
              buildText(data.serviceInOkayamaNorthInMitsuAndTakebeNotes),
          '岡山市中区へのサービス提供':
              buildCircleCrossTriangleWidget(data.serviceInOkayamaMiddle),
          'サービス提供地域（中区）備考': buildText(data.serviceInOkayamaMiddleNotes),
          '岡山市東区へのサービス提供':
              buildCircleCrossTriangleWidget(data.serviceInOkayamaEast),
          '岡山市東区へのサービス提供 備考': buildText(data.serviceInOkayamaEastNotes),
          '岡山市南区へのサービス提供':
              buildCircleCrossTriangleWidget(data.serviceInOkayamaSouth),
          '岡山市南区へのサービス提供 備考': buildText(data.serviceInOkayamaSouthNotes),
          '居宅介護（家事援助・身体介護等）サービス提供':
              buildCircleCrossTriangleWidget(data.homeCareServiceProvision),
          '居宅介護（家事援助・身体介護等）サービス提供 備考':
              buildText(data.homeCareServiceProvisionNotes),
          '重度訪問介護サービス提供': buildCircleCrossTriangleWidget(
              data.severeVisitCareServiceProvision),
          '重度訪問介護サービス提供 備考':
              buildText(data.severeVisitCareServiceProvisionNotes),
          '同行援護サービス提供': buildCircleCrossTriangleWidget(
              data.accompanimentSupportServiceProvision),
          '同行援護サービス提供 備考':
              buildText(data.accompanimentSupportServiceProvisionNotes),
          '行動援護サービス提供': buildCircleCrossTriangleWidget(
              data.behaviorSupportServiceProvision),
          '行動援護サービス提供 備考': buildText(data.behaviorSupportServiceProvisionNotes),
          '移動支援サービス提供': buildCircleCrossTriangleWidget(
              data.movementSupportServiceProvision),
          '移動支援サービス提供 備考': buildText(data.movementSupportServiceProvisionNotes),
          '介護保険サービス（訪問介護）提供': buildCircleCrossTriangleWidget(
              data.careInsuranceServiceProvision),
          '介護保険サービス（訪問介護）提供 備考':
              buildText(data.careInsuranceServiceProvisionNotes),
          '一部医療ケアへの対応':
              buildCircleCrossTriangleWidget(data.partialMedicalCareResponse),
          '一部医療ケアへの対応 備考': buildText(data.partialMedicalCareResponseNotes),
          '土曜日・日曜日・祝日のサービス提供':
              buildCircleCrossTriangleWidget(data.weekendHolidaysService),
          '土曜日・日曜日・祝日のサービス提供 備考': buildText(data.weekendHolidaysServiceNotes),
          '早朝（6～8時）のサービス提供':
              buildCircleCrossTriangleWidget(data.earlyMorningService),
          '早朝（6～8時）のサービス提供 備考': buildText(data.earlyMorningServiceNotes),
          '夜間（18時～22時）のサービス提供':
              buildCircleCrossTriangleWidget(data.eveningService),
          '夜間（18時～22時）のサービス提供 備考': buildText(data.eveningServiceNotes),
          '深夜（22時～8時）のサービス提供':
              buildCircleCrossTriangleWidget(data.overnightService),
          '深夜（22時～8時）のサービス提供 備考': buildText(data.overnightServiceNotes),
          '緯度経度': buildText(data.latitudeLongitude),
          'パンフレット': buildBrochure(context, data.brochure, data.pageUrl!),
        }*/
