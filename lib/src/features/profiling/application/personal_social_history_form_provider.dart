import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/personal_social_history.dart';

final personalSocialHistoryFormProvider = StateNotifierProvider<
    PersonalSocialHistoryFormNotifier, PersonalSocialHistory>((ref) {
  return PersonalSocialHistoryFormNotifier();
});

class PersonalSocialHistoryFormNotifier
    extends StateNotifier<PersonalSocialHistory> {
  PersonalSocialHistoryFormNotifier()
      : super(PersonalSocialHistory(
            hasAllergies: false,
            foodAllergies: '',
            medicationAllergies: '',
            isSmoker: false,
            yearStartedSmoking: '',
            numberOfSticksPerDay: 0,
            isDrinker: false,
            howOftenDrinks: '',
            isTakingMedicationsRegularly: false,
            specifiedMedication: ''));
  setHasAllergies(bool hasAllergies) {
    state.hasAllergies = hasAllergies;
  }

  setFoodAllergies(String allergies) {
    state.foodAllergies = allergies;
  }

  setMedicationAllergies(String allergies) {
    state.medicationAllergies = allergies;
  }

  setIsSmoker(bool isSmoker) {
    state.isSmoker = isSmoker;
  }

  setYearStartedSmoking(String year) {
    state.yearStartedSmoking = year;
  }

  setNumOfSticksPerDay(int number) {
    state.numberOfSticksPerDay = number;
  }

  setIsDrinker(bool isDrinker) {
    state.isDrinker = isDrinker;
  }

  setHowOftenDrinks(String frequency) {
    state.howOftenDrinks = frequency;
  }

  setIsTakingMedications(bool isTakingMedications) {
    state.isTakingMedicationsRegularly = isTakingMedications;
  }

  setSpecifiedMedication(String medication) {
    state.specifiedMedication = medication;
  }
}
