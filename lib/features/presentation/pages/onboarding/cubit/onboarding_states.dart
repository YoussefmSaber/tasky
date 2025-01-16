abstract class OnboardingStates {}

class OnboardingInitialState extends OnboardingStates {}

class OnboardingNavigateLoading extends OnboardingStates {}

class OnboardingNavigateSuccess extends OnboardingStates {}

class OnboardingNavigateError extends OnboardingStates {
  final String message;
  OnboardingNavigateError(this.message);
}
