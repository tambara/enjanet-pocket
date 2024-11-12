// Package imports:
import 'package:enjanet_pocket/datas/searchtable.dart';
import 'package:flutter/foundation.dart';

import 'package:sqlite3/sqlite3.dart';

// Project imports:
import 'package:enjanet_pocket/datas/search_criteria.dart';
import 'package:enjanet_pocket/datas/search_result.dart';

// ignore: constant_identifier_names
const String TABLENAME_METADATA = 'meta_datas';
// ignore: constant_identifier_names
const String TABLENAME_HOSPITALS_CLINICS = 'hospitals_clinics';
// ignore: constant_identifier_names
const String TABLENAME_GROUP_HOMES = 'group_homes';
// ignore: constant_identifier_names
const String TABLENAME_CHILD_SERVICES = 'child_services';
// ignore: constant_identifier_names
const String TABLENAME_PLANNING_CONSULTATIONS = 'planning_consultations';
// ignore: constant_identifier_names
const String TABLENAME_HELPER_STATIONS = 'helper_stations';
// ignore: constant_identifier_names
const String TABLENAME_DISABILITY_SERVICES = 'disability_services';

abstract class Table {
  static const String tableName = "";
}

class MetaData {
  final String? name; // version
  // String? createdAt => text().withDefault(const CurrentDateTimeExpression())(); // created_at
  final String? value; // // created_at

  const MetaData({
    this.name,
    this.value,
  });

  factory MetaData.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'name': String? name,
        'value': String? value,
      } =>
        MetaData(
          name: name,
          value: value,
        ),
      _ => throw const FormatException('Failed to load MetaData.'),
    };
  }
}

class HospitalClinic {
  final int id;
  final int itemId;
  final String? lastUpdate;
  final String? serviceCategory;
  final String? officeName;
  final String? officeNameFurigana;
  final String? postalCode;
  final String? address;
  final String? phoneNumber;
  final String? fax;
  final String? homepageUrl;
  final String? department;
  final String? latitudeLongitude;
  final String? brochure;
  final String? pageUrl;
  final Uint8List? eyecatch;

  const HospitalClinic({
    required this.id,
    required this.itemId,
    this.lastUpdate,
    this.serviceCategory,
    this.officeName,
    this.officeNameFurigana,
    this.postalCode,
    this.address,
    this.phoneNumber,
    this.fax,
    this.homepageUrl,
    this.department,
    this.latitudeLongitude,
    this.brochure,
    this.pageUrl,
    this.eyecatch,
  });

  factory HospitalClinic.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'item_id': int itemId,
        'last_update': String? lastUpdate,
        'service_category': String? serviceCategory,
        'office_name': String? officeName,
        'office_name_furigana': String? officeNameFurigana,
        'postal_code': String? postalCode,
        'address': String? address,
        'phone_number': String? phoneNumber,
        'fax': String? fax,
        'homepage_url': String? homepageUrl,
        'department': String? department,
        'latitude_longitude': String? latitudeLongitude,
        'brochure': String? brochure,
        'page_url': String? pageUrl,
        // 'eyecatch': Uint8List? eyecatch,
      } =>
        HospitalClinic(
          id: id,
          itemId: itemId,
          lastUpdate: lastUpdate,
          serviceCategory: serviceCategory,
          officeName: officeName,
          officeNameFurigana: officeNameFurigana,
          postalCode: postalCode,
          address: address,
          phoneNumber: phoneNumber,
          fax: fax,
          homepageUrl: homepageUrl,
          department: department,
          latitudeLongitude: latitudeLongitude,
          brochure: brochure,
          pageUrl: pageUrl,
          // eyecatch: eyecatch,
        ),
      _ => throw const FormatException('Failed to load HospitalClinic.'),
    };
  }
}

class GroupHome {
  late int itemId; // ID
  String? lastUpdate; // 更新日
  String? serviceCategory; // サービス分類
  String? officeName; // 事業所名
  String? officeNameFurigana; // 事業所名のふりがな
  String? operatingEntity; // 運営主体
  String? postalCode; // 郵便番号
  String? address; // 住所
  String? target; // 対象
  String? mainDisability; // 主たる障害
  String? capacity; // 定員
  String? contact; // 連絡先
  String? layout; // 間取り
  String? facilities; // 設備
  String? structure; // 構造
  String? structureDetailsRemarks; // 構造詳細・備考
  String? surroundingEnvironment; // まわりの環境
  String? rent; // 家賃
  String? dailyGoodsExpense; // 日用品費
  String? mealExpense; // 食費
  String? moneyManagementExpense; // 金銭管理費
  String? utilitiesExpense; // 光熱水費
  String? otherExpenses; // その他費用
  String? supportSystemOfCaretaker; // 世話人の支援体制
  String? mealSystem; // 食事の体制
  String? mealSystemSupplement; // 食事の体制(補足)
  String? holidaySupport; // 休日の支援
  String? hospitalResponse; // 病院等の対応
  String? featuresOptions; // 特色・オプション等
  String? vacantRoomNumber; // 空き室数
  String? destination; // 送信先
  String? latitudeLongitude; // 緯度経度
  String? officePhoto; // 事業所の写真
  String? officeExteriorImage; // 事業所の外観画像
  String? officeMapImage; // 事業所の略地図画像

  String? pageUrl; // ページURL
  Uint8List? eyecatch; // 外観画像
}

class ChildService {
  final int itemId;
  final String? lastUpdate;
  final String? serviceCategory;
  final String? targetPerson;
  final String? waitStatus;
  final String? officeName;
  final String? officeNameFurigana;
  final String? operatingEntity;
  final String? address;
  final String? phoneNumber;
  final String? fax;
  final String? email;
  final String? homepageUrl;
  final String? capacity;
  final String? staffConfiguration;
  final String? transportation;
  final String? serviceProvisionTime;
  final String? usageFee;
  final String? businessContent;
  final String? officeFeatures;
  final String? latitudeLongitude;
  final String? officePhoto;
  final String? officeExteriorImage;
  final String? officeMapImage;
  final String? brochure;
  final String? pageUrl;
  final Uint8List? eyecatch;

  const ChildService({
    required this.itemId,
    this.lastUpdate,
    this.serviceCategory,
    this.targetPerson,
    this.waitStatus,
    this.officeName,
    this.officeNameFurigana,
    this.operatingEntity,
    this.address,
    this.phoneNumber,
    this.fax,
    this.email,
    this.homepageUrl,
    this.capacity,
    this.staffConfiguration,
    this.transportation,
    this.serviceProvisionTime,
    this.usageFee,
    this.businessContent,
    this.officeFeatures,
    this.latitudeLongitude,
    this.officePhoto,
    this.officeExteriorImage,
    this.officeMapImage,
    this.brochure,
    this.pageUrl,
    this.eyecatch,
  });

  factory ChildService.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'item_id': int itemId,
        'last_update': String? lastUpdate,
        'service_category': String? serviceCategory,
        'target_person': String? targetPerson,
        'wait_status': String? waitStatus,
        'office_name': String? officeName,
        'office_name_furigana': String? officeNameFurigana,
        'operating_entity': String? operatingEntity,
        'address': String? address,
        'phone_number': String? phoneNumber,
        'fax': String? fax,
        'email': String? email,
        'homepage_url': String? homepageUrl,
        'capacity': String? capacity,
        'staff_configuration': String? staffConfiguration,
        'transportation': String? transportation,
        'service_provision_time': String? serviceProvisionTime,
        'usage_fee': String? usageFee,
        'business_content': String? businessContent,
        'office_features': String? officeFeatures,
        'latitude_longitude': String? latitudeLongitude,
        'office_photo': String? officePhoto,
        'office_exterior_image': String? officeExteriorImage,
        'office_map_image': String? officeMapImage,
        'brochure': String? brochure,
        'page_url': String? pageUrl,
        'eyecatch': Uint8List? eyecatch,
      } =>
        ChildService(
          itemId: itemId,
          lastUpdate: lastUpdate,
          serviceCategory: serviceCategory,
          targetPerson: targetPerson,
          waitStatus: waitStatus,
          officeName: officeName,
          officeNameFurigana: officeNameFurigana,
          operatingEntity: operatingEntity,
          address: address,
          phoneNumber: phoneNumber,
          fax: fax,
          email: email,
          homepageUrl: homepageUrl,
          capacity: capacity,
          staffConfiguration: staffConfiguration,
          transportation: transportation,
          serviceProvisionTime: serviceProvisionTime,
          usageFee: usageFee,
          businessContent: businessContent,
          officeFeatures: officeFeatures,
          latitudeLongitude: latitudeLongitude,
          officePhoto: officePhoto,
          officeExteriorImage: officeExteriorImage,
          officeMapImage: officeMapImage,
          brochure: brochure,
          pageUrl: pageUrl,
          eyecatch: eyecatch,
        ),
      _ => throw const FormatException('Failed to load ChildService.'),
    };
  }
}

class PlanningConsultation {
  final int itemId;
  final String? lastUpdate;
  final String? serviceCategory;
  final String? officeName;
  final String? officeNameFurigana;
  final String? postalCode;
  final String? address;
  final String? phoneNumber;
  final String? fax;
  final String? specificDisability;
  final String? regionalTransitionSupport;
  final String? businessImplementationRegion;
  final String? latitudeLongitude;
  final String? brochure;
  final String? pageUrl;
  final Uint8List? eyecatch;

  const PlanningConsultation({
    required this.itemId,
    this.lastUpdate,
    this.serviceCategory,
    this.officeName,
    this.officeNameFurigana,
    this.postalCode,
    this.address,
    this.phoneNumber,
    this.fax,
    this.specificDisability,
    this.regionalTransitionSupport,
    this.businessImplementationRegion,
    this.latitudeLongitude,
    this.brochure,
    this.pageUrl,
    this.eyecatch,
  });

  factory PlanningConsultation.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'item_id': int itemId,
        'last_update': String? lastUpdate,
        'service_category': String? serviceCategory,
        'office_name': String? officeName,
        'office_name_furigana': String? officeNameFurigana,
        'postal_code': String? postalCode,
        'address': String? address,
        'phone_number': String? phoneNumber,
        'fax': String? fax,
        'specific_disability': String? specificDisability,
        'regional_transition_support': String? regionalTransitionSupport,
        'business_implementation_region': String? businessImplementationRegion,
        'latitude_longitude': String? latitudeLongitude,
        'brochure': String? brochure,
        'page_url': String? pageUrl,
        // 'eyecatch': Uint8List? eyecatch,
      } =>
        PlanningConsultation(
          itemId: itemId,
          lastUpdate: lastUpdate,
          serviceCategory: serviceCategory,
          officeName: officeName,
          officeNameFurigana: officeNameFurigana,
          postalCode: postalCode,
          address: address,
          phoneNumber: phoneNumber,
          fax: fax,
          specificDisability: specificDisability,
          regionalTransitionSupport: regionalTransitionSupport,
          businessImplementationRegion: businessImplementationRegion,
          latitudeLongitude: latitudeLongitude,
          brochure: brochure,
          pageUrl: pageUrl,
          // eyecatch: eyecatch,
        ),
      _ => throw const FormatException('Failed to load PlanningConsultation.'),
    };
  }
}

class HelperStation {
  final int itemId;
  final String? lastUpdate;
  final String? serviceCategory;
  final String? officeName;
  final String? officeNameFurigana;
  final String? address;
  final String? phoneNumber;
  final int serviceInOkayamaNorthExceptMitsuAndTakebe;
  final String? serviceInOkayamaNorthExceptMitsuAndTakebeNotes;
  final int serviceInOkayamaNorthInMitsuAndTakebe;
  final String? serviceInOkayamaNorthInMitsuAndTakebeNotes;
  final int serviceInOkayamaMiddle;
  final String? serviceInOkayamaMiddleNotes;
  final int serviceInOkayamaEast;
  final String? serviceInOkayamaEastNotes;
  final int serviceInOkayamaSouth;
  final String? serviceInOkayamaSouthNotes;
  final int homeCareServiceProvision;
  final String? homeCareServiceProvisionNotes;
  final int severeVisitCareServiceProvision;
  final String? severeVisitCareServiceProvisionNotes;
  final int accompanimentSupportServiceProvision;
  final String? accompanimentSupportServiceProvisionNotes;
  final int behaviorSupportServiceProvision;
  final String? behaviorSupportServiceProvisionNotes;
  final int movementSupportServiceProvision;
  final String? movementSupportServiceProvisionNotes;
  final int careInsuranceServiceProvision;
  final String? careInsuranceServiceProvisionNotes;
  final int partialMedicalCareResponse;
  final String? partialMedicalCareResponseNotes;
  final int weekendHolidaysService;
  final String? weekendHolidaysServiceNotes;
  final int earlyMorningService;
  final String? earlyMorningServiceNotes;
  final int eveningService;
  final String? eveningServiceNotes;
  final int overnightService;
  final String? overnightServiceNotes;
  final String? latitudeLongitude;
  final String? brochure;
  final String? pageUrl;
  final Uint8List? eyecatch;

  const HelperStation({
    required this.itemId,
    this.lastUpdate,
    this.serviceCategory,
    this.officeName,
    this.officeNameFurigana,
    this.address,
    this.phoneNumber,
    required this.serviceInOkayamaNorthExceptMitsuAndTakebe,
    this.serviceInOkayamaNorthExceptMitsuAndTakebeNotes,
    required this.serviceInOkayamaNorthInMitsuAndTakebe,
    this.serviceInOkayamaNorthInMitsuAndTakebeNotes,
    required this.serviceInOkayamaMiddle,
    this.serviceInOkayamaMiddleNotes,
    required this.serviceInOkayamaEast,
    this.serviceInOkayamaEastNotes,
    required this.serviceInOkayamaSouth,
    this.serviceInOkayamaSouthNotes,
    required this.homeCareServiceProvision,
    this.homeCareServiceProvisionNotes,
    required this.severeVisitCareServiceProvision,
    this.severeVisitCareServiceProvisionNotes,
    required this.accompanimentSupportServiceProvision,
    this.accompanimentSupportServiceProvisionNotes,
    required this.behaviorSupportServiceProvision,
    this.behaviorSupportServiceProvisionNotes,
    required this.movementSupportServiceProvision,
    this.movementSupportServiceProvisionNotes,
    required this.careInsuranceServiceProvision,
    this.careInsuranceServiceProvisionNotes,
    required this.partialMedicalCareResponse,
    this.partialMedicalCareResponseNotes,
    required this.weekendHolidaysService,
    this.weekendHolidaysServiceNotes,
    required this.earlyMorningService,
    this.earlyMorningServiceNotes,
    required this.eveningService,
    this.eveningServiceNotes,
    required this.overnightService,
    this.overnightServiceNotes,
    this.latitudeLongitude,
    this.brochure,
    this.pageUrl,
    this.eyecatch,
  });

  factory HelperStation.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'item_id': int itemId,
        'last_update': String? lastUpdate,
        'service_category': String? serviceCategory,
        'office_name': String? officeName,
        'office_name_furigana': String? officeNameFurigana,
        'address': String? address,
        'phone_number': String? phoneNumber,
        'service_in_okayama_north_except_mitsu_and_takebe': int
            serviceInOkayamaNorthExceptMitsuAndTakebe,
        'service_in_okayama_north_except_mitsu_and_takebe_notes': String?
            serviceInOkayamaNorthExceptMitsuAndTakebeNotes,
        'service_in_okayama_north_in_mitsu_and_takebe': int
            serviceInOkayamaNorthInMitsuAndTakebe,
        'service_in_okayama_north_in_mitsu_and_takebe_notes': String?
            serviceInOkayamaNorthInMitsuAndTakebeNotes,
        'service_in_okayama_middle': int serviceInOkayamaMiddle,
        'service_in_okayama_middle_notes': String? serviceInOkayamaMiddleNotes,
        'service_in_okayama_east': int serviceInOkayamaEast,
        'service_in_okayama_east_notes': String? serviceInOkayamaEastNotes,
        'service_in_okayama_south': int serviceInOkayamaSouth,
        'service_in_okayama_south_notes': String? serviceInOkayamaSouthNotes,
        'home_care_service_provision': int homeCareServiceProvision,
        'home_care_service_provision_notes': String?
            homeCareServiceProvisionNotes,
        'severe_visit_care_service_provision': int
            severeVisitCareServiceProvision,
        'severe_visit_care_service_provision_notes': String?
            severeVisitCareServiceProvisionNotes,
        'accompaniment_support_service_provision': int
            accompanimentSupportServiceProvision,
        'accompaniment_support_service_provision_notes': String?
            accompanimentSupportServiceProvisionNotes,
        'behavior_support_service_provision': int
            behaviorSupportServiceProvision,
        'behavior_support_service_provision_notes': String?
            behaviorSupportServiceProvisionNotes,
        'movement_support_service_provision': int
            movementSupportServiceProvision,
        'movement_support_service_provision_notes': String?
            movementSupportServiceProvisionNotes,
        'care_insurance_service_provision': int careInsuranceServiceProvision,
        'care_insurance_service_provision_notes': String?
            careInsuranceServiceProvisionNotes,
        'partial_medical_care_response': int partialMedicalCareResponse,
        'partial_medical_care_response_notes': String?
            partialMedicalCareResponseNotes,
        'weekend_holidays_service': int weekendHolidaysService,
        'weekend_holidays_service_notes': String? weekendHolidaysServiceNotes,
        'early_morning_service': int earlyMorningService,
        'early_morning_service_notes': String? earlyMorningServiceNotes,
        'evening_service': int eveningService,
        'evening_service_notes': String? eveningServiceNotes,
        'overnight_service': int overnightService,
        'overnight_service_notes': String? overnightServiceNotes,
        'latitude_longitude': String? latitudeLongitude,
        'brochure': String? brochure,
        'page_url': String? pageUrl,
        // 'eyecatch': Uint8List? eyecatch,
      } =>
        HelperStation(
          itemId: itemId,
          lastUpdate: lastUpdate,
          serviceCategory: serviceCategory,
          officeName: officeName,
          officeNameFurigana: officeNameFurigana,
          address: address,
          phoneNumber: phoneNumber,
          serviceInOkayamaNorthExceptMitsuAndTakebe:
              serviceInOkayamaNorthExceptMitsuAndTakebe,
          serviceInOkayamaNorthExceptMitsuAndTakebeNotes:
              serviceInOkayamaNorthExceptMitsuAndTakebeNotes,
          serviceInOkayamaNorthInMitsuAndTakebe:
              serviceInOkayamaNorthInMitsuAndTakebe,
          serviceInOkayamaNorthInMitsuAndTakebeNotes:
              serviceInOkayamaNorthInMitsuAndTakebeNotes,
          serviceInOkayamaMiddle: serviceInOkayamaMiddle,
          serviceInOkayamaMiddleNotes: serviceInOkayamaMiddleNotes,
          serviceInOkayamaEast: serviceInOkayamaEast,
          serviceInOkayamaEastNotes: serviceInOkayamaEastNotes,
          serviceInOkayamaSouth: serviceInOkayamaSouth,
          serviceInOkayamaSouthNotes: serviceInOkayamaSouthNotes,
          homeCareServiceProvision: homeCareServiceProvision,
          homeCareServiceProvisionNotes: homeCareServiceProvisionNotes,
          severeVisitCareServiceProvision: severeVisitCareServiceProvision,
          severeVisitCareServiceProvisionNotes:
              severeVisitCareServiceProvisionNotes,
          accompanimentSupportServiceProvision:
              accompanimentSupportServiceProvision,
          accompanimentSupportServiceProvisionNotes:
              accompanimentSupportServiceProvisionNotes,
          behaviorSupportServiceProvision: behaviorSupportServiceProvision,
          behaviorSupportServiceProvisionNotes:
              behaviorSupportServiceProvisionNotes,
          movementSupportServiceProvision: movementSupportServiceProvision,
          movementSupportServiceProvisionNotes:
              movementSupportServiceProvisionNotes,
          careInsuranceServiceProvision: careInsuranceServiceProvision,
          careInsuranceServiceProvisionNotes:
              careInsuranceServiceProvisionNotes,
          partialMedicalCareResponse: partialMedicalCareResponse,
          partialMedicalCareResponseNotes: partialMedicalCareResponseNotes,
          weekendHolidaysService: weekendHolidaysService,
          weekendHolidaysServiceNotes: weekendHolidaysServiceNotes,
          earlyMorningService: earlyMorningService,
          earlyMorningServiceNotes: earlyMorningServiceNotes,
          eveningService: eveningService,
          eveningServiceNotes: eveningServiceNotes,
          overnightService: overnightService,
          overnightServiceNotes: overnightServiceNotes,
          latitudeLongitude: latitudeLongitude,
          brochure: brochure,
          pageUrl: pageUrl,
          // eyecatch: eyecatch,
        ),
      _ => throw const FormatException('Failed to load HelperStation.'),
    };
  }
}

class DisabilityService {
  final int itemId;
  final String? lastUpdate;
  final String? serviceCategory;
  final String? officeName;
  final String? officeNameFurigana;
  final String? operatingEntity;
  final String? postalCode;
  final String? address;
  final String? phoneNumber;
  final String? fax;
  final String? email;
  final String? homepageUrl;
  final String? capacity;
  final String? transportation;
  final String? serviceProvisionTime;
  final String? usageFee;
  final String? wage;
  final String? medicalCareAvailability;
  final String? optionalServiceBath;
  final String? optionalServiceTransportation;
  final String? optionalServiceDetails;
  final String? businessContent;
  final String? officeFeatures;
  final String? latitudeLongitude;
  final String? officePhoto;
  final String? officeExteriorImage;
  final String? officeMapImage;
  final String? brochure;
  final String? pageUrl;
  final Uint8List? eyecatch;

  const DisabilityService({
    required this.itemId,
    this.lastUpdate,
    this.serviceCategory,
    this.officeName,
    this.officeNameFurigana,
    this.operatingEntity,
    this.postalCode,
    this.address,
    this.phoneNumber,
    this.fax,
    this.email,
    this.homepageUrl,
    this.capacity,
    this.transportation,
    this.serviceProvisionTime,
    this.usageFee,
    this.wage,
    this.medicalCareAvailability,
    this.optionalServiceBath,
    this.optionalServiceTransportation,
    this.optionalServiceDetails,
    this.businessContent,
    this.officeFeatures,
    this.latitudeLongitude,
    this.officePhoto,
    this.officeExteriorImage,
    this.officeMapImage,
    this.brochure,
    this.pageUrl,
    this.eyecatch,
  });

  factory DisabilityService.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'item_id': int itemId,
        'last_update': String? lastUpdate,
        'service_category': String? serviceCategory,
        'office_name': String? officeName,
        'office_name_furigana': String? officeNameFurigana,
        'operating_entity': String? operatingEntity,
        'postal_code': String? postalCode,
        'address': String? address,
        'phone_number': String? phoneNumber,
        'fax': String? fax,
        'email': String? email,
        'homepage_url': String? homepageUrl,
        'capacity': String? capacity,
        'transportation': String? transportation,
        'service_provision_time': String? serviceProvisionTime,
        'usage_fee': String? usageFee,
        'wage': String? wage,
        'medical_care_availability': String? medicalCareAvailability,
        'optional_service_bath': String? optionalServiceBath,
        'optional_service_transportation': String?
            optionalServiceTransportation,
        'optional_service_details': String? optionalServiceDetails,
        'business_content': String? businessContent,
        'office_features': String? officeFeatures,
        'latitude_longitude': String? latitudeLongitude,
        'office_photo': String? officePhoto,
        'office_exterior_image': String? officeExteriorImage,
        'office_map_image': String? officeMapImage,
        'brochure': String? brochure,
        'page_url': String? pageUrl,
        'eyecatch': Uint8List? eyecatch,
      } =>
        DisabilityService(
          itemId: itemId,
          lastUpdate: lastUpdate,
          serviceCategory: serviceCategory,
          officeName: officeName,
          officeNameFurigana: officeNameFurigana,
          operatingEntity: operatingEntity,
          postalCode: postalCode,
          address: address,
          phoneNumber: phoneNumber,
          fax: fax,
          email: email,
          homepageUrl: homepageUrl,
          capacity: capacity,
          transportation: transportation,
          serviceProvisionTime: serviceProvisionTime,
          usageFee: usageFee,
          wage: wage,
          medicalCareAvailability: medicalCareAvailability,
          optionalServiceBath: optionalServiceBath,
          optionalServiceTransportation: optionalServiceTransportation,
          optionalServiceDetails: optionalServiceDetails,
          businessContent: businessContent,
          officeFeatures: officeFeatures,
          latitudeLongitude: latitudeLongitude,
          officePhoto: officePhoto,
          officeExteriorImage: officeExteriorImage,
          officeMapImage: officeMapImage,
          brochure: brochure,
          pageUrl: pageUrl,
          eyecatch: eyecatch,
        ),
      _ => throw const FormatException('Failed to load DisabilityService.'),
    };
  }
}

Database initDatabase(String path, String? password) {
  final db = sqlite3.open(path);
  if (password == null) {
    return db;
  }
  if (db.select('PRAGMA cipher_version;').isEmpty) {
    // Make sure that we're actually using SQLCipher, since the pragma used to encrypt
    // databases just fails silently with regular sqlite3 (meaning that we'd accidentally
    // use plaintext databases).
    throw StateError(
        'SQLCipher library is not available, please check your dependencies!');
  }

  // Set the encryption key for the database
  db.execute("PRAGMA key = \"x'$password'\";");
  return db;
}

class EnjanetDatabase {
  Database db;
  EnjanetDatabase(this.db);

  List<SearchResult> search(DbSearchCriteria criteria) {
    // TODO: criteriaのtablesにsearchTable以外の文字列が入っていないかassert
    final unionAll = criteria.tables.map((v) {
      final tableId = v.value;
      final tableName = v.toTableName!;
      return "SELECT id,item_id,service_category, office_name, office_name_furigana, address, latitude_longitude, eyecatch, $tableId AS table_type FROM $tableName\n";
    }).join(' UNION ALL ');

    if (unionAll.isEmpty) return [];

    var query = '''
      SELECT id,item_id, service_category, office_name, office_name_furigana, address, latitude_longitude, table_type, eyecatch
      FROM ($unionAll) AS combined_tables
      WHERE office_name LIKE ?
    ''';

    String categoriesQuery = criteria.categories
        .map((category) =>
            "instr('||' || service_category || '||', '||$category||') > 0")
        .join(" OR ");
    if (categoriesQuery.isNotEmpty) {
      query += "AND ($categoriesQuery)";
    }
    query += ";";

    final r = db.select(query, ["%${criteria.term ?? ''}%"]);
    return r.map((row) {
      return SearchResult.fromData(row); // データをマッピングする
    }).toList();
  }

  String filteredAllColmunName(String tableName, List<String> excludeColumns) {
    final result = db.select('PRAGMA table_info($tableName)');
    final allColumns = result.map((row) => row['name'] as String).toList();

    // 除外するカラムを除いたカラムリストを作成
    final selectedColumns =
        allColumns.where((column) => !excludeColumns.contains(column)).toList();
    final columnString = selectedColumns.join(', ');
    return columnString;
  }

  DisabilityService? getFirstDisabilityServiceByItemId(int itemId) {
    final columnString =
        filteredAllColmunName(TABLENAME_DISABILITY_SERVICES, []);

    final stmt = db.prepare(
        'SELECT $columnString FROM $TABLENAME_DISABILITY_SERVICES WHERE item_id = ? LIMIT 1');
    final r = stmt.select([itemId]);
    if (r.isEmpty) {
      return null;
    }

    return DisabilityService.fromJson(r.first);
  }

  ChildService? getFirstChildServiceByItemId(int itemId) {
    final columnString = filteredAllColmunName(TABLENAME_CHILD_SERVICES, []);

    final stmt = db.prepare(
        'SELECT $columnString FROM $TABLENAME_CHILD_SERVICES WHERE item_id = ? LIMIT 1');
    final ResultSet r = stmt.select([itemId]);
    if (r.isEmpty) {
      return null;
    }
    return ChildService.fromJson(r.first);
  }

  HelperStation? getFirstHelperStationByItemId(int itemId) {
    final columnString = filteredAllColmunName(TABLENAME_HELPER_STATIONS, []);

    final stmt = db.prepare(
        'SELECT $columnString FROM $TABLENAME_HELPER_STATIONS WHERE item_id = ? LIMIT 1');
    final ResultSet r = stmt.select([itemId]);
    if (r.isEmpty) {
      return null;
    }
    return HelperStation.fromJson(r.first);
  }

  HospitalClinic? getFirstHospitalClinicByItemId(int itemId) {
    final columnString = filteredAllColmunName(TABLENAME_HOSPITALS_CLINICS, []);
    final stmt = db.prepare(
        'SELECT $columnString FROM $TABLENAME_HOSPITALS_CLINICS WHERE item_id = ? LIMIT 1');
    final ResultSet r = stmt.select([itemId]);
    if (r.isEmpty) {
      return null;
    }
    return HospitalClinic.fromJson(r.first);
  }

  Future<PlanningConsultation?> getFirstPlanningConsultationByItemId(
      int itemId) async {
    final columnString =
        filteredAllColmunName(TABLENAME_PLANNING_CONSULTATIONS, []);
    final stmt = db.prepare(
        'SELECT $columnString FROM $TABLENAME_PLANNING_CONSULTATIONS WHERE item_id = ? LIMIT 1');
    final ResultSet r = stmt.select([itemId]);
    if (r.isEmpty) {
      return null;
    }
    return PlanningConsultation.fromJson(r.first);
  }

  List<SearchResult> searchOnBookmarks(List<Bookmark> bookmarks, String? term) {
    // NULLなのを省く
    final validBookmarks = bookmarks;

    // final bookmarkIds =
    //     validBookmarks.map((bookmark) => bookmark.itemId!).toList();
    // final bookmarkTables =
    //     validBookmarks.map((bookmark) => bookmark.tableType!).toList();

    // final tables = {
    //   SearchTable.hospitalsClinics: hospitalsClinics,
    //   SearchTable.groupHomes: groupHomes,
    //   SearchTable.childServices: childServices,
    //   SearchTable.planningConsultations: planningConsultations,
    //   SearchTable.helperStations: helperStations,
    //   SearchTable.disabilityServices: disabilityServices,
    // };

    final ins = validBookmarks.map((e) {
      return '(${e.itemId}, ${e.tableType})';
    }).join(',');

    final unionAll = SearchTableNameEnum.namesAndValues.entries.map((e) {
      return "SELECT id,item_id,service_category, office_name, office_name_furigana, address, latitude_longitude, ${e.key} AS table_type FROM ${e.value}";
    }).join(' UNION ALL ');

    var query = '''
      SELECT id,item_id, service_category, office_name, office_name_furigana, address, latitude_longitude, table_type
      FROM ($unionAll) AS combined_tables
      WHERE office_name LIKE ? AND (item_id, table_type) IN ($ins)
    ''';

    query += ";";

    final stmt = db.prepare(query);
    final r = stmt.select(["%${term ?? ''}%"]);
    if (r.isEmpty) {
      return [];
    }

    return r.map((row) {
      return SearchResult.fromData(row); // データをマッピングする
    }).toList();
  }
  /*
  設定の取得:
  */

  MetaData? getDatabaseMetadata(String name) {
    final stmt =
        db.prepare('SELECT * FROM $TABLENAME_METADATA WHERE name = ? LIMIT 1');

    final ResultSet r = stmt.select([name]);
    if (r.isEmpty) {
      return null;
    }
    return MetaData.fromJson(r.first);
  }

  MetaData? getDatabaseMtime() {
    return getDatabaseMetadata("mtime");
  }

  Future<MetaData?> getDatabaseVersion() async {
    return getDatabaseMetadata("version");
  }
}

const String TABLENAME_DATAS = 'user_data';
// ignore: constant_identifier_names
const String TABLENAME_BOOKMARKS = 'user_bookmarks';
// ignore: constant_identifier_names
const String TABLENAME_SETTINGS = 'user_settings';

class Data {
  final String? name;
  final String? value;

  const Data({
    this.name,
    this.value,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'name': String? name,
        'value': String? value,
      } =>
        Data(
          name: name,
          value: value,
        ),
      _ => throw const FormatException('Failed to load Data.'),
    };
  }
}

class Bookmark {
  final int id;
  final int itemId;
  final int tableType;
  final int createdAt;

  const Bookmark({
    required this.id,
    required this.itemId,
    required this.tableType,
    required this.createdAt,
  });

  factory Bookmark.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'item_id': int itemId,
        'table_type': int tableType,
        'created_at': int createdAtString,
      } =>
        Bookmark(
          id: id,
          itemId: itemId,
          tableType: tableType,
          createdAt: createdAtString,
        ),
      _ => throw const FormatException('Failed to load Bookmark.'),
    };
  }
}

class Setting {
  final String? name;
  final String? value;

  const Setting({
    this.name,
    this.value,
  });

  factory Setting.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'name': String? name,
        'value': String? value,
      } =>
        Setting(
          name: name,
          value: value,
        ),
      _ => throw const FormatException('Failed to load Setting.'),
    };
  }
}

class UserDatabase {
  Database db;
  UserDatabase(this.db);

  printTableNames() {
    final ResultSet resultSet = db.select(
        "SELECT name FROM sqlite_master WHERE type='table' ORDER BY name;");

    if (kDebugMode) {
      print(resultSet.map((row) => row['name'] as String).toList());
    }
  }

  /*
    設定
    */

  String? getSetting(String name) {
    final stmt =
        db.prepare('SELECT * FROM $TABLENAME_SETTINGS WHERE name = ? LIMIT 1');
    final r = stmt.select([name]);
    if (r.isEmpty) {
      return null;
    }
    return Setting.fromJson(r.first).value;
  }

  void insertOrIgnoreSettings(String key, String? value) {
    final stmt = db.prepare('''
        INSERT OR IGNORE INTO $TABLENAME_SETTINGS (name, value)
        VALUES (?, ?)
    ''');

    stmt.execute([key, value]);
  }

  void upsertSetting(String key, String? value) async {
    final stmt = db.prepare('''
      INSERT OR REPLACE INTO $TABLENAME_SETTINGS (name, value)
      VALUES (?, ?)
      ''');
    stmt.execute([key, value]);
  }

  /*
    Bookmark
    */

  Bookmark? getBookmark(int itemId, SearchTableNameEnum tableType) {
    final stmt = db.prepare(
        'SELECT * FROM $TABLENAME_BOOKMARKS WHERE item_id = ? AND table_type = ? LIMIT 1');
    final r = stmt.select([itemId, tableType.value]);
    if (r.isEmpty) {
      return null;
    }
    return Bookmark.fromJson(r.first);
  }

  void addBookmark(int itemId, SearchTableNameEnum tableType) {
    db.execute(
      'INSERT OR IGNORE INTO $TABLENAME_BOOKMARKS (item_id, table_type, created_at) VALUES (?, ?, ?)',
      [itemId, tableType.value, DateTime.now().millisecondsSinceEpoch],
    );
  }

  void removeBookmark(int itemId, SearchTableNameEnum tableType) {
    db.execute(
      'DELETE FROM $TABLENAME_BOOKMARKS WHERE item_id = ? AND table_type = ?',
      [itemId, tableType.value],
    );
  }

  List<Bookmark>? getBookmarkList() {
    final stmt = db.prepare('SELECT * FROM $TABLENAME_BOOKMARKS');
    final r = stmt.select();
    if (r.isEmpty) {
      return [];
    }

    return r.map((rows) {
      return Bookmark.fromJson(rows);
    }).toList();
  }

  Map<String, String> getAllTableCreateStatements() {
    try {
      final result = db.select(
          "SELECT name, sql FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'");

      Map<String, String> tableStatements = {};
      for (final Row row in result) {
        String tableName = row['name'] as String;
        String createStatement = row['sql'] as String;
        tableStatements[tableName] = createStatement;
      }

      return tableStatements;
    } catch (e) {
      if (kDebugMode) {
        print('エラー: $e');
      }
      return {};
    }
  }
}
