import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:opal_1_1/Widgets/dialog_box.dart';

import '../../Common/repositories/firebase_storage_repositories.dart';
import '../../Common/utils/image_picker.dart';
import '../../Models/user_model.dart';
import '../Profile/profile_screen.dart';
import '../home_screen.dart';

//Riverpod Provider
final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  ),
);

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  AuthRepository({
    required this.auth,
    required this.firestore,
  });

  //Persisting Auth State //Getting all the user data
  Future<UserModel?> getCurrentUserData() async {
    var userData =
        await firestore.collection('users').doc(auth.currentUser?.uid).get();
    UserModel? user;
    if (userData.data() != null) {
      user = UserModel.fromMap(userData.data()!);
    }
    return user;
  }

  //Sign In with Email and Password function
  void signInWithEmailPassword(
      BuildContext context, String email, String password) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await auth.signInWithEmailAndPassword(email: email, password: password);
        Navigator.pushNamedAndRemoveUntil(
          context,
          HomeScreen.routeName,
          (route) => false,
        );
      } else {
        showSnackBar(context: context, text: 'Please fill in all fields');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showDialogBox(
          context: context, 
          title: 'Error', 
          text: 'No user found for this email. Please register.',
          actions: [{'Try again':() {}}],);
      } else if (e.code == 'wrong-password') {
        showSnackBar(
            context: context,
            text:
                'Wrong password. Please try again or click on forget password to reset');
      } //utils.dart file for showSnackBar
    }
  }

  //Register with Email & Password function
  void registerWithEmail({
    //Need to check if it's Future
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        Navigator.pushNamedAndRemoveUntil(
          context,
          HomeScreen.routeName,
          (route) => false,
        );
      } else {
        showSnackBar(context: context, text: 'Please fill in all fields');
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, text: e.toString());
    }
  }

  //Sign In / Register with Google
  Future<bool> signInWithGoogle(BuildContext context) async {
    bool res = false;
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final crediential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
      UserCredential userCredential = //need to use the userCredential in future?
          await auth.signInWithCredential(crediential);

      //Storing the user in Firestore
      // User? user = userCredential.user;
      // if (user != null) {
      //   if (userCredential.additionalUserInfo!.isNewUser) {
      //     await firestore.collection('users').doc(user.uid).set({
      //       'name': user.displayName,
      //       'uid': user.uid,
      //     });
      //   }
      res = true;
      if (res = true) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          HomeScreen.routeName,
          (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, text: e.toString());
      res = false;
    }
    return res;
  }

  //Sign In / Register with Apple

  //Save ProfilePic //for Profile Screen
  void saveProfilePicToFirebase({
    //required String name,
    required File? profilePic,
    required ProviderRef ref,
    required BuildContext context,
  }) async {
    try {
      String uid = auth.currentUser!.uid;
      String photoUrl =
          'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png';
      if (profilePic != null) {
        String photoUrl = await ref
            .read(commonFirebaseStorageRepositoryProvider)
            .storeFileToFirebase(
              'profilePic/$uid',
              profilePic,
            );
      }
    } catch (e) {
      showSnackBar(context: context, text: e.toString());
    }
  }

  //Save user Data//for EditProfile Screen
  Future<void> saveUserDataToFirebase({
    required String userName,
    File? profilePic,
    required ProviderRef ref,
    required BuildContext context,
    String? company,
    String? userCountry,
    String? userCity,
    required String aboutMe,
    required List <String> userTags,
    required List <String> lookingForTags,
  }) async {
    try {
      String uid = auth.currentUser!.uid;
      String photoUrl =
          'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png';
      if (profilePic != null) {
        photoUrl = await ref
            .read(commonFirebaseStorageRepositoryProvider)
            .storeFileToFirebase(
              'profilePic/$uid',
              profilePic,
            );
      }
      var user = UserModel(
        userName: userName,
        uid: uid,
        profilePic: photoUrl,
        isOnline: true,
        company: company,
        userCountry: userCountry,
        userCity: userCity,
        aboutMe: aboutMe,
        userTags: userTags,
        lookingForTags: lookingForTags,
      );
      await firestore.collection('users').doc(uid).set(user.toMap());
     
    } catch (e) {
      showSnackBar(context: context, text: e.toString());
    }
  }
  
  //SignOut Function
  Future<void> signOut() async {
    await auth.signOut();
  }
}