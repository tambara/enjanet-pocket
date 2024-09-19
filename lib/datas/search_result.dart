// Project imports:
import 'package:enjanet_pocket/datas/searchtable.dart';

class SearchResult {
  final int id;
  final int itemId;
  final String serviceCategory;
  final String office_name;
  final String office_name_furigana;
  final String address;
  final String latitude_longitude;
  final SearchTableNameEnum tableType;
  SearchResult({
    required this.id,
    required this.itemId,
    required this.serviceCategory,
    required this.office_name,
    required this.office_name_furigana,
    required this.address,
    required this.latitude_longitude,
    required this.tableType,
  });

  factory SearchResult.fromData(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'item_id': int itemId,
        'service_category': String serviceCategory,
        'office_name': String office_name,
        'office_name_furigana': String office_name_furigana,
        'address': String address,
        'latitude_longitude': String latitude_longitude,
        'table_type': int table_type,
      } =>
        SearchResult(
          id: id,
          itemId: itemId,
          serviceCategory: serviceCategory,
          office_name: office_name,
          office_name_furigana: office_name_furigana,
          address: address,
          latitude_longitude: latitude_longitude,
          tableType: SearchTableNameEnum.fromInt(table_type)!,
        ),
      _ => throw const FormatException('Failed to load SearchResult.'),
    };
  }
}
