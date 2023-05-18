import 'package:flutter_riverpod/flutter_riverpod.dart';

final prescriptionLinkProvider =
    StateNotifierProvider.autoDispose<PrescriptionLinkNotifier, String?>((ref) {
  return PrescriptionLinkNotifier();
});

class PrescriptionLinkNotifier extends StateNotifier<String?> {
  PrescriptionLinkNotifier() : super(null);

  updateLink(String? url) {
    state = url;
  }

  reset() {
    state = null;
  }
}
