import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:my_app/components/bottom_nav.dart';
import 'package:my_app/components/login_auth/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Introduction extends StatelessWidget {
  const Introduction({super.key});

  Future<bool> userloggedin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final isUserLoggedIn = prefs.getBool('isUserLoggedIn') ?? false;
    return isUserLoggedIn;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      backgroundColor: const Color(0xff000080),
      splash: Padding(
        padding: const EdgeInsets.all(10),
        child: SizedBox(
          child: Lottie.asset(
            'assets/splash.json',
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
        ),
      ),
      nextScreen: FutureBuilder(
        future: userloggedin(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == true) {
              return BottomNavBar();
            } else {
              return IntroductionScreen(
                showNextButton: true,
                pages: [
                  PageViewModel(
                    title: 'What this app will do?',
                    bodyWidget: const Text(
                        'A Beautiful App featuring tracking of amount spent \n with group of friends/families.'),
                    image: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Lottie.asset('assets/onboarding_1.json'),
                      ),
                    ),
                  ),
                  PageViewModel(
                    title: 'SPLITTER',
                    bodyWidget: const Text(
                        'Helps in tracking of amount owed to how many people within the groups.\n Ability to add friends/families in the group by accessing contacts of your phone.'),
                    image: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Lottie.asset('assets/onboarding_1.json'),
                      ),
                    ),
                  ),
                  PageViewModel(
                    title: 'SPLITTER',
                    bodyWidget:
                        const Text('Ability to track list of groups created.'),
                    image: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Lottie.asset('assets/onboarding_1.json'),
                      ),
                    ),
                  ),
                ],
                onDone: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => Login()));
                },
                showSkipButton: true,
                skip: const Text('Skip'),
                onSkip: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => Login()));
                },
                next: const Text('Next'),
                done: const Text('Done'),
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      duration: 2000,
    );
  }
}
