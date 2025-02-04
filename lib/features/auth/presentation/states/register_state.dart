import '../../domain/entities/register_response.dart';

/// Abstract class representing the state of the registration process.
abstract class RegisterState {}

/// State representing the initial state of the registration process.
class RegisterInitial extends RegisterState {}

/// State representing the loading state of the registration process.
class RegisterLoading extends RegisterState {}

/// State representing the successful registration.
class RegisterSuccess extends RegisterState {
  /// The user information returned upon successful registration.
  final RegisterResponse user;

  /// Constructor for [RegisterSuccess] state.
  RegisterSuccess(this.user);
}

/// State representing an error during the registration process.
class RegisterError extends RegisterState {
  /// The error message describing the failure.
  final String message;

  /// Constructor for [RegisterError] state.
  RegisterError(this.message);
}