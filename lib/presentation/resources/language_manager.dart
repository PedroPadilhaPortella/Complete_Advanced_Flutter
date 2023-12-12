import 'package:flutter/material.dart';

enum LanguageType { ENGLISH, ARABIC, PORTUGUESE }

const String ASSETS_PATH_LOCALIZATIONS = "assets/translations";

const String ARABIC = "ar";
const String ENGLISH = "en";
const String PORTUGUESE = "pt";

const Locale ARABIC_LOCAL = Locale("ar", "SA");
const Locale ENGLISH_LOCAL = Locale("en", "US");
const Locale PORTUGUESE_LOCAL = Locale("pt", "BR");

extension LanguageTypeExtension on LanguageType {
  String getValue() {
    switch (this) {
      case LanguageType.ENGLISH:
        return ENGLISH;
      case LanguageType.ARABIC:
        return ARABIC;
      case LanguageType.PORTUGUESE:
        return PORTUGUESE;
    }
  }
}
