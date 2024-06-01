
import 'package:flutter/material.dart';
import 'package:mia/screens/splash_screen.dart';
import 'constants/string_constants.dart';

class Router {
  Router();

  Route<dynamic>? routes(RouteSettings settings) {
    switch (settings.name) {
      case StringConstants.SPLASH_PAGE:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
          settings: settings,
        );
    }
  }
}
