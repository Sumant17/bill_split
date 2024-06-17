import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:my_app/components/bottom_nav.dart';
import 'package:my_app/components/signup/signup_bloc.dart';

class SignUpPage extends StatelessWidget {
  late SignupBloc signupBloc;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController dobController = TextEditingController();

  SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocListener<SignupBloc, SignUpState>(
        listener: (context, state) {
          if (state is SignUpSuccess) {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => BottomNavBar()));
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 30,
                ),
                BlocConsumer<SignupBloc, SignUpState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    signupBloc = BlocProvider.of<SignupBloc>(context);
                    final imagepath = signupBloc.imagepath;
                    return GestureDetector(
                      onTap: () {
                        // signupBloc.add(OnProfileClicked(imagepath: imagepath));
                        signupBloc.add(OnProfileClicked(imagepath: imagepath));
                      },
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: imagepath.isNotEmpty
                            ? FileImage(
                                File(imagepath),
                              )
                            : null,
                        child: imagepath.isNotEmpty
                            ? null
                            : const Icon(Icons.camera_alt),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    hintText: 'Full Name',
                    fillColor: Colors.white,
                    filled: true,
                    focusedBorder: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                    fillColor: Colors.white,
                    filled: true,
                    focusedBorder: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: const InputDecoration(
                    hintText: 'Password',
                    fillColor: Colors.white,
                    filled: true,
                    focusedBorder: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: dobController,
                  decoration: const InputDecoration(
                    hintText: 'Date-of-birth(dd/mm/yyyy)',
                    fillColor: Colors.white,
                    filled: true,
                    focusedBorder: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                BlocConsumer<SignupBloc, SignUpState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    signupBloc = BlocProvider.of<SignupBloc>(context);
                    final gender = signupBloc.gender;
                    return DropdownButton<String>(
                        hint: const Text('Gender'),
                        value: gender.isEmpty ? null : gender,
                        items: <String>['Male', 'Female', 'Other']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            signupBloc.add(OnGenderChanged(gender: newValue));
                          }
                        });
                  },
                ),
                BlocConsumer<SignupBloc, SignUpState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    signupBloc = BlocProvider.of<SignupBloc>(context);
                    return SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          signupBloc.add(OnSignUpButtonClicked(
                              email: emailController.text,
                              password: passwordController.text,
                              name: nameController.text,
                              imagepath: signupBloc.imagepath));
                          // signupBloc.add(
                          //   OnSignUpButtonClicked(
                          //       email: emailController,
                          //       password: passwordController,
                          //       name: nameController.text),
                          // );
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.black,
                          side: const BorderSide(
                            color: Colors.black,
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2),
                          ),
                          padding: const EdgeInsets.only(left: 10, right: 10),
                        ),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
