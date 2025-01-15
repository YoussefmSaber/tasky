import 'package:flutter/material.dart';
import 'package:tasky/features/presentation/pages/app/app_pages.dart';
import 'package:tasky/features/presentation/pages/auth/auth_pages.dart';
import 'package:tasky/features/presentation/pages/onboarding/onboard_page.dart';

/// A class that generates routes for the application.
class RouteGenerator {
  static const onBoarding = '/';
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const profile = '/profile';
  static const details = '/details';
  static const addItem = '/addItem';

  /// Private constructor to prevent instantiation.
  RouteGenerator._();

  /// Generates a route based on the given [RouteSettings].
  ///
  /// Throws a [FormatException] if the route is not found.
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case onBoarding:
        return MaterialPageRoute(builder: (_) => const OnboardPage());
      case login:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case register:
        return MaterialPageRoute(builder: (_) => RegisterPage());
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      case details:
        return MaterialPageRoute(builder: (_) => const DetailsPage());
      case addItem:
        return MaterialPageRoute(builder: (_) => const NewItemPage());
      default:
        throw FormatException("Route not found");
    }
  }
}

/// An exception that is thrown when a route is not found.
class RouteException implements Exception {
  final String message;

  /// Creates a [RouteException] with the given [message].
  const RouteException(this.message);
}