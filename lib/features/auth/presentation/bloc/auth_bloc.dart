import 'package:blog_app/features/auth/domain/entities/user.dart';
import 'package:blog_app/features/auth/domain/use_cases/user_log_in.dart';
import 'package:blog_app/features/auth/domain/use_cases/user_sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserLogIn _userLogIn;

  AuthBloc({required UserSignUp userSignUp, required UserLogIn userLogIn})
    : _userLogIn = userLogIn,
      _userSignUp = userSignUp,
      super(AuthInitial()) {
    on<AuthSignUpEvent>(_onAuthSignUpEvent);
    on<AuthLogInEvent>(_onAuthLogInEvent);
  }

  void _onAuthLogInEvent(AuthLogInEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _userLogIn(
      LogInParams(email: event.email, password: event.password),
    );
    res.fold(
      (failure) => emit(Unauthenticated(failure.message)),
      (user) => emit(Authenticated(user)),
    );
  }

  void _onAuthSignUpEvent(
    AuthSignUpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final res = await _userSignUp(
      SignUpParams(
        email: event.email,
        password: event.password,
        name: event.name,
      ),
    );
    res.fold(
      (failure) => emit(Unauthenticated(failure.message)),
      (user) => emit(Authenticated(user)),
    );
  }
}
