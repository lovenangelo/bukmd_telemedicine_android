import 'package:flutter_riverpod/flutter_riverpod.dart';

final dropDownProvider = StateNotifierProvider<DropDownNotifier, String>((ref) {
  return DropDownNotifier();
});

class DropDownNotifier extends StateNotifier<String> {
  DropDownNotifier() : super('Online consultation');

  setValue(String value) {
    super.state = value;
  }
}
