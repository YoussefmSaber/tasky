import 'package:get_it/get_it.dart';
import 'package:tasky/features/auth/data/data_sources/auth_data_source.dart';
import 'package:tasky/core/network/dio_client.dart';
import 'package:tasky/core/storage/shared_preference.dart';
import 'package:tasky/features/auth/data/repositories/auth_repositories_impl.dart';
import 'package:tasky/features/task/data/repositories/todos_repositories_impl.dart';
import 'package:tasky/features/auth/domain/use_cases/login_use_case.dart';
import 'package:tasky/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:tasky/features/auth/presentation/cubit/login_cubit.dart';
import 'package:tasky/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:tasky/routes.dart';
import 'features/profile/domain/use_cases/user/profile_use_case.dart';
import 'features/task/data/data_sources/todos_data_source.dart';
import 'features/auth/domain/use_cases/register_use_case.dart';
import 'features/task/domain/usecases/get/get_task_use_case.dart';
import 'features/task/domain/usecases/get/get_tasks_use_case.dart';
import 'features/task/domain/usecases/post/add_task_use_case.dart';
import 'features/task/domain/usecases/post/delete_task_use_case.dart';
import 'features/task/domain/usecases/post/edit_task_use_case.dart';
import 'features/task/domain/usecases/post/logout_use_case.dart';
import 'features/task/domain/usecases/post/upload_image_use_case.dart';
import 'features/task/presentation/cubit/details_cubit.dart';
import 'features/task/presentation/cubit/edit_task_cubit.dart';
import 'features/task/presentation/cubit/home_cubit.dart';
import 'features/auth/presentation/cubit/register_cubit.dart';
import 'features/task/presentation/cubit/new_task_cubit.dart';
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
  getIt.registerLazySingleton<LoginUseCase>(() => LoginUseCase(getIt()));
  getIt.registerLazySingleton<RegisterUseCase>(() => RegisterUseCase(getIt()));

  getIt.registerLazySingleton<LogoutUseCase>(() => LogoutUseCase(getIt()));
  getIt.registerLazySingleton<ProfileUseCase>(() => ProfileUseCase(getIt()));

  // Tasks
  //   get
  getIt.registerLazySingleton<GetTasksUseCase>(() => GetTasksUseCase(getIt()));
  getIt.registerLazySingleton<GetTaskUseCase>(() => GetTaskUseCase(getIt()));

  //   post
  getIt.registerLazySingleton<AddTaskUseCase>(() => AddTaskUseCase(getIt()));
  getIt.registerLazySingleton<EditTaskUseCase>(() => EditTaskUseCase(getIt()));
  getIt.registerLazySingleton<UploadImageUseCase>(() => UploadImageUseCase(getIt()));
  getIt.registerLazySingleton<DeleteTaskUseCase>(() => DeleteTaskUseCase(getIt()));

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
      () => DetailsCubit(getIt(), getIt()));
  getIt.registerLazySingleton<NewTaskCubit>(
      () => NewTaskCubit(getIt(), getIt()));
  getIt.registerLazySingleton<EditTaskCubit>(
      () => EditTaskCubit(getIt(), getIt()));

  getIt.registerLazySingleton<OnboardingCubit>(() => OnboardingCubit(getIt()));

  getIt.registerSingleton<SharedPreferenceService>(sharedPrefService);
}