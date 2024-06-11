import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:story_app/main_screen.dart';

part 'login_register_event.dart';
part 'login_register_state.dart';

class LoginRegisterBloc extends Bloc<LoginRegisterEvent, LoginRegisterState> {
  LoginRegisterBloc() : super(LoginRegisterInitial()) {
    on<LoginRegisterInitialEvent>(loginRegisterInitialEvent);
    on<LoginButtonClickedEvent>(loginButtonClickedEvent);
    on<RegisterButtonClickedEvent>(registerButtonClickedEvent);
  }

  FutureOr<void> loginRegisterInitialEvent(
      LoginRegisterInitialEvent event, Emitter<LoginRegisterState> emit) {
    emit(LoginRegisterLoadingState());
    emit(LoginRegisterSuccessState());
  }

  FutureOr<void> loginButtonClickedEvent(
      LoginButtonClickedEvent event, Emitter<LoginRegisterState> emit) async {
    final auth = FirebaseAuth.instance;
    try {
      await auth.signInWithEmailAndPassword(
          email: event.email, password: event.password);
      Navigator.pushReplacement(event.context,
          MaterialPageRoute(builder: (context) {
        return const MainScreen(currIndex: 0);
      }));
    } catch (e) {
      SnackBar snackBar = SnackBar(content: Text("Failed login = $e"));
      ScaffoldMessenger.of(event.context).showSnackBar(snackBar);
      emit(LoginRegisterSuccessState());
    }
  }

  FutureOr<void> registerButtonClickedEvent(RegisterButtonClickedEvent event,
      Emitter<LoginRegisterState> emit) async {
    final auth = FirebaseAuth.instance;
    final _firestore = FirebaseFirestore.instance;
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: event.email, password: event.password);
      _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({'email': event.email, 'username': event.username, 'bio': ''});
      Navigator.of(event.context).pop();
      ScaffoldMessenger.of(event.context).showSnackBar(const SnackBar(
        content: Text("Success create account"),
        duration: Duration(seconds: 3),
      ));
    } catch (e) {
      SnackBar snackBar = SnackBar(
        content: Text("Failed create user = $e"),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(event.context).showSnackBar(snackBar);
    }
  }
}
