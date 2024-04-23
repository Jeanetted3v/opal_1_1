import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Common/utils/image_picker.dart';
import '../../Widgets/AuthWidgets/login_textfield.dart';
import '../../Widgets/AuthWidgets/signin_register_button.dart';
import '../../Widgets/AuthWidgets/square_tile.dart';
import 'auth_controller.dart';
import 'login_screen.dart';


class RegisterScreen extends ConsumerStatefulWidget {
  static const routeName = '/register-screen';
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<RegisterScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<RegisterScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  //Register User using Email Password
  registerWithEmail() {
    String email = emailController.text;
    String password = passwordController.text;
    if (password == confirmPasswordController.text) {
      ref
          .read(authControllerProvider)
          .registerUserWithEmail(context, email, password);
      //Show successful registration and login
      //Navigate to HomeScreen
    } else {
      //Error message, Passwords don't match
      showSnackBar(context: context, text: 'Passwords don\'t match');
    }
  }

  //Google SignIn
  void signInWithGoogle() async {
    ref.read(authControllerProvider).googleSignIn(context);
  }

  //Navigate to LoginScreen
  void navigateToLoginScreen(BuildContext context) {
    Navigator.pushNamed(context, LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height; //screen height

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: height / 16),

                //Logo
                const Icon(Icons.lock, size: 100),

                SizedBox(height: height / 20),

                //Welcome back, you've been missed
                Text(
                  'Let\'s create an account for you',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 10),

                //Email textfield
                LoginTextField(
                  textController: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),
                const SizedBox(height: 8),

                //password textfield
                LoginTextField(
                  textController: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 8),

                //Confirm password textfield
                LoginTextField(
                  textController: confirmPasswordController,
                  hintText: 'Re-type to confirm password',
                  obscureText: true,
                ),

                const SizedBox(height: 8),

                SizedBox(height: height / 50),

                //Sign in Button
                SignInRegisterButton(
                  onTap: registerWithEmail,
                  text: 'Sign Up',
                ),

                SizedBox(height: height / 50),

                //or continue with
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 1,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      ),
                      Expanded(
                          child: Divider(
                        thickness: 1,
                        color: Colors.grey.shade400,
                      ))
                    ],
                  ),
                ),

                SizedBox(height: height / 50),

                //Google + Apple SignIn Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Google Button
                    SquareTile(
                        onTap: () => signInWithGoogle(),
                        imagePath: 'assets/google.png'),

                    const SizedBox(width: 10),

                    //Apple Button
                    SquareTile(
                        onTap: () {}, imagePath: 'assets/apple.png'),
                  ],
                ),

                SizedBox(height: height / 15),

                //Don't have an Account? Register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () =>
                          navigateToLoginScreen(context), //Route to LoginScreen
                      child: const Text(
                        'Login now',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}