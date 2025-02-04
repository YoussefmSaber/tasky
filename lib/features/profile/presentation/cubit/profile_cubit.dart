import 'package:bloc/bloc.dart';

import '../../domain/use_cases/user/profile_use_case.dart';
import '../states/profile_states.dart';

/// A Cubit that manages the state of the user profile.
class ProfileCubit extends Cubit<ProfileStates> {
  final ProfileUseCase profileUseCase;

  /// Creates a [ProfileCubit] with the given [ProfileUseCase].
  ProfileCubit(this.profileUseCase) : super(ProfileInitialState());

  /// Fetches the user profile and updates the state accordingly.
  Future<void> getProfile() async {
    try {
      emit(ProfileLoadingState());
      final res = await profileUseCase.getProfile();
      emit(GetProfileSuccessState(res));
    } catch (e) {
      emit(ErrorFetchingProfileState(e.toString()));
    }
  }
}