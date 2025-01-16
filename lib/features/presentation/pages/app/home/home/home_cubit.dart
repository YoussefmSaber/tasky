import 'package:bloc/bloc.dart';
import 'package:tasky/features/data/data_sources/shared_preference.dart';
import 'package:tasky/features/domain/use_cases/task/get/get_tasks_use_case.dart';
import 'package:tasky/features/domain/use_cases/user/logout_use_case.dart';
import 'package:tasky/features/presentation/pages/app/home/home/home_state.dart';
import 'package:tasky/injection_container.dart';

/// Cubit for managing the state of the Home page.
class HomeCubit extends Cubit<HomeState> {
  /// Use case for getting tasks.
  final GetTasksUseCase tasksUseCase;

  /// Use case for logging out the user.
  final LogoutUseCase logoutUseCase;

  /// Constructor for initializing the HomeCubit with required use cases.
  HomeCubit({required this.tasksUseCase, required this.logoutUseCase})
      : super(HomeInitialState());

  /// Fetches the list of tasks and updates the state accordingly.
  Future<void> getTasks() async {
    try {
      emit(TasksLoadingState());
      final accessToken = getIt<SharedPreferenceService>().getAccessToken();
      final tasks = await tasksUseCase.getListOfTasks(accessToken!);
      emit(GetTasksSuccessState(tasks));
    } catch (e) {
      emit(GetTasksErrorState(e.toString()));
    }
  }

  /// Logs out the user and updates the state accordingly.
  ///
  /// \param accessToken The access token of the user.
  Future<void> logout() async {
    try {
      emit(LogoutLoadingState());
      final accessToken = getIt<SharedPreferenceService>().getAccessToken();
      final refresh = getIt<SharedPreferenceService>().getRefreshToken();
      print("$accessToken, $refresh");
      await getIt<SharedPreferenceService>().clearTokens();
      final response = await logoutUseCase.logout(refresh!, accessToken!);
      emit(LogoutSuccessState(response));
    } catch (e) {
      emit(LogoutErrorState(e.toString()));
    }
  }
}