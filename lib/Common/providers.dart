import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Features/Add Opal/opal_controller.dart';
import '../Features/Add Opal/opal_repository.dart';
import '../Models/opal_model.dart';


//Users
final currentUserProvider = Provider<User?>((ref) {
  return FirebaseAuth.instance.currentUser;
});

//Users, using StreamProvider instead
// final currentUserProvider = StreamProvider<User?>((ref) {
//   return FirebaseAuth.instance.authStateChanges();
// });

final userProfileProvider =
    FutureProvider.autoDispose.family<DocumentSnapshot, String>((ref, uid) {
  return FirebaseFirestore.instance.collection('users').doc(uid).get();
});

//Opal
final opalRepositoryProvider =
    Provider((ref) => OpalRepository(firestore: FirebaseFirestore.instance));

final opalControllerProvider = Provider((ref) {
  final opalRepository = ref.watch(opalRepositoryProvider);
  return OpalController(opalRepository: opalRepository, ref: ref);
});

final opalsFutureProvider = FutureProvider<List<OpalModel>>((ref) {
  final opalRepo = ref.read(opalRepositoryProvider);
  return opalRepo.getOpals();
});