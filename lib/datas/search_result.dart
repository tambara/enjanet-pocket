// Project imports:
import 'dart:typed_data';

import 'package:enjanet_pocket/datas/searchtable.dart';

class SearchResult {
  final int id;
  final int itemId;
  final String serviceCategory;
  final String officeName;
  final String officeNameFurigana;
  final String address;
  final String latitudeLongitude;
  final SearchTableNameEnum tableType;
  final Uint8List? eyecatch;
  SearchResult({
    required this.id,
    required this.itemId,
    required this.serviceCategory,
    required this.officeName,
    required this.officeNameFurigana,
    required this.address,
    required this.latitudeLongitude,
    required this.tableType,
    required this.eyecatch,
  });

  factory SearchResult.fromData(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'item_id': int itemId,
        'service_category': String serviceCategory,
        'office_name': String officeName,
        'office_name_furigana': String officeNameFurigana,
        'address': String address,
        'latitude_longitude': String latitudeLongitude,
        'table_type': int tableType,
        'eyecatch': Uint8List? eyecatch,
      } =>
        SearchResult(
          id: id,
          itemId: itemId,
          serviceCategory: serviceCategory,
          officeName: officeName,
          officeNameFurigana: officeNameFurigana,
          address: address,
          latitudeLongitude: latitudeLongitude,
          tableType: SearchTableNameEnum.fromInt(tableType)!,
          eyecatch: eyecatch,
        ),
      _ => throw const FormatException('Failed to load SearchResult.'),
    };
  }
}
