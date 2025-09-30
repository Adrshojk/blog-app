part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class Authenticated extends AuthState {
  final User user;
  Authenticated(this.user);
}

final class Unauthenticated extends AuthState {
  final String message;
  Unauthenticated(this.message);
}
