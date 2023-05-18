// To parse this JSON data, do
//
//     final personalSocialHistory = personalSocialHistoryFromJson(jsonString);

import 'dart:convert';

PersonalSocialHistory personalSocialHistoryFromJson(String str) =>
    PersonalSocialHistory.fromJson(json.decode(str));

String personalSocialHistoryToJson(PersonalSocialHistory data) =>
    json.encode(data.toJson());

class PersonalSocialHistory {
  PersonalSocialHistory({
    required this.hasAllergies,
    required this.foodAllergies,
    required this.medicationAllergies,
    required this.isSmoker,
    required this.yearStartedSmoking,
    required this.numberOfSticksPerDay,
    required this.isDrinker,
    required this.howOftenDrinks,
    required this.isTakingMedicationsRegularly,
    required this.specifiedMedication,
  });

  bool hasAllergies;
  String foodAllergies;
  String medicationAllergies;
  bool isSmoker;
  String yearStartedSmoking;
  int numberOfSticksPerDay;
  bool isDrinker;
  String howOftenDrinks;
  bool isTakingMedicationsRegularly;
  String specifiedMedication;

  factory PersonalSocialHistory.fromJson(Map<String, dynamic> json) =>
      PersonalSocialHistory(
        hasAllergies: json["hasAllergies"],
        foodAllergies: json["foodAllergies"],
        medicationAllergies: json["medicationAllergies"],
        isSmoker: json["isSmoker"],
        yearStartedSmoking: json["yearStartedSmoking"],
        numberOfSticksPerDay: json["numberOfSticksPerDay"],
        isDrinker: json["isDrinker"],
        howOftenDrinks: json["howOftenDrinks"],
        isTakingMedicationsRegularly: json["isTakingMedicationsRegularly"],
        specifiedMedication: json["specifiedMedication"],
      );

  Map<String, dynamic> toJson() => {
        "hasAllergies": hasAllergies,
        "foodAllergies": foodAllergies,
        "medicationAllergies": medicationAllergies,
        "isSmoker": isSmoker,
        "yearStartedSmoking": yearStartedSmoking,
        "numberOfSticksPerDay": numberOfSticksPerDay,
        "isDrinker": isDrinker,
        "howOftenDrinks": howOftenDrinks,
        "isTakingMedicationsRegularly": isTakingMedicationsRegularly,
        "specifiedMedication": specifiedMedication,
      };
}
