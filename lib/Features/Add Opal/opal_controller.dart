import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opal_1_1/Models/opal_model.dart';

import 'opal_repository.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class OpalController {
  final OpalRepository _opalRepository;
  final ProviderRef ref;

  OpalController({
    required OpalRepository opalRepository,
    required this.ref,
  }) : _opalRepository = opalRepository;

  //Getting Opal Data
  Future<List<OpalModel>> fetchOpals() {
    return _opalRepository.getOpals();
  }

  //Saving Opal Data to Firebase
  Future<void> saveOpalDataToFirebase({
    required String userName,
    required String uid,
    required String opalTitle,
    required String opalId,
    List<File>? opalPics,
    required bool isOnline,
    String? country,
    String? city,
    required String aboutOpal,
    required List<String> industry,
    required List<String> sellingOrBuying,
    List<String>? opalTags,
    required BuildContext context,
  }) async {
    try {
      await _opalRepository.saveOpalDataToFirebase(
        userName: userName,
        uid: uid,
        opalTitle: opalTitle,
        opalId: opalId,
        opalPics: opalPics,
        isOnline: isOnline,
        country: country,
        city: city,
        aboutOpal: aboutOpal,
        industry: industry,
        sellingOrBuying: sellingOrBuying,
        opalTags: opalTags ?? [],
        ref: ref,
        context: context,
      );
    } catch (e) {
      logger.e("Error while saving Opal data", error: e);
      rethrow;
    }
  }
}