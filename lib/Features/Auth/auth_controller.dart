import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Models/user_model.dart';
import 'auth_repository.dart';

//All providers in this app have to be global
final authControllerProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository: authRepository, ref: ref);
});

//Future Provider
final userDataAuthProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider);
  return authController.getUserData();
});

class AuthController {
  final AuthRepository authRepository;
  final ProviderRef ref;
  AuthController({
    required this.authRepository,
    required this.ref,
  });

  //Persisting Auth State //Getting current user data.
  //Using Future Provider, thus not using Void
  Future<UserModel?> getUserData() async {
    UserModel? user = await authRepository.getCurrentUserData();
    return user;
  }

  void signInWithEmailPassword(
      BuildContext context, String email, String password) {
    authRepository.signInWithEmailPassword(context, email, password);
  }

  //Register user
  void registerUserWithEmail(
      BuildContext context, String email, String password) {
    authRepository.registerWithEmail(
        email: email, password: password, context: context);
  }

  //Google SignIn
  void googleSignIn(
    BuildContext context,
  ) {
    authRepository.signInWithGoogle(context);
  }

  //Saving user profile data to Firebase
  Future<void> saveUserDataToFirebase(
      BuildContext context,
      String userName,
      File? profilePic,
      String? company,
      String? userCountry,
      String? userCity,
      String aboutMe,
      List<String> userTags,
      List<String> lookingForTags) async {
    await authRepository.saveUserDataToFirebase(
      userName: userName,
      profilePic: profilePic,
      company: company,
      userCountry: userCountry,
      userCity: userCity,
      aboutMe: aboutMe,
      userTags: userTags,
      lookingForTags: lookingForTags,
      ref: ref,
      context: context,
    );
  }

  void signOut(BuildContext context) {
    authRepository.signOut();
  }
}