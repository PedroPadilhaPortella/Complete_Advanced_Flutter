import 'package:complete_advanced_flutter/presentation/resources/language_manager.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String PREFS_KEY_LANG = "PREFS_KEY_LANG";
const String PREFS_KEY_ONBOARDING_SCREEN = "PREFS_KEY_ONBOARDING_SCREEN";
const String PREFS_KEY_IS_USER_LOGGED_IN = "PREFS_KEY_IS_USER_LOGGED_IN";

class AppPreferences {
  SharedPreferences _sharedPreferences;

  AppPreferences(this._sharedPreferences);

  Future<String> getAppLanguage() async {
    String? language = _sharedPreferences.getString(PREFS_KEY_LANG);

    if (language != null && language.isNotEmpty) {
      return language;
    } else {
      return LanguageType.ENGLISH.getValue();
    }
  }

  Future<void> setLanguageChanged(LanguageType languageType) async {
    if (languageType == LanguageType.ARABIC) {
      _sharedPreferences.setString(
        PREFS_KEY_LANG,
        LanguageType.ARABIC.getValue(),
      );
    } else if (languageType == LanguageType.PORTUGUESE) {
      _sharedPreferences.setString(
        PREFS_KEY_LANG,
        LanguageType.PORTUGUESE.getValue(),
      );
    } else {
      _sharedPreferences.setString(
        PREFS_KEY_LANG,
        LanguageType.ENGLISH.getValue(),
      );
    }
  }

  Future<Locale> getLocal() async {
    String currentLanguage = await getAppLanguage();
    if (currentLanguage == LanguageType.ARABIC.getValue()) {
      return ARABIC_LOCAL;
    } else if (currentLanguage == LanguageType.PORTUGUESE.getValue()) {
      return PORTUGUESE_LOCAL;
    } else {
      return ENGLISH_LOCAL;
    }
  }

  Future<void> setOnboardingScreenViewed() async {
    _sharedPreferences.setBool(PREFS_KEY_ONBOARDING_SCREEN, true);
  }

  Future<bool> isOnboardingScreenViewed() async {
    return _sharedPreferences.getBool(PREFS_KEY_ONBOARDING_SCREEN) ?? false;
  }

  Future<void> setUserLoggedIn() async {
    _sharedPreferences.setBool(PREFS_KEY_IS_USER_LOGGED_IN, true);
  }

  Future<bool> isUserLoggedIn() async {
    return _sharedPreferences.getBool(PREFS_KEY_IS_USER_LOGGED_IN) ?? false;
  }

  Future<void> logout() async {
    _sharedPreferences.remove(PREFS_KEY_IS_USER_LOGGED_IN);
  }
}
