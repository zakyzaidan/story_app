import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:story_app/assets/database_services.dart';
import 'package:story_app/assets/image_utils.dart';
import 'package:story_app/home/model/story_model.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomeInitialEvent>(homeInitialEvent);
    on<UploadButtonClickedEvent>(uploadButtonClickedEvent);
    on<TakeImageFromGaleryClickedEvent>(takeImageFromGaleryClickedEvent);
    on<TakeImageFromCameraClickedEvent>(takeImageFromCameraClickedEvent);
  }

  FutureOr<void> uploadButtonClickedEvent(
      UploadButtonClickedEvent event, Emitter<HomeState> emit) {
    DatabaseServices databaseServices = DatabaseServices();
    try {
      databaseServices.uploadStory(event.storyModel);
      emit(UploadButtonClickedState());
    } catch (e) {
      print("---------------------");
    }
  }

  FutureOr<void> homeInitialEvent(
      HomeInitialEvent event, Emitter<HomeState> emit) {
    emit(HomeLoadingState());
    emit(HomeLoadedSuccessState());
  }

  FutureOr<void> takeImageFromGaleryClickedEvent(
      TakeImageFromGaleryClickedEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoadingState());
    Uint8List? img = await selectedImageFromGalery();
    try {
      emit(TakeImageFromGaleryClickedState(img: img));
    } catch (e) {
      print(e);
    }
  }

  FutureOr<void> takeImageFromCameraClickedEvent(
      TakeImageFromCameraClickedEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoadingState());
    Uint8List? img = await selectedImageFromCamera();
    try {
      emit(TakeImageFromGaleryClickedState(img: img));
    } catch (e) {
      print(e);
    }
  }
}
