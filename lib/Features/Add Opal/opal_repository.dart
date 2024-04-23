import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opal_1_1/Models/opal_model.dart';
import 'dart:io';

import '../../Common/repositories/firebase_storage_repositories.dart';
import '../../Common/utils/image_picker.dart';


// Riverpod Provider
final opalRepositoryProvider = Provider(
  (ref) => OpalRepository(
    firestore: FirebaseFirestore.instance,
  ),
);

class OpalRepository {
  final FirebaseFirestore firestore;
  OpalRepository({
    required this.firestore,
  });

  //Getting Opal Data
  Future<List<OpalModel>> getOpals() async {
    final querySnapshot = await firestore.collection('opals').get();
    return querySnapshot.docs
        .map((doc) => OpalModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  //Uploading photos
  Future<List<String>> _uploadOpalImages(
      List<File> opalPics, String opalId, ProviderRef ref) async {
    List<String> opalPicsUrls = [];

    for (var pic in opalPics) {
      String filePath = 'opalPics/$opalId/${pic.path.split('/').last}';
      try {
        String photoUrl = await ref
            .read(commonFirebaseStorageRepositoryProvider)
            .storeFileToFirebase(filePath, pic);
        opalPicsUrls.add(photoUrl);
      } catch (e) {
        print("Error uploading image: $e");
      }
    }
    return opalPicsUrls;
  }

  //saving new opal data to Firestore
  Future<String> saveOpalDataToFirebase({
    required String userName,
    required String uid,
    required String opalTitle,
    String? opalId,
    List<File>? opalPics,
    required bool isOnline,
    String? country,
    String? city,
    required String aboutOpal,
    required List<String> industry,
    required List<String> sellingOrBuying,
    required List<String> opalTags,
    required ProviderRef ref,
    required BuildContext context,
  }) async {
    try {
      // If opalId is null, generate a new one
      final currentOpalId = opalId ?? firestore.collection('opals').doc().id;

      List<String> opalPicsUrls = [];
      if (opalPics != null && opalPics.isNotEmpty) {
        opalPicsUrls = await _uploadOpalImages(opalPics, currentOpalId, ref);
      }

      // if (opalPics != null && opalPics.isNotEmpty) {
      //   for (var pic in opalPics) {
      //     String photoUrl = await ref
      //         .read(commonFirebaseStorageRepositoryProvider)
      //         .storeFileToFirebase(
      //           'opalPics/${opalId ?? firestore.collection('opals').doc().id}/${pic.path.split('/').last}',
      //           pic,
      //         );
      //     opalPicsUrls.add(photoUrl);
      //   }
      // }

      var opalData = OpalModel(
        userName: userName,
        uid: uid,
        opalTitle: opalTitle,
        opalId: opalId ?? firestore.collection('opals').doc().id,
        opalPics: opalPicsUrls,
        isOnline: isOnline,
        country: country,
        city: city,
        aboutOpal: aboutOpal,
        industry: industry,
        sellingOrBuying: sellingOrBuying,
        opalTags: opalTags,
      );

      // Save the opal data under the specific user
      await firestore.collection('opals').doc(opalId).set(opalData.toMap());

      // Provide feedback to the user & push to Preview screen
      showSnackBar(context: context, text: "Opal data saved successfully!");
      return currentOpalId;
      // Navigator.pushAndRemoveUntil(
      //   context,
      //   MaterialPageRoute(builder: (context) => const PreviewScreen()),
      //   (route) => false,
      // );
    } catch (e) {
      showSnackBar(context: context, text: e.toString());
      rethrow;
    }
  }
}