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

  DeleteMystoryEvent({required this.email, required this.index});
}

final class EditMyStoryButtonClickedEvent extends ProfileEvent {
  final int index;
  final StoryModel storyModel;

  EditMyStoryButtonClickedEvent(
      {required this.index, required this.storyModel});
}
