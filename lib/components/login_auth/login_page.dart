import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/components/bottom_nav.dart';
import 'package:my_app/components/login_auth/login_page_bloc.dart';
import 'package:my_app/components/signin/signin.dart';
import 'package:my_app/components/signup/signup.dart';

class Login extends StatelessWidget {
  late AuthBloc authBloc;
  Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is SignInState) {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => SignInPage()));
          }
          if (state is SignUpState) {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => SignUpPage()));
          }

          if (state is SkipAuth) {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => BottomNavBar()));
          }
        },
        builder: (context, state) {
          authBloc = BlocProvider.of<AuthBloc>(context);
          if (state is InitialLoad) {
            final isSignIn = state.isSignIn;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          isSignIn
                              ? authBloc.add(OnSignInClicked())
                              : authBloc.add(OnSignUpClicked());
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.black,
                          side: const BorderSide(
                            color: Colors.black,
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                        ),
                        child: Text(isSignIn ? 'Sign-In' : 'Sign-Up'),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(isSignIn
                            ? 'Dont have an Account ? '
                            : 'Have an Account ? '),
                        TextButton(
                          onPressed: () {
                            authBloc
                                .add(OnAuthMethodchanged(isSignIn: !isSignIn));
                          },
                          child: Text(isSignIn
                              ? 'Click here to sign-up'
                              : 'Click here to sign-in'),
                        ),
                      ],
                    ),
                    // const Center(
                    //   child: Text('OR'),
                    // ),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    // SizedBox(
                    //   width: double.infinity,
                    //   child: OutlinedButton(
                    //     onPressed: () async {},
                    //     style: OutlinedButton.styleFrom(
                    //       backgroundColor: Colors.white,
                    //       side: const BorderSide(
                    //         color: Colors.black,
                    //         width: 1,
                    //         style: BorderStyle.solid,
                    //       ),
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(10),
                    //       ),
                    //       padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                    //     ),
                    //     child: const Wrap(
                    //       crossAxisAlignment: WrapCrossAlignment.center,
                    //       children: [
                    //         // Image.asset(''),
                    //         Padding(
                    //           padding: EdgeInsets.only(left: 10),
                    //           child: Text(
                    //             'Continue with Google',
                    //             style: TextStyle(color: Colors.black),
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
