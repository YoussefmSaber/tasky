import 'package:flutter/material.dart';
import 'package:tasky/features/onboarding/presentation/page/onboard_page.dart';

import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/register_page.dart';
import 'features/profile/presentation/page/profile_page.dart';
import 'features/task/domain/entities/task/task_data.dart';
import 'features/task/presentation/pages/details_page.dart';
import 'features/task/presentation/pages/edit_task_page.dart';
import 'features/task/presentation/pages/home_page.dart';
import 'features/task/presentation/pages/new_task_page.dart';
import 'features/task/presentation/pages/qr_scanner_page.dart';

/// A class that generates routes for the application.
class RouteGenerator {
  /// Route for the onboarding page.
  static const onBoarding = '/';

  /// Route for the login page.
  static const login = '/login';

  /// Route for the registration page.
  static const register = '/register';

  /// Route for the home page.
  static const home = '/home';

  /// Route for the profile page.
  static const profile = '/profile';

  /// Route for the details page.
  static const details = '/details';

  /// Route for the add item page.
  static const addItem = '/addItem';

  /// Route for the edit task page.
  static const editTask = '/editTask';

  /// Route for the QR scanner page.
  static const qrScanner = '/qrScanner';

  /// Global key for the navigator state.
  static final navigatorKey = GlobalKey<NavigatorState>();

  /// Private constructor to prevent instantiation.
  RouteGenerator._();

  /// Generates a route based on the given [RouteSettings].
  ///
  /// Throws a [FormatException] if the route is not found.
  ///
  /// \param settings The settings for the route.
  /// \return A [Route] object for the specified route.
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case onBoarding:
        return MaterialPageRoute(builder: (_) => const OnboardPage());
      case login:
        final resetCubitState = settings.arguments as VoidCallback?;
        resetCubitState?.call();
        return MaterialPageRoute(builder: (_) => LoginPage());
      case register:
        return MaterialPageRoute(builder: (_) => RegisterPage());
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      case details:
        final taskId = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => DetailsPage(taskId: taskId));
      case addItem:
        return MaterialPageRoute(builder: (_) => const NewTaskPage());
      case editTask:
        final task = settings.arguments as TaskData;
        return MaterialPageRoute(builder: (_) => EditTaskPage(task: task));
      case qrScanner:
        return MaterialPageRoute(builder: (_) => const QRScannerPage());
      default:
        throw FormatException("Route not found");
    }
  }
}

/// An exception that is thrown when a route is not found.
class RouteException implements Exception {
  /// The message describing the exception.
  final String message;

  /// Creates a [RouteException] with the given [message].
  const RouteException(this.message);
}