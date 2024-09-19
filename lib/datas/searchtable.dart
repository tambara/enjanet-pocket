// Project imports:
import 'package:enjanet_pocket/db/db.dart';

enum SearchTableNameEnum {
  hospitalsClinics(1),
  groupHomes(2),
  childServices(3),
  planningConsultations(4),
  helperStations(5),
  disabilityServices(6);

  final int value;
  const SearchTableNameEnum(this.value);

  static Map<int, String> _stringValues = {
    hospitalsClinics.value: TABLENAME_HOSPITALS_CLINICS,
    groupHomes.value: TABLENAME_GROUP_HOMES,
    childServices.value: TABLENAME_CHILD_SERVICES,
    planningConsultations.value: TABLENAME_PLANNING_CONSULTATIONS,
    helperStations.value: TABLENAME_HELPER_STATIONS,
    disabilityServices.value: TABLENAME_DISABILITY_SERVICES,
  };
  static Map<int, String> get namesAndValues => _stringValues;
  static List<SearchTableNameEnum> get all => SearchTableNameEnum.values;

  static SearchTableNameEnum? fromInt(int value) {
    try {
      return SearchTableNameEnum.values.firstWhere(
        (e) => e.value == value,
      );
    } catch (e) {
      return null;
    }
  }

  String? get toTableName => _stringValues[value];

  static SearchTableNameEnum? fromString(String value) {
    try {
      return fromInt(_stringValues.entries
          .firstWhere(
            (entry) => entry.value == value,
          )
          .key);
    } catch (e) {
      return null;
    }
  }
}
