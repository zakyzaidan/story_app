part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

final class HomeInitialEvent extends HomeEvent {}

final class UploadButtonClickedEvent extends HomeEvent {
  final StoryModel storyModel;

  UploadButtonClickedEvent({required this.storyModel});
}
