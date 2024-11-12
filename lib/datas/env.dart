// Package imports:
import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env', useConstantCase: true)
abstract class Env {
  @EnviedField(varName: 'ENJANET_DB_JSON_URL')
  static const String enjanetDbJsonUrl = _Env.enjanetDbJsonUrl;

  @EnviedField(varName: 'ENJANET_URL')
  static const String enjanetUrl = _Env.enjanetUrl;

  @EnviedField(varName: 'USER_DB_NAME')
  static const String userDbName = _Env.userDbName;

  @EnviedField(varName: 'ENJANET_DB_PASS', obfuscate: true)
  static final String enjanetDbPass = _Env.enjanetDbPass;

  @EnviedField(varName: 'USER_DB_PASS', obfuscate: true)
  static final String userDbPass = _Env.userDbPass;

  @EnviedField(varName: 'ENJANET_ENJANET_JSON_NAME')
  static const String enjanetEnjanetJsonName = _Env.enjanetEnjanetJsonName;

  @EnviedField(varName: 'ENJANET_ENJANET_DB_NAME')
  static const String enjanetEnjanetDbName = _Env.enjanetEnjanetDbName;

  @EnviedField(varName: 'ENJANET_RASTER_URL')
  static const String enjanetRasterUrl = _Env.enjanetRasterUrl;

  @EnviedField(varName: 'ENJANET_VECTOR_URL')
  static const String enjanetVectorUrl = _Env.enjanetVectorUrl;

  @EnviedField(varName: 'ENJANET_RASTER_NAME')
  static const String enjanetRasterName = _Env.enjanetRasterName;

  @EnviedField(varName: 'ENJANET_VECTOR_NAME')
  static const String enjanetVectorName = _Env.enjanetVectorName;

  @EnviedField(varName: 'ENJANET_RASTER_JSON_URL')
  static const String enjanetRasterJsonUrl = _Env.enjanetRasterJsonUrl;

  @EnviedField(varName: 'ENJANET_VECTOR_JSON_URL')
  static const String enjanetVectorJsonUrl = _Env.enjanetVectorJsonUrl;

  @EnviedField(varName: 'ENJANET_RASTER_JSON_NAME')
  static const String enjanetRasterJsonName = _Env.enjanetRasterJsonName;

  @EnviedField(varName: 'ENJANET_VECTOR_JSON_NAME')
  static const String enjanetVectorJsonName = _Env.enjanetVectorJsonName;

  @EnviedField(varName: 'ENJANET_DB_URL')
  static const String enjanetDbUrl = _Env.enjanetDbUrl;

  @EnviedField(varName: 'INCOMPLETE_DOWNLOAD_EXT')
  static const String incompleteDwnloadExt = _Env.incompleteDwnloadExt;
}
