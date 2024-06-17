//events
// import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthEvent {}

class OnInitialAuth extends AuthEvent {}

class OnSignInClicked extends AuthEvent {}

class OnSignUpClicked extends AuthEvent {}

class OnAuthMethodchanged extends AuthEvent {
  final bool isSignIn;
  OnAuthMethodchanged({required this.isSignIn});
}

class OnGoogleAuthClicked extends AuthEvent {}

//states
abstract class AuthState {}

class InitialLoad extends AuthState {
  final bool isSignIn;
  InitialLoad({required this.isSignIn});

  // Map<String, dynamic> toJson() {
  //   return {'isSignIn': isSignIn};
  // }

  // static InitialLoad fromJson(Map<String, dynamic> json) {
  //   return InitialLoad(isSignIn: json['isSignIn'] as bool);
  // }
}

class LoadingState extends AuthState {}

class SignInState extends AuthState {}

class SignUpState extends AuthState {}

class SkipAuth extends AuthState {}

class GoogleState extends AuthState {}

//bloc
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(LoadingState()) {
    on<OnInitialAuth>((event, emit) async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final isUserLoggedIn = prefs.getBool('isUserLoggedIn') ?? false;
      if (isUserLoggedIn) {
        emit(SkipAuth());
        return;
      }
      emit(InitialLoad(isSignIn: false));
    });

    on<OnAuthMethodchanged>((event, emit) {
      final method = event.isSignIn;
      emit(InitialLoad(isSignIn: method));
    });

    on<OnSignInClicked>((event, emit) {
      emit(SignInState());
    });

    on<OnSignUpClicked>((event, emit) {
      print('sign-up clicked');
      emit(SignUpState());
    });
  }

  // @override
  // AuthState fromJson(Map<String, dynamic> json) {
  //   try {
  //     if (json['isSignIn'] != null) {
  //       return InitialLoad.fromJson(json);
  //     }
  //   } catch (e) {
  //     return InitialLoad(isSignIn: false);
  //   }
  //   return InitialLoad(isSignIn: false);
  // }

  // @override
  // Map<String, dynamic> toJson(AuthState state) {
  //   if (state is InitialLoad) {
  //     return state.toJson();
  //   }
  //   return {};
  // }
}
