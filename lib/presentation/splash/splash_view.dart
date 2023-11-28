import 'dart:async';

import 'package:complete_advanced_flutter/app/app_preferences.dart';
import 'package:complete_advanced_flutter/app/dependency_injection.dart';
import 'package:flutter/material.dart';

import '../resources/assets_manager.dart';
import '../resources/color_manager.dart';
import '../resources/routes_manager.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final AppPreferences _appPreferences = instance<AppPreferences>();
  Timer? _timer;

  _startDelay() {
    _timer = Timer(Duration(seconds: 2), _goNext);
  }

  _goNext() async {
    _appPreferences.isUserLoggedIn().then((isUserLoggedIn) => {
          if (isUserLoggedIn)
            Navigator.pushReplacementNamed(context, Routes.mainRoute)
          else
            _appPreferences
                .isOnboardingScreenViewed()
                .then((isOnBoardingScreenViewed) => {
                      if (isOnBoardingScreenViewed)
                        Navigator.pushReplacementNamed(
                          context,
                          Routes.loginRoute,
                        )
                      else
                        Navigator.pushReplacementNamed(
                          context,
                          Routes.onboardingRoute,
                        )
                    })
        });
  }

  @override
  void initState() {
    super.initState();
    _startDelay();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primary,
      body: const Center(
        child: Image(
          image: AssetImage(ImageAssets.splashLogo),
        ),
      ),
    );
  }
}
