import 'package:complete_advanced_flutter/app/app_preferences.dart';
import 'package:complete_advanced_flutter/app/dependency_injection.dart';
import 'package:complete_advanced_flutter/presentation/resources/routes_manager.dart';
import 'package:easy_localization/easy_localization.dart';

import '../presentation/resources/theme_manager.dart';
import 'package:flutter/material.dart';

class MyApp extends StatefulWidget {
  MyApp._internal(); // private named constructor

  int appState = 0;

  static final MyApp instance = MyApp._internal(); // single instace - singleton

  factory MyApp() => instance; // factory for the class  instance

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppPreferences _appPreferences = instance<AppPreferences>();

  @override
  void didChangeDependencies() {
    _appPreferences.getLocal().then((local) => {context.setLocale(local)});
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      onGenerateRoute: RouteGenerator.getRoute,
      initialRoute: Routes.splashRoute,
      theme: getApplicationTheme(),
    );
  }
}
