// モバイル：0〜520px
// タブレット：521px〜960px
// デスクトップ：961px〜

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import 'package:enjanet_pocket/datas/appdata.dart';
import 'package:enjanet_pocket/datas/searchtable.dart';

final Map<SearchTableNameEnum, ServiceInfo> MAP_TABLE_SERVICE_INFO = {
  SearchTableNameEnum.hospitalsClinics: ServiceInfo(
    FontAwesomeIcons.hospital,
    Colors.blue,
    '病院・クリニック',
  ),
  SearchTableNameEnum.groupHomes: ServiceInfo(
    FontAwesomeIcons.houseChimneyUser,
    Colors.green,
    'グループホーム',
  ),
  SearchTableNameEnum.childServices: ServiceInfo(
    FontAwesomeIcons.child,
    Colors.orange,
    '児童サービス',
  ),
  SearchTableNameEnum.planningConsultations: ServiceInfo(
    FontAwesomeIcons.calendar,
    Colors.purple,
    '計画相談',
  ),
  SearchTableNameEnum.helperStations: ServiceInfo(
    FontAwesomeIcons.hands,
    Colors.red,
    'ヘルパーステーション',
  ),
  SearchTableNameEnum.disabilityServices: ServiceInfo(
    FontAwesomeIcons.person,
    Colors.indigo,
    '障害福祉サービス',
  ),
};

Widget getCycleAvatarFromTableType(
    SearchTableNameEnum tableType, double? radius) {
  final serviceInfo = MAP_TABLE_SERVICE_INFO[tableType] ??
      ServiceInfo(FontAwesomeIcons.house, Colors.blue[100]!, '-');

  return Container(
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: Colors.white, width: 2),
    ),
    child: CircleAvatar(
      radius: radius,
      backgroundColor: serviceInfo.color,
      child: FaIcon(
        serviceInfo.icon,
        color: Colors.white,
        size: radius,
      ),
    ),
  );
}
