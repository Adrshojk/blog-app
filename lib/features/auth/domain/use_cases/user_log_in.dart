import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/use_case/use_case.dart';
import 'package:blog_app/core/common/entities/user.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserLogIn implements UseCase<User, LogInParams> {
  final AuthRepository repository;
  const UserLogIn(this.repository);
  @override
  Future<Either<Failure, User>> call(LogInParams params) async {
    return await repository.loginWithEmail(
      email: params.email,
      password: params.password,
    );
  }
}

class LogInParams {
  final String email;
  final String password;

  LogInParams({required this.email, required this.password});
}
