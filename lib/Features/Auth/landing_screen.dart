import 'package:flutter/material.dart';

import '../../Common/utils/colors.dart';
import '../../Widgets/AuthWidgets/custom_button.dart';
import 'login_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  void navigateToLoginScreen(BuildContext context) {
    Navigator.pushNamed(context, LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),

            //Welcome message
            const Text(
              'Welcome to Opaltunity',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: size.height / 12),

            //Logo
            Image.asset(
              'assets/apple.png',
              height: 250,
              width: 250,
              color: Colors.grey,
            ),

            SizedBox(height: size.height / 12),

            //Policy
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                "Read our Privacy Policy. Tap 'Agree and Continue' to accept the Terms of Service.",
                style: TextStyle(color: greyColor),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 10),

            //Agree & Continue Button
            SizedBox(
              width: size.width * 0.75,
              child: CustomButton(
                text: 'Agree and Continue',
                onPressed: () =>
                    navigateToLoginScreen(context), //Route to LoginScreen
              ),
            ),
          ],
        ),
      ),

      // body: StreamBuilder<User?>(
      //     stream: FirebaseAuth.instance.authStateChanges(),
      //     builder: (context, snapshot) {
      //       //User is logged in
      //       if (snapshot.hasData) {
      //         return HomeScreen();
      //       } else {
      //         //User is NOT logged in
      //         return LoginScreen();
      //       }
      //     }),
    );
  }
}