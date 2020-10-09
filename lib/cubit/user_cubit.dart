import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../domain/User.dart';
import '../services/UserRepository.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository _userRepository;
  UserCubit(this._userRepository) : super(UserInitial());
  Future<void> getUser(String userId) async {
    try {
      emit(UserLoading());
      final user = await _userRepository.getUserByUserId(userId);
      emit(UserLoaded(user));
    } on UserNotFoundException {
      emit(UserError("User not found"));
    }
  }

  void updateUser(User user) async {
    try {
      emit(UserSaving());
      final updatedUser = await _userRepository.updateUser(user);
      emit(UserLoaded(updatedUser));
    } catch (error) {
      emit(UserError(error.toString()));
    }
  }
}
