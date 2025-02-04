import 'package:bloc/bloc.dart';
import 'package:tasky/core/storage/shared_preference.dart';
import 'package:tasky/features/auth/domain/use_cases/register_use_case.dart';
import 'package:tasky/features/auth/presentation/states/register_state.dart';
import 'package:tasky/injection_container.dart';

import '../../domain/entities/user_register.dart';

/// Cubit responsible for handling the registration process.
class RegisterCubit extends Cubit<RegisterState> {
  final RegisterUseCase registerUseCase;

  /// Constructor for RegisterCubit.
  ///
  /// Takes a [RegisterUseCase] as a parameter.
  RegisterCubit(this.registerUseCase) : super(RegisterInitial());

  /// Registers a new user.
  ///
  /// Takes [UserRegister] as a required parameter.
  /// Emits [RegisterLoading], [RegisterSuccess], or [RegisterError] states.
  Future<void> register({
    required UserRegister userData,
  }) async {
    try {
      emit(RegisterLoading());
      final userTokens = await registerUseCase.register(userData);
      if (userTokens.refreshToken != null && userTokens.accessToken != null) {
        await getIt<SharedPreferenceService>()
            .saveAccessToken(userTokens.accessToken!);
        await getIt<SharedPreferenceService>()
            .saveRefreshToken(userTokens.refreshToken!);
        emit(RegisterSuccess(userTokens));
      } else {
        emit(RegisterError("Login failed"));
      }
    } catch (e) {
      emit(RegisterError("Login failed: ${e.toString()}"));
    }
  }
}