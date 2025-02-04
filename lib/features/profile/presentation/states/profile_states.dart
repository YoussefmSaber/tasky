import '../../domain/entities/user/user_data.dart';

/// Abstract class representing the different states of the profile.
abstract class ProfileStates {}

/// State representing the initial state of the profile.
class ProfileInitialState extends ProfileStates {}

/// State representing the loading state of the profile.
class ProfileLoadingState extends ProfileStates {}

/// State representing the successful retrieval of the profile.
class GetProfileSuccessState extends ProfileStates {
  /// The user data retrieved.
  final UserData userData;

  /// Constructor for the success state.
  GetProfileSuccessState(this.userData);
}

/// State representing an error while fetching the profile.
class ErrorFetchingProfileState extends ProfileStates {
  /// The error message.
  final String message;

  /// Constructor for the error state.
  ErrorFetchingProfileState(this.message);
}