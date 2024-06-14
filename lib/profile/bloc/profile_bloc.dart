import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:story_app/assets/database_services.dart';
import 'package:story_app/assets/image_utils.dart';
import 'package:story_app/home/model/story_model.dart';
import 'package:story_app/profile/model/user_model.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<ProfileInitialEvent>(profileInitialEvent);
    on<ProfileEditButtonClickedEvent>(profileEditButtonClickedEvent);
    on<DeleteMystoryEvent>(deleteMystoryEvent);
    on<EditMyStoryButtonClickedEvent>(editMyStoryButtonClickedEvent);
    on<TakeImageFromCameraClickedEvent>(takeImageFromCameraClickedEvent);
    on<TakeImageFromGaleryClickedEvent>(takeImageFromGaleryClickedEvent);
  }

  FutureOr<void> profileInitialEvent(
      ProfileInitialEvent event, Emitter<ProfileState> emit) async {
    DatabaseServices databaseServices = DatabaseServices();
    emit(ProfileLoadingState());
    UserModel user = await databaseServices.getUser();
    emit(ProfileLoadedSuccessState(user: user));
  }

  FutureOr<void> profileEditButtonClickedEvent(
      ProfileEditButtonClickedEvent event, Emitter<ProfileState> emit) async {
    DatabaseServices databaseServices = DatabaseServices();
    UserModel user = await databaseServices.getUser();
    emit(ProfileLoadingState());
    try {
      databaseServices.editProfile(event.username, event.bio, user.email);
      emit(ProfileUpdateProfileButtonClickedState());
    } catch (e) {
      print("something got wrong");
    }
  }

  FutureOr<void> deleteMystoryEvent(
      DeleteMystoryEvent event, Emitter<ProfileState> emit) async {
    DatabaseServices databaseServices = DatabaseServices();
    try {
      if (event.imgName != "") {
        deleteImageFromStorage(event.imgName);
      }
      databaseServices.deleteMyStory(event.email, event.index);
    } catch (e) {
      print("-----------------gagal delete-------------------");
    }
  }

  FutureOr<void> editMyStoryButtonClickedEvent(
      EditMyStoryButtonClickedEvent event, Emitter<ProfileState> emit) {
    DatabaseServices databaseServices = DatabaseServices();
    try {
      databaseServices.editMyStory(event.storyModel.email, event.index,
          event.storyModel.story, event.storyModel.imgUrl);
      emit(EditMyStoryButtonClickedState());
    } catch (e) {
      print("---------------------");
    }
  }

  FutureOr<void> takeImageFromCameraClickedEvent(
      TakeImageFromCameraClickedEvent event, Emitter<ProfileState> emit) async {
    Uint8List? img = await selectedImageFromCamera();
    try {
      emit(TakeImageClickedState(img: img));
    } catch (e) {
      print(e);
    }
  }

  FutureOr<void> takeImageFromGaleryClickedEvent(
      TakeImageFromGaleryClickedEvent event, Emitter<ProfileState> emit) async {
    Uint8List? img = await selectedImageFromGalery();
    try {
      emit(TakeImageClickedState(img: img));
    } catch (e) {
      print(e);
    }
  }
}
