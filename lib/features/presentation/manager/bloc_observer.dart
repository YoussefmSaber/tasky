import 'package:bloc/bloc.dart';

/// A custom `BlocObserver` that logs the lifecycle events of Blocs.
class StateObserver extends BlocObserver {
  /// Called when a Bloc is created.
  ///
  /// Logs the creation of the Bloc.
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
  }

  /// Called when a Bloc's state changes.
  ///
  /// Logs the state change of the Bloc.
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
  }

  /// Called when a Bloc encounters an error.
  ///
  /// Logs the error encountered by the Bloc.
  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
  }

  /// Called when a Bloc is closed.
  ///
  /// Logs the closure of the Bloc.
  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
  }
}