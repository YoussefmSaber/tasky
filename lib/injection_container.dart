import 'package:get_it/get_it.dart';
import 'package:tasky/features/data/data_sources/auth/auth_data_source.dart';
import 'package:tasky/features/data/data_sources/dio_client.dart';
import 'package:tasky/features/data/data_sources/shared_preference.dart';
import 'package:tasky/features/data/repositories/auth_repositories_impl.dart';
import 'package:tasky/features/data/repositories/todos_repositories_impl.dart';
import 'package:tasky/features/domain/use_cases/auth/login_use_case.dart';
import 'package:tasky/features/domain/use_cases/task/post/add_task_use_case.dart';
import 'package:tasky/features/domain/use_cases/task/post/delete_task_use_case.dart';
import 'package:tasky/features/domain/use_cases/task/post/edit_task_use_case.dart';
import 'package:tasky/features/domain/use_cases/task/post/upload_image_use_case.dart';
import 'package:tasky/features/presentation/pages/app/profile/profile/profile_cubit.dart';
import 'package:tasky/features/presentation/pages/auth/login/cubit/login_cubit.dart';
import 'package:tasky/features/presentation/pages/onboarding/cubit/onboarding_cubit.dart';
import 'package:tasky/routes.dart';
import 'features/data/data_sources/todo/todos_data_source.dart';
import 'features/domain/use_cases/auth/register_use_case.dart';
import 'features/domain/use_cases/task/get/get_task_use_case.dart';
import 'features/domain/use_cases/task/get/get_tasks_use_case.dart';
import 'features/domain/use_cases/user/logout_use_case.dart';
import 'features/domain/use_cases/user/profile_use_case.dart';
import 'features/presentation/pages/app/add_task/new_task/new_task_cubit.dart';
import 'features/presentation/pages/app/details/details/details_cubit.dart';
import 'features/presentation/pages/app/home/home/home_cubit.dart';
import 'features/presentation/pages/auth/register/cubit/register_cubit.dart';

/// Singleton instance of GetIt for dependency injection
final getIt = GetIt.instance;

/// Sets up the dependency injection container with the provided [SharedPreferenceService].
///
/// Registers all the necessary services, data sources, repositories, use cases, and cubits.
///
/// \param sharedPrefService The shared preference service to be registered as a singleton.
void setup(SharedPreferenceService sharedPrefService) {
  // Dio Client
  getIt.registerLazySingleton<DioClient>(() => DioClient(
        getIt(),
         () {
          RouteGenerator.navigatorKey.currentState
              ?.pushNamedAndRemoveUntil(RouteGenerator.login, (route) => false);
        },
      ));

  // Data sources
  getIt.registerLazySingleton<AuthDataSource>(() => AuthDataSource(getIt()));
  getIt.registerLazySingleton<TodosDataSource>(() => TodosDataSource(getIt()));

  // Repositories
  getIt.registerLazySingleton<AuthRepositoryImpl>(
      () => AuthRepositoryImpl(getIt()));
  getIt.registerLazySingleton<TasksRepositoriesImpl>(
      () => TasksRepositoriesImpl(getIt()));

  // Use cases
  // User
  getIt.registerLazySingleton(() => LoginUseCase(getIt()));
  getIt.registerLazySingleton(() => RegisterUseCase(getIt()));

  getIt.registerLazySingleton(() => LogoutUseCase(getIt()));
  getIt.registerLazySingleton(() => ProfileUseCase(getIt()));

  // Tasks
  //   get
  getIt.registerLazySingleton(() => GetTasksUseCase(getIt()));
  getIt.registerLazySingleton(() => GetTaskUseCase(getIt()));

  //   post
  getIt.registerLazySingleton(() => AddTaskUseCase(getIt()));
  getIt.registerLazySingleton(() => EditTaskUseCase(getIt()));
  getIt.registerLazySingleton(() => UploadImageUseCase(getIt()));
  getIt.registerLazySingleton(() => DeleteTaskUseCase(getIt()));

  // ----
  // Cubit
  // Auth
  getIt.registerLazySingleton<LoginCubit>(() => LoginCubit(getIt()));
  getIt.registerLazySingleton<RegisterCubit>(() => RegisterCubit(getIt()));
  getIt.registerLazySingleton<ProfileCubit>(() => ProfileCubit(getIt()));

  // App Cubit
  getIt.registerLazySingleton<HomeCubit>(() => HomeCubit(
      tasksUseCase: getIt(),
      logoutUseCase: getIt(),
      deleteTaskUseCase: getIt()));
  getIt.registerLazySingleton<DetailsCubit>(
      () => DetailsCubit(getIt(), getIt(), getIt()));
  getIt.registerLazySingleton<NewTaskCubit>(
      () => NewTaskCubit(getIt(), getIt(), getIt()));

  getIt.registerLazySingleton<OnboardingCubit>(() => OnboardingCubit(getIt()));

  getIt.registerSingleton<SharedPreferenceService>(sharedPrefService);
}
