import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/common/entities/user.dart';
import 'package:blog_app/features/auth/domain/use_cases/current_user.dart';
import 'package:blog_app/features/auth/domain/use_cases/user_log_in.dart';
import 'package:blog_app/features/auth/domain/use_cases/user_sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserLogIn _userLogIn;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;

  AuthBloc({
    required UserSignUp userSignUp,
    required UserLogIn userLogIn,
    required CurrentUser currentUser,
    required AppUserCubit appUserCubit,
  }) : _userLogIn = userLogIn,
       _userSignUp = userSignUp,
       _currentUser = currentUser,
       _appUserCubit = appUserCubit,
       super(AuthInitial()) {
    on<AuthEvent>((_, emit) => emit(AuthLoading()));
    on<AuthSignUpEvent>(_onAuthSignUpEvent);
    on<AuthLogInEvent>(_onAuthLogInEvent);
    on<AuthCheckEvent>(_onAuthCheckEvent);
  }

  void _onAuthCheckEvent(AuthCheckEvent event, Emitter<AuthState> emit) async {
    final res = await _currentUser(NoParams());
    res.fold(
      (failure) => emit(Unauthenticated(failure.message)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  void _onAuthLogInEvent(AuthLogInEvent event, Emitter<AuthState> emit) async {
    final res = await _userLogIn(
      LogInParams(email: event.email, password: event.password),
    );
    res.fold(
      (failure) => emit(Unauthenticated(failure.message)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  void _onAuthSignUpEvent(
    AuthSignUpEvent event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _userSignUp(
      SignUpParams(
        email: event.email,
        password: event.password,
        name: event.name,
      ),
    );
    res.fold(
      (failure) => emit(Unauthenticated(failure.message)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  void _emitAuthSuccess(User user, Emitter<AuthState> emit) {
    _appUserCubit.updateUser(user);
    emit(Authenticated(user));
  }
}
