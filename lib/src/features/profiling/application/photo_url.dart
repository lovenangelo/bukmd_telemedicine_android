import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../authentication/service/firebase_auth_service.dart';

final updatePhotoUrlProvider = FutureProvider<String?>((ref) async {
  final auth = FirebaseAuthService();
  final updatedUrl = auth.currentUser!.photoURL;
  await auth.updatePhotoUrl(updatedUrl);

  return auth.currentUser?.photoURL;
});

final photoUrlNotifierProvider =
    StateNotifierProvider<UrlNotifier, String?>((ref) {
  return UrlNotifier();
});

class UrlNotifier extends StateNotifier<String?> {
  UrlNotifier() : super('');
  updateUrl(String? url) => state = url;
}
