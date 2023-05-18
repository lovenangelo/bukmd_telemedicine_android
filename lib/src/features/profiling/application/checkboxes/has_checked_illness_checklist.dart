import 'package:flutter_riverpod/flutter_riverpod.dart';

final hasCheckedIllnessChecklistProvider =
    StateNotifierProvider<HasCheckedIllnessChecklistNotifier, bool>(
        (ref) => HasCheckedIllnessChecklistNotifier());

class HasCheckedIllnessChecklistNotifier extends StateNotifier<bool> {
  HasCheckedIllnessChecklistNotifier() : super(false);
  void updateValue(bool value) => state = value;
}
