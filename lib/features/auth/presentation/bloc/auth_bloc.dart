import 'package:blog_app/features/auth/domain/use_cases/user_sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  AuthBloc({required UserSignUp userSignUp})
    : _userSignUp = userSignUp,
      super(AuthInitial()) {
    on<AuthSignUpEvent>((event, emit) async {
      final res = await _userSignUp(
        SignUpParams(
          email: event.email,
          password: event.password,
          name: event.name,
        ),
      );
      res.fold(
        (failure) => emit(Unauthenticated(failure.message)),
        (uid) => emit(Authenticated(uid)),
      );
    });
  }
}
