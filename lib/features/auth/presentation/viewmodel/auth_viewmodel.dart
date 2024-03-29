import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entity/user_entity.dart';
import '../../domain/use_case/auth_usecase.dart';
import '../state/auth_state.dart';

final authViewModelProvider =
    StateNotifierProvider<AuthViewModel, AuthState>((ref) {
  return AuthViewModel(
    ref.read(authUseCaseProvider),
  );
});

class AuthViewModel extends StateNotifier<AuthState> {
  final AuthUseCase _authUseCase;

  AuthViewModel(this._authUseCase) : super(AuthState(isLoading: false));

  Future<void> uploadProfilePicture(File? file) async {
    state = state.copyWith(isLoading: true);
    var data = await _authUseCase.uploadProfilePicture(file!);
    data.fold(
      (l) => state = state.copyWith(isLoading: false, error: l.error),
      (imageName) {
        state =
            state.copyWith(isLoading: false, error: null, imageName: imageName);
      },
    );
  }

  Future<void> registerUser(BuildContext context, UserEntity user) async {
    state = state.copyWith(isLoading: true);
    var data = await _authUseCase.registerUser(user);
    data.fold((failure) {
      state = state.copyWith(isLoading: false, error: failure.error);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter valid information',
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'Brand Bold',
              color: Colors.red,
            ),
          ),
        ),
      );
    }, (success) {
      state = state.copyWith(
        isLoading: false,
        error: null,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Successfully registered',
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'Brand Bold',
              color: Colors.white,
            ),
          ),
        ),
      );
    });
  }

  Future<void> loginUser(
      BuildContext context, username, String password) async {
    state = state.copyWith(isLoading: true);
    var data = await _authUseCase.loginUser(username, password);
    data.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.error);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Invalid credentials',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Brand Bold',
                color: Colors.red,
              ),
            ),
          ),
        );
      },
      (success) {
        state = state.copyWith(isLoading: false, error: null);
        Navigator.pushNamed(context, '/bottomnav');
      },
    );
  }

  // Future<void> getUserInfo() async {
  //   state = state.copyWith(isLoading: true);

  //   var data = await _authUseCase.getUserInfo();

  //   data.fold(
  //     (left) => state = state.copyWith(isLoading: false, error: left.error),
  //     (right) =>
  //         state = state.copyWith(isLoading: false, user: right, error: null),
  //   );
  // }

  Future<void> logoutUser(BuildContext context) async {
    // final sharedPreferences = await SharedPreferences.getInstance();
    // bool? token = await sharedPreferences.setBool("isLogout", true);

    Navigator.pushNamedAndRemoveUntil(
        context, '/login', (Route<dynamic> route) => false);
  }
}
