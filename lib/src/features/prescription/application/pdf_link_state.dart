import 'package:flutter_riverpod/flutter_riverpod.dart';

final pdfLinkProvider = StateNotifierProvider<PdfLink, String?>((ref) {
  return PdfLink();
});

class PdfLink extends StateNotifier<String?> {
  PdfLink() : super(null);
  updateLink(String link) {
    state = link;
  }
}
