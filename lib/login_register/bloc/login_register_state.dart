part of 'login_register_bloc.dart';

@immutable
sealed class LoginRegisterState {}

final class LoginRegisterInitial extends LoginRegisterState {}

final class LoginRegisterLoadingState extends LoginRegisterState {}

final class LoginRegisterSuccessState extends LoginRegisterState {}
