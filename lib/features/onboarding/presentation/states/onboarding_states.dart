/// Abstract class representing the different states of the onboarding process.
abstract class OnboardingStates {}

/// Initial state of the onboarding process.
class OnboardingInitialState extends OnboardingStates {}

/// State indicating that navigation is in progress.
class OnboardingNavigateLoading extends OnboardingStates {}

/// State indicating that navigation was successful.
class OnboardingNavigateSuccess extends OnboardingStates {}

/// State indicating that an error occurred during navigation.
class OnboardingNavigateError extends OnboardingStates {
  /// Error message describing the navigation error.
  final String message;

  /// Constructor for `OnboardingNavigateError` state.
  ///
  /// Takes a [message] parameter which describes the error.
  OnboardingNavigateError(this.message);
}