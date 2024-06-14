part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent {}

final class ProfileEditButtonClickedEvent extends ProfileEvent {
  final String username;
  final String bio;

  ProfileEditButtonClickedEvent({required this.username, required this.bio});
}

final class ProfileInitialEvent extends ProfileEvent {}

final class DeleteMystoryEvent extends ProfileEvent {
  final String email;
  final int index;
  final String imgName;

  DeleteMystoryEvent(
      {required this.email, required this.index, required this.imgName});
}

final class EditMyStoryButtonClickedEvent extends ProfileEvent {
  final int index;
  final StoryModel storyModel;

  EditMyStoryButtonClickedEvent(
      {required this.index, required this.storyModel});
}

final class TakeImageFromCameraClickedEvent extends ProfileEvent {}

final class TakeImageFromGaleryClickedEvent extends ProfileEvent {}
