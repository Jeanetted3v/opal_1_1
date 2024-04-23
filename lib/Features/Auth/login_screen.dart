import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Widgets/AuthWidgets/login_textfield.dart';
import '../../Widgets/AuthWidgets/signin_register_button.dart';
import '../../Widgets/AuthWidgets/square_tile.dart';
import 'auth_controller.dart';
import 'register_screen.dart';


class LoginScreen extends ConsumerStatefulWidget {
  static const routeName = '/login-screen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  //sign User in using Email Password
  void signUserInEmailPassword() async {
    String email = emailController.text;
    String password = passwordController.text;

    //Show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );
    //Sign in
    ref
        .read(authControllerProvider)
        .signInWithEmailPassword(context, email, password);
    //Pop the loading circle
    Navigator.pop(context);
  }

  //Google SignIn
  void signInWithGoogle() async {
    ref.read(authControllerProvider).googleSignIn(context);
  }

  //Navigate to RegisterScreen
  void navigateToRegisterScreen(BuildContext context) {
    Navigator.pushNamed(context, RegisterScreen.routeName);
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
                  'Welcome back you\'ve been missed!',
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

                //forget password?
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('Forgot Password?',
                          style: TextStyle(color: Colors.grey.shade600)),
                    ],
                  ),
                ),

                SizedBox(height: height / 50),

                //Sign in Button
                SignInRegisterButton(
                    onTap: signUserInEmailPassword, text: 'Sign In'),

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
                      imagePath: 'assets/google.png',
                    ),

                    const SizedBox(width: 10),

                    //Apple Button
                    SquareTile(
                      onTap: () {},
                      imagePath: 'assets/apple.png',
                    ),
                  ],
                ),

                SizedBox(height: height / 15),

                //Don't have an Account? Register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member?',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () => navigateToRegisterScreen(
                          context), //Route to RegisterScreen,
                      child: const Text(
                        'Register now',
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