
import 'package:flutter/material.dart';
import 'package:mia/screens/home_screen.dart';
import 'package:mia/screens/interview_screen.dart';
import 'package:mia/screens/loading_screen.dart';
import 'package:mia/screens/splash_screen.dart';
import 'package:mia/screens/thank_you_screen.dart';
import 'constants/string_constants.dart';

class Router {
  Router();

  Route<dynamic>? routes(RouteSettings settings) {
    switch (settings.name) {
      case StringConstants.SPLASH_SCREEN:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
          settings: settings,
        );
      case StringConstants.HOME_SCREEN:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
          settings: settings,
        );
      case StringConstants.LOADING_SCREEN:
        return MaterialPageRoute(
          builder: (_) => const LoadingScreen(),
          settings: settings,
        );
      case StringConstants.INTERVIEW_SCREEN:
        return MaterialPageRoute(
          builder: (_) => const InterviewScreen(),
          settings: settings,
        );
      case StringConstants.THANK_YOU_SCREEN:
        return MaterialPageRoute(
          builder: (_) => const ThankYouScreen(),
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
