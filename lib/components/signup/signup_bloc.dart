//events

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/models/my_user_model.dart';
import 'package:my_app/utils/firebase_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SignUpEvent {}

class OnProfileClicked extends SignUpEvent {
  final String imagepath;
  OnProfileClicked({required this.imagepath});
}

class OnGenderChanged extends SignUpEvent {
  final String gender;
  OnGenderChanged({required this.gender});
}

class OnSignUpButtonClicked extends SignUpEvent {
  final String email;
  final String password;
  final String name;
  final String imagepath;
  OnSignUpButtonClicked(
      {required this.email,
      required this.password,
      required this.name,
      required this.imagepath});
}

//states
abstract class SignUpState {}

class SignUpInitial extends SignUpState {}

class ProfileShow extends SignUpState {
  final String imagepath;
  ProfileShow({required this.imagepath});
}

class GenderShow extends SignUpState {
  final String gender;
  GenderShow({required this.gender});
}

class SignUpSuccess extends SignUpState {
  final String imagepath;
  final String name;
  SignUpSuccess({required this.imagepath, required this.name});
}

//bloc
class SignupBloc extends Bloc<SignUpEvent, SignUpState> {
  late String _imagepath = '';
  late String _gender = '';

  SignupBloc() : super(SignUpInitial()) {
    on<OnProfileClicked>((event, emit) async {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        _imagepath = pickedFile.path;
        emit(ProfileShow(imagepath: pickedFile.path));
        bool success = await FirebaseUtils.uploadFileForUser(pickedFile);
        print(success);
      }
    });

    on<OnGenderChanged>((event, emit) {
      _gender = event.gender;
      emit(GenderShow(gender: event.gender));
    });

    on<OnSignUpButtonClicked>((event, emit) async {
      try {
        final credential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: event.email, password: event.password);
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isUserLoggedIn', true);

        await prefs.setString('myName', event.name);
        await prefs.setString('myimagepath', event.imagepath);

        print('Signed up successfully with userid : ${credential.user?.uid}');
        final user = MyUserModel(name: event.name, email: event.email);
        await FirebaseUtils.uploaduserdetails(user);

        emit(SignUpSuccess(imagepath: event.imagepath, name: event.name));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
        }
        throw Exception(e);
      }
    });
  }
  //getters
  String get imagepath => _imagepath;
  String get gender => _gender;

  // @override
  // SignUpState? fromJson(Map<String, dynamic> json) {
  //   try {
  //     if (json.containsKey('imagepath')) {
  //       return ProfileShow(imagepath: json['imagepath'] as String);
  //     } else if (json.containsKey('gender')) {
  //       return GenderShow(gender: json['gender'] as String);
  //     } else if (json.containsKey('name')) {
  //       return SignUpSuccess(
  //         imagepath: json['imagepath'] as String,
  //         name: json['name'] as String,
  //       );
  //     }
  //   } catch (e) {
  //     print('Error parsing JSON: $e');
  //   }

  //   throw UnimplementedError();
  // }

  // @override
  // Map<String, dynamic>? toJson(SignUpState state) {
  //   if (state is ProfileShow) {
  //     return {'imagepath': state.imagepath};
  //   } else if (state is GenderShow) {
  //     return {'gender': state.gender};
  //   } else if (state is SignUpSuccess) {
  //     return {'imagepath': state.imagepath, 'name': state.name};
  //   }

  //   throw UnimplementedError();
  // }
}
