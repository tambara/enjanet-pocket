// カスタムボタン色を定義するクラス
import 'package:flutter/material.dart';

class BottomSheetNavColors extends ThemeExtension<BottomSheetNavColors> {
  final Color workButtonColor;
  final Color medicalButtonColor;
  final Color restButtonColor;
  final Color childButtonColor;
  final Color activityButtonColor;
  final Color planButtonColor;
  final Color helperButtonColor;

  final Color bookmarksButtonColor;
  final Color settingsButtonColor;
  final Color websiteButtonColor;

  BottomSheetNavColors({
    required this.workButtonColor,
    required this.medicalButtonColor,
    required this.restButtonColor,
    required this.childButtonColor,
    required this.activityButtonColor,
    required this.planButtonColor,
    required this.helperButtonColor,
    required this.bookmarksButtonColor,
    required this.settingsButtonColor,
    required this.websiteButtonColor,
  });

  @override
  ThemeExtension<BottomSheetNavColors> copyWith({
    Color? workButtonColor,
    Color? medicalButtonColor,
    Color? restButtonColor,
    Color? childButtonColor,
    Color? activityButtonColor,
    Color? planButtonColor,
    Color? helperButtonColor,
    Color? bookmarksButtonColor,
    Color? settingsButtonColor,
    Color? websiteButtonColor,
  }) {
    return BottomSheetNavColors(
      workButtonColor: workButtonColor ?? this.workButtonColor,
      medicalButtonColor: medicalButtonColor ?? this.medicalButtonColor,
      restButtonColor: restButtonColor ?? this.restButtonColor,
      childButtonColor: childButtonColor ?? this.childButtonColor,
      activityButtonColor: activityButtonColor ?? this.activityButtonColor,
      planButtonColor: planButtonColor ?? this.planButtonColor,
      helperButtonColor: helperButtonColor ?? this.helperButtonColor,
      bookmarksButtonColor: bookmarksButtonColor ?? this.bookmarksButtonColor,
      settingsButtonColor: settingsButtonColor ?? this.settingsButtonColor,
      websiteButtonColor: websiteButtonColor ?? this.websiteButtonColor,
    );
  }

  @override
  ThemeExtension<BottomSheetNavColors> lerp(
      ThemeExtension<BottomSheetNavColors>? other, double t) {
    if (other is! BottomSheetNavColors) {
      return this;
    }
    return BottomSheetNavColors(
      workButtonColor: Color.lerp(workButtonColor, other.workButtonColor, t)!,
      medicalButtonColor:
          Color.lerp(medicalButtonColor, other.medicalButtonColor, t)!,
      restButtonColor: Color.lerp(restButtonColor, other.restButtonColor, t)!,
      childButtonColor:
          Color.lerp(childButtonColor, other.childButtonColor, t)!,
      activityButtonColor:
          Color.lerp(activityButtonColor, other.activityButtonColor, t)!,
      planButtonColor: Color.lerp(planButtonColor, other.planButtonColor, t)!,
      helperButtonColor:
          Color.lerp(helperButtonColor, other.helperButtonColor, t)!,
      bookmarksButtonColor:
          Color.lerp(bookmarksButtonColor, other.bookmarksButtonColor, t)!,
      settingsButtonColor:
          Color.lerp(settingsButtonColor, other.settingsButtonColor, t)!,
      websiteButtonColor:
          Color.lerp(websiteButtonColor, other.websiteButtonColor, t)!,
    );
  }
}
