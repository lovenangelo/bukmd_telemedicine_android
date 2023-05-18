import 'package:flutter_riverpod/flutter_riverpod.dart';

final botNavBarWrapperIndexProvider =
    StateNotifierProvider.autoDispose<BotNavBarCurrentIndexNotifier, int>(
        (ref) {
  return BotNavBarCurrentIndexNotifier();
});

class BotNavBarCurrentIndexNotifier extends StateNotifier<int> {
  BotNavBarCurrentIndexNotifier() : super(0);

  int setNewCurrent(int index) {
    return super.state = index;
  }
}
