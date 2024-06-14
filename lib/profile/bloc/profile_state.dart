part of 'profile_bloc.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileLoadingState extends ProfileState {}

final class ProfileLoadedSuccessState extends ProfileState {
  final UserModel user;

  ProfileLoadedSuccessState({required this.user});
}

final class ProfileActionState extends ProfileState {}

final class ProfileUpdateProfileButtonClickedState extends ProfileActionState {}

final class EditMyStoryButtonClickedState extends ProfileActionState {}

final class TakeImageClickedState extends ProfileState {
  final Uint8List? img;

  TakeImageClickedState({required this.img});
}
