import 'package:flutter_riverpod/flutter_riverpod.dart';

final maleCheckBoxProvider = StateNotifierProvider.autoDispose
    .family<MaleCheckBoxNotifier, bool, String?>((ref, studentSex) {
  bool isMale = studentSex == 'Male' ? true : false;
  return MaleCheckBoxNotifier(isMale);
});

final femaleCheckBoxProvider = StateNotifierProvider.autoDispose
    .family<FemaleCheckBoxNotifier, bool, String?>((ref, studentSex) {
  bool isFemale = studentSex == 'Female' ? true : false;
  return FemaleCheckBoxNotifier(isFemale);
});

final checkBoxValidatorProvider =
    StateNotifierProvider.autoDispose<CheckBoxValidatorNotifier, bool>((ref) {
  return CheckBoxValidatorNotifier();
});

class MaleCheckBoxNotifier extends StateNotifier<bool> {
  MaleCheckBoxNotifier(bool? initState) : super(initState ?? false);
  void toggleMale() {
    super.state = !super.state;
  }
}

class FemaleCheckBoxNotifier extends StateNotifier<bool> {
  FemaleCheckBoxNotifier(bool? initState) : super(initState ?? false);

  void toggleFemale() {
    super.state = !super.state;
  }
}

class CheckBoxValidatorNotifier extends StateNotifier<bool> {
  CheckBoxValidatorNotifier() : super(true);

  bool setValidator(bool maleCB, bool femaleCB) {
    return super.state = maleCB || femaleCB ? true : false;
  }
}
