import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky/features/data/data_sources/shared_preference.dart';
import 'package:tasky/features/presentation/manager/bloc_observer.dart';
import 'package:tasky/features/presentation/pages/app/add_task/new_task/new_task_cubit.dart';
import 'package:tasky/features/presentation/pages/app/details/details/details_cubit.dart';
import 'package:tasky/features/presentation/pages/app/edit_task/cubit/edit_task_cubit.dart';
import 'package:tasky/features/presentation/pages/app/profile/profile/profile_cubit.dart';
import 'package:tasky/features/presentation/pages/auth/login/cubit/login_cubit.dart';
import 'package:tasky/features/presentation/pages/onboarding/cubit/onboarding_cubit.dart';
import 'package:tasky/injection_container.dart';
import 'package:tasky/routes.dart';

import 'features/presentation/pages/app/home/home/home_cubit.dart';
import 'features/presentation/pages/auth/register/cubit/register_cubit.dart';

/// The main entry point of the application.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final sharedPrefService = SharedPreferenceService(prefs);
  setup(sharedPrefService);
  final accessToken = sharedPrefService.getAccessToken();
  final isOnboardingCompleted = prefs.getBool('onboarding') ?? false;

  Bloc.observer = StateObserver();
  runApp(
      MyApp(token: accessToken, isOnboardingCompleted: isOnboardingCompleted));
}

/// The root widget of the application.
class MyApp extends StatelessWidget {
  final String? token;
  final bool isOnboardingCompleted;

  /// Constructs a [MyApp] widget.
  ///
  /// The [token] parameter is optional and can be null.
  const MyApp({super.key, this.token, required this.isOnboardingCompleted});

  /// Builds the widget tree for the application.
  ///
  /// This method sets up the [MultiBlocProvider] and [MaterialApp].
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<OnboardingCubit>()),
        BlocProvider(create: (context) => getIt<LoginCubit>()),
        BlocProvider(create: (context) => getIt<RegisterCubit>()),
        BlocProvider(create: (context) => getIt<HomeCubit>()),
        BlocProvider(create: (context) => getIt<NewTaskCubit>()),
        BlocProvider(create: (context) => getIt<DetailsCubit>()),
        BlocProvider(create: (context) => getIt<ProfileCubit>()),
        BlocProvider(create: (context) => getIt<EditTaskCubit>()),
      ],
      child: MaterialApp(
        initialRoute: getInitialRoute(token),
        navigatorKey: RouteGenerator.navigatorKey,
        onGenerateRoute: RouteGenerator.generateRoute,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
        ),
      ),
    );
  }

  /// Determines the initial route based on the presence of an access token.
  ///
  /// If the [token] is null, the initial route is set to the onboarding screen.
  /// Otherwise, it is set to the home screen.
  String getInitialRoute(String? token) {
    if (isOnboardingCompleted) {
      if (token == null || token.isEmpty) {
        return RouteGenerator.login;
      } else {
        return RouteGenerator.home;
      }
    } else {
      return RouteGenerator.onBoarding;
    }
  }
}
