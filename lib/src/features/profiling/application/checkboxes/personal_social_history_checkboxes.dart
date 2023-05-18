import 'package:flutter_riverpod/flutter_riverpod.dart';

final personalSocialHistoryCBProvider = StateNotifierProvider<
    PersonalSocialHistoryCheckBoxesNotifier,
    PersonalSocialHistoryCheckBoxes>((ref) {
  return PersonalSocialHistoryCheckBoxesNotifier();
});

class PersonalSocialHistoryCheckBoxesNotifier
    extends StateNotifier<PersonalSocialHistoryCheckBoxes> {
  PersonalSocialHistoryCheckBoxesNotifier()
      : super(PersonalSocialHistoryCheckBoxes(
          hasNoKnownAllergies: true,
          hasFoodAllergies: false,
          hasMedicationAllergies: false,
          isDrinker: false,
          isSmoker: false,
          isTakingMedicationsRegularly: false,
        ));

  setFoodAndMedicationsCBToFalse() {
    state.hasFoodAllergies = false;
    state.hasMedicationAllergies = false;
  }

  setHasNoKnownAllergies(bool value) => state.hasNoKnownAllergies = value;

  setHasFoodAllergies(bool value) => state.hasFoodAllergies = value;

  setHasMedicationAllergies(bool value) => state.hasMedicationAllergies = value;

  setIsDrinker(bool value) => value;

  setIsSmoker(bool value) => value;

  setIsTakingMedicationsRegularly(bool value) =>
      state.isTakingMedicationsRegularly = value;
}

class PersonalSocialHistoryCheckBoxes {
  bool hasNoKnownAllergies;
  bool hasFoodAllergies;
  bool hasMedicationAllergies;
  bool isSmoker;
  bool isDrinker;
  bool isTakingMedicationsRegularly;

  PersonalSocialHistoryCheckBoxes({
    required this.hasNoKnownAllergies,
    required this.hasFoodAllergies,
    required this.hasMedicationAllergies,
    required this.isDrinker,
    required this.isSmoker,
    required this.isTakingMedicationsRegularly,
  });
}
