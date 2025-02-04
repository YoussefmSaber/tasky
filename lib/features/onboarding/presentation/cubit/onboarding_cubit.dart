import 'package:bloc/bloc.dart';
import 'package:tasky/core/storage/shared_preference.dart';
import 'package:tasky/features/onboarding/presentation/states/onboarding_states.dart';

class OnboardingCubit extends Cubit<OnboardingStates> {
  final SharedPreferenceService sharedPreferenceService;

  OnboardingCubit(this.sharedPreferenceService)
      : super(OnboardingInitialState());

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
