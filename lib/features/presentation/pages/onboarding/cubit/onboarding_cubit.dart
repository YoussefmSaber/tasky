import 'package:bloc/bloc.dart';
import 'package:tasky/features/data/data_sources/shared_preference.dart';
import 'package:tasky/features/presentation/pages/onboarding/cubit/onboarding_states.dart';

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
