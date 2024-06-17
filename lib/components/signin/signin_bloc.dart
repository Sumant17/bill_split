import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

//events
abstract class SignInEvent {}

class InitialSignIn extends SignInEvent {}

class OnSignButtonClicked extends SignInEvent {
  final TextEditingController email;
  final TextEditingController password;

  OnSignButtonClicked({required this.email, required this.password});
}

//states
abstract class SignInState {}

class InitialLoadSignIn extends SignInState {}

class SignSuccessState extends SignInState {}

class LoadingSignInState extends SignInState {}

//bloc
class SigninBloc extends Bloc<SignInEvent, SignInState> {
  SigninBloc() : super(LoadingSignInState()) {
    on<InitialSignIn>((event, emit) {
      emit(InitialLoadSignIn());
    });

    on<OnSignButtonClicked>((event, emit) async {
      emit(InitialLoadSignIn());
      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: event.email.text, password: event.password.text);
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isUserLoggedIn', true);
        emit(SignSuccessState());
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email');
        } else if (e.code == 'wrong=password') {
          print('Wrong password provided for that user.');
        }
      }
    });
  }
}
