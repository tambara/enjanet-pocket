class SettingData {
  final String _languageType;
  final String _darkMode;
  final String _dbLastUpdatedAt;
  final String _primaryMap;
  final String _checkUpdates;

  SettingData({
    required String languageType,
    required String darkMode,
    required String dbLastUpdatedAt,
    required String primaryMap,
    required String checkUpdates,
  })  : _languageType = languageType,
        _darkMode = darkMode,
        _dbLastUpdatedAt = dbLastUpdatedAt,
        _primaryMap = primaryMap,
        _checkUpdates = checkUpdates;

  String get languageType => _languageType;
  bool get darkMode => _darkMode == "true";
  String get dbLastUpdatedAt => _dbLastUpdatedAt;
  String get primaryMap => _primaryMap;
  bool get checkUpdates => _checkUpdates == "true";
}
