import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:my_app/components/bottom_nav.dart';
import 'package:my_app/components/signup/signup_bloc.dart';
import 'package:my_app/utils/custom_flash_message.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late SignupBloc signupBloc;

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController dobController = TextEditingController();
  bool autovalidate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Create an account',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: BlocProvider(
        create: (context) => SignupBloc(),
        child: BlocListener<SignupBloc, SignUpState>(
          listener: (context, state) {
            if (state is SignUpSuccess) {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => BottomNavBar()));
              CustomFlashMessage.showSuccessToast(
                  context, 'Account created Successfully!!');
            } else if (state is ErrorState) {
              CustomFlashMessage.showErrorToast(context, state.errorMessage);
            }
          },
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Colors.blue,
                Color.fromARGB(47, 196, 200, 214),
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Form(
                  key: _key,
                  autovalidateMode: autovalidate
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 100,
                      ),
                      BlocConsumer<SignupBloc, SignUpState>(
                        listener: (context, state) {},
                        builder: (context, state) {
                          signupBloc = BlocProvider.of<SignupBloc>(context);
                          final imagepath = signupBloc.imagepath;
                          return GestureDetector(
                            onTap: () {
                              // signupBloc.add(OnProfileClicked(imagepath: imagepath));
                              signupBloc
                                  .add(OnProfileClicked(imagepath: imagepath));
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
                                  : const Icon(Icons.person),
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          hintText: 'Enter your full name',
                          fillColor: Colors.transparent,
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: 'Enter your email address',
                          fillColor: Colors.transparent,
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your personal email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      BlocConsumer<SignupBloc, SignUpState>(
                        listener: (context, state) {},
                        builder: (context, state) {
                          signupBloc = BlocProvider.of<SignupBloc>(context);
                          final isShow = signupBloc.isShow;
                          return TextFormField(
                            obscureText: isShow ? false : true,
                            controller: passwordController,
                            decoration: InputDecoration(
                              suffixIcon: InkWell(
                                onTap: () {
                                  signupBloc
                                      .add(OnPasswordShow(isShow: !isShow));
                                },
                                child: isShow
                                    ? const Icon(Icons.visibility)
                                    : const Icon(Icons.visibility_off),
                              ),
                              hintText: 'Enter your own password',
                              fillColor: Colors.transparent,
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please create your password';
                              }
                              return null;
                            },
                          );
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () async {
                          DateTime? pickeddate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1947),
                              lastDate: DateTime.now());

                          if (pickeddate != null) {
                            setState(() {
                              dobController.text =
                                  DateFormat('yyyy-MM-dd').format(pickeddate);
                            });
                          }
                        },
                        child: IgnorePointer(
                          child: TextFormField(
                            controller: dobController,
                            decoration: InputDecoration(
                              hintText: 'Date-Of-Birth(dd/mm/yyyy)',
                              fillColor: Colors.transparent,
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your date of birth';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      BlocConsumer<SignupBloc, SignUpState>(
                        listener: (context, state) {},
                        builder: (context, state) {
                          signupBloc = BlocProvider.of<SignupBloc>(context);
                          final gender = signupBloc.gender;
                          return DropdownButtonFormField<String>(
                            hint: const Text('Gender'),
                            value: gender.isEmpty ? null : gender,
                            items: <String>[
                              'Male',
                              'Female',
                              'Prefer Not To Say',
                              'Other'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                signupBloc
                                    .add(OnGenderChanged(gender: newValue));
                              }
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select the gender';
                              }
                              return null;
                            },
                          );
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      BlocConsumer<SignupBloc, SignUpState>(
                          builder: (context, state) {
                            signupBloc = BlocProvider.of<SignupBloc>(context);
                            if (signupBloc.isLoadingPage) {
                              return const CircularProgressIndicator();
                            } else {
                              return Container();
                            }
                          },
                          listener: (context, state) {}),
                      BlocConsumer<SignupBloc, SignUpState>(
                        listener: (context, state) {},
                        builder: (context, state) {
                          signupBloc = BlocProvider.of<SignupBloc>(context);
                          return SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  autovalidate = true;
                                });
                                if (_key.currentState!.validate()) {
                                  signupBloc.add(
                                    OnSignUpButtonClicked(
                                        email: emailController.text,
                                        password: passwordController.text,
                                        name: nameController.text,
                                        imagepath: signupBloc.imagepath),
                                  );
                                }

                                // signupBloc.add(
                                //   OnSignUpButtonClicked(
                                //       email: emailController,
                                //       password: passwordController,
                                //       name: nameController.text),
                                // );
                              },
                              style: OutlinedButton.styleFrom(
                                backgroundColor: const Color(0xff000080),
                                side: const BorderSide(
                                  color: Colors.black,
                                  width: 1,
                                  style: BorderStyle.solid,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                              ),
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
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
          ),
        ),
      ),
    );
  }
}
