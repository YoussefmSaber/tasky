import 'package:bloc/bloc.dart';
import 'package:tasky/core/storage/shared_preference.dart';
import 'package:tasky/features/onboarding/presentation/states/onboarding_states.dart';

/// Cubit responsible for managing the onboarding state.
class OnboardingCubit extends Cubit<OnboardingStates> {
  final SharedPreferenceService sharedPreferenceService;

  /// Constructor for OnboardingCubit.
  ///
  /// Takes a [SharedPreferenceService] as a parameter.
  OnboardingCubit(this.sharedPreferenceService)
      : super(OnboardingInitialState());

  /// Skips the onboarding process.
  ///
  /// Emits [OnboardingNavigateLoading], then saves the onboarding state using
  /// [sharedPreferenceService.saveOnboardingState], and finally emits
  /// [OnboardingNavigateSuccess]. If an error occurs, emits [OnboardingNavigateError].
  Future<void> skipOnboarding() async {
    try {
      emit(OnboardingNavigateLoading());
      await sharedPreferenceService.saveOnboardingState();
      emit(OnboardingNavigateSuccess());
    } catch (e) {
      emit(OnboardingNavigateError(e.toString()));
    }
  }
}