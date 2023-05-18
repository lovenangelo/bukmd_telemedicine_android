import 'package:bukmd_telemedicine/src/features/authentication/service/firestore_users_collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getUserTypeProvider =
    FutureProvider.autoDispose.family<bool?, String>((ref, email) {
  return FirestoreUsersCollectionController().getUserType(email);
});

class FirestoreUsersCollectionController {
  final _usersFirestore = FirestoreUsersCollection();

  Future<bool?> getUserType(String email) async {
    return await _usersFirestore.getUserType(email);
  }

  Future addToUsersCollection(String email) async {
    await _usersFirestore.addToUsersCollection(email);
  }
}
