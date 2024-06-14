part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeActionState extends HomeState {}

final class UploadButtonClickedState extends HomeActionState {}

final class HomeLoadingState extends HomeState {}

final class HomeLoadedSuccessState extends HomeState {}

final class TakeImageFromGaleryClickedState extends HomeState {
  final Uint8List? img;

  TakeImageFromGaleryClickedState({required this.img});
}
