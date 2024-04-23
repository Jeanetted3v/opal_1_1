import 'package:flutter/material.dart';
import '../Features/Auth/login_screen.dart';
import '../Features/Auth/register_screen.dart';
import '../Features/Profile/edit_profile_screen.dart';
import '../Features/Profile/profile_screen.dart';
import '../Features/Profile/setting_screen.dart';
import '../Features/home_screen.dart';
import '../Widgets/error_screen.dart';



Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );

    case HomeScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      );

    case RegisterScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const RegisterScreen(),
      );

    case ProfileScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const ProfileScreen(),
      );

    case EditProfileScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const EditProfileScreen(),
      );

    case SettingScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const SettingScreen(),
      );

    //When there is a error in the app, return default
    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: ErrorScreen(error: 'This page doesn\'t exist'),
        ),
      );
  }
}