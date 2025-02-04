import 'package:bloc/bloc.dart';
import 'package:tasky/core/storage/shared_preference.dart';
import 'package:tasky/features/auth/domain/use_cases/login_use_case.dart';
import 'package:tasky/features/auth/presentation/states/login_states.dart';
import 'package:tasky/injection_container.dart';

/// A Cubit that manages the login state.
class LoginCubit extends Cubit<LoginState> {
  /// The use case for logging in.
  final LoginUseCase loginUseCase;

  /// Creates a new instance of [LoginCubit].
  ///
  /// Takes a [LoginUseCase] as a parameter.
  LoginCubit(this.loginUseCase) : super(LoginInitial());

  Future<void> initial() async {
    emit(LoginInitial());
  }

  /// Logs in a user with the provided [phone] and [password].
  ///
  /// Emits [LoginLoading] while the login is in progress.
  /// If the login is successful, emits [LoginSuccess] with the user tokens.
  /// If the login fails, emits [LoginError] with an error message.
  Future<void> login({required String phone, required String password}) async {
    try {
      emit(LoginLoading());
      final userTokens = await loginUseCase.login(phone, password);
      if (userTokens != null && userTokens.accessToken != null) {
        await getIt<SharedPreferenceService>()
            .saveAccessToken(userTokens.accessToken!);
        await getIt<SharedPreferenceService>()
            .saveRefreshToken(userTokens.refreshToken!);
        emit(LoginSuccess(userTokens));
      } else {
        emit(LoginError("Login failed"));
      }
    } catch (e) {
      emit(LoginError(e.toString()));
    }
  }
}
