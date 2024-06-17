import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/components/bottom_nav.dart';
import 'package:my_app/components/signin/signin_bloc.dart';

class SignInPage extends StatelessWidget {
  late SigninBloc signinBloc;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocProvider(
        create: (context) => SigninBloc()..add(InitialSignIn()),
        child: BlocConsumer<SigninBloc, SignInState>(
          listener: (context, state) {
            if (state is SignSuccessState) {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => BottomNavBar()));
            }
          },
          builder: (context, state) {
            signinBloc = BlocProvider.of<SigninBloc>(context);
            return Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
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
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        signinBloc.add(
                          OnSignButtonClicked(
                              email: emailController,
                              password: passwordController),
                        );
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
                        'Sign In',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
