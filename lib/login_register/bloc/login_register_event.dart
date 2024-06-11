part of 'login_register_bloc.dart';

@immutable
sealed class LoginRegisterEvent {}

final class LoginRegisterInitialEvent extends LoginRegisterEvent {}

final class LoginButtonClickedEvent extends LoginRegisterEvent {
  final String email;
  final String password;
  final BuildContext context;

  LoginButtonClickedEvent(
      {required this.email, required this.password, required this.context});
}

final class RegisterButtonClickedEvent extends LoginRegisterEvent {
  final String username;
  final String password;
  final String email;
  final BuildContext context;

  RegisterButtonClickedEvent(
      {required this.username,
      required this.password,
      required this.email,
      required this.context});
}
