import 'package:tasky/features/auth/domain/entities/login_response.dart';

/// Abstract class representing the state of the login process.
abstract class LoginState {}

/// State representing the initial state of the login process.
class LoginInitial extends LoginState {}

/// State representing the loading state of the login process.
class LoginLoading extends LoginState {}

/// State representing the success state of the login process.
class LoginSuccess extends LoginState {
  /// The user information returned upon successful login.
  final LoginResponse user;

  /// Constructor for the success state.
  ///
  /// Takes a [LoginResponse] object as a parameter.
  LoginSuccess(this.user);
}

/// State representing the error state of the login process.
class LoginError extends LoginState {
  /// The error message returned upon failed login.
  final String message;

  /// Constructor for the error state.
  ///
  /// Takes a [String] message as a parameter.
  LoginError(this.message);
}