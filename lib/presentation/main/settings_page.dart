import 'package:complete_advanced_flutter/app/app_preferences.dart';
import 'package:complete_advanced_flutter/app/dependency_injection.dart';
import 'package:complete_advanced_flutter/data/data_source/local_data_source.dart';
import 'package:complete_advanced_flutter/presentation/resources/assets_manager.dart';
import 'package:complete_advanced_flutter/presentation/resources/language_manager.dart';
import 'package:complete_advanced_flutter/presentation/resources/routes_manager.dart';
import 'package:complete_advanced_flutter/presentation/resources/strings_manager.dart';
import 'package:complete_advanced_flutter/presentation/resources/values_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:math' as math;

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final AppPreferences _appPreferences = instance<AppPreferences>();
  final LocalDataSource _localDataSource = instance<LocalDataSource>();

  bool openLanguageList = false;

  void _changeLanguage(LanguageType languageType) async {
    String currentLanguage = await _appPreferences.getAppLanguage();

    if (currentLanguage != languageType.getValue()) {
      _appPreferences.setLanguageChanged(languageType);
      Phoenix.rebirth(context);
    }
    setState(() {
      openLanguageList = false;
    });
  }

  void _contactUs() {
    // its a task for you to open any web bage with dummy content
  }

  void _inviteFriends() {
    // its a task to share app name with friends
  }

  void _logout() {
    _appPreferences.logout(); // clear login flag from app prefs
    _localDataSource.clearCache();
    Navigator.pushReplacementNamed(context, Routes.loginRoute);
  }

  bool isRtl() {
    return context.locale == ARABIC_LOCAL; // app is in arabic language
  }

  @override
  Widget build(BuildContext context) {
    return (openLanguageList == true)
        ? changeLanguageListView()
        : settingsListView();
  }

  Widget settingsListView() {
    return ListView(
      padding: EdgeInsets.all(AppPadding.p8),
      children: [
        ListTile(
          title: Text(
            AppStrings.changeLanguage,
            style: Theme.of(context).textTheme.headline4,
          ).tr(),
          leading: SvgPicture.asset(ImageAssets.changeLangIc),
          trailing: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(isRtl() ? math.pi : 0),
            child: SvgPicture.asset(ImageAssets.settingsRightArrowIc),
          ),
          onTap: () {
            setState(() {
              openLanguageList = true;
            });
          },
        ),
        ListTile(
          title: Text(
            AppStrings.contactUs,
            style: Theme.of(context).textTheme.headline4,
          ).tr(),
          leading: SvgPicture.asset(ImageAssets.contactUsIc),
          trailing: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(isRtl() ? math.pi : 0),
            child: SvgPicture.asset(ImageAssets.settingsRightArrowIc),
          ),
          onTap: () {
            _contactUs();
          },
        ),
        ListTile(
          title: Text(
            AppStrings.inviteYourFriends,
            style: Theme.of(context).textTheme.headline4,
          ).tr(),
          leading: SvgPicture.asset(ImageAssets.inviteFriendsIc),
          trailing: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(isRtl() ? math.pi : 0),
            child: SvgPicture.asset(ImageAssets.settingsRightArrowIc),
          ),
          onTap: () {
            _inviteFriends();
          },
        ),
        ListTile(
          title: Text(
            AppStrings.logout,
            style: Theme.of(context).textTheme.headline4,
          ).tr(),
          leading: SvgPicture.asset(ImageAssets.logoutIc),
          trailing: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(isRtl() ? math.pi : 0),
            child: SvgPicture.asset(ImageAssets.settingsRightArrowIc),
          ),
          onTap: () {
            _logout();
          },
        ),
      ],
    );
  }

  Widget changeLanguageListView() {
    return ListView(
      padding: EdgeInsets.all(AppPadding.p8),
      children: [
        ListTile(
          title: Text(
            AppStrings.langEnglish,
            style: Theme.of(context).textTheme.headline4,
          ).tr(),
          leading: Flag.fromCode(
            FlagsCode.US,
            height: AppSize.s12,
            width: AppSize.s16,
          ),
          trailing: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(isRtl() ? math.pi : 0),
            child: SvgPicture.asset(ImageAssets.settingsRightArrowIc),
          ),
          onTap: () {
            _changeLanguage(LanguageType.ENGLISH);
          },
        ),
        ListTile(
          title: Text(
            AppStrings.langArabic,
            style: Theme.of(context).textTheme.headline4,
          ).tr(),
          leading: Flag.fromCode(
            FlagsCode.SA,
            height: AppSize.s12,
            width: AppSize.s16,
          ),
          trailing: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(isRtl() ? math.pi : 0),
            child: SvgPicture.asset(ImageAssets.settingsRightArrowIc),
          ),
          onTap: () {
            _changeLanguage(LanguageType.ARABIC);
          },
        ),
        ListTile(
          title: Text(
            AppStrings.langPortuguese,
            style: Theme.of(context).textTheme.headline4,
          ).tr(),
          leading: Flag.fromCode(
            FlagsCode.BR,
            height: AppSize.s12,
            width: AppSize.s16,
          ),
          trailing: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(isRtl() ? math.pi : 0),
            child: SvgPicture.asset(ImageAssets.settingsRightArrowIc),
          ),
          onTap: () {
            _changeLanguage(LanguageType.PORTUGUESE);
          },
        ),
      ],
    );
  }
}
