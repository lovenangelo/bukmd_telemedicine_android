import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoadingNotifier extends StateNotifier<bool> {
  LoadingNotifier() : super(false);
  void setLoadingTrue() {
    super.state = true;
  }

  void setLoadingFalse() {
    super.state = false;
  }
}

final loadingProvider =
    StateNotifierProvider.autoDispose<LoadingNotifier, bool>((ref) {
  return LoadingNotifier();
});
