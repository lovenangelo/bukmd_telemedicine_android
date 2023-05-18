// To parse this JSON data, do
//
//     final pastMedicalHistory = pastMedicalHistoryFromJson(jsonString);

import 'dart:convert';

PastMedicalHistory pastMedicalHistoryFromJson(String str) =>
    PastMedicalHistory.fromJson(json.decode(str));

String pastMedicalHistoryToJson(PastMedicalHistory data) =>
    json.encode(data.toJson());

class PastMedicalHistory {
  PastMedicalHistory(
      {required this.hasPreviousIllnesses,
      required this.hasPreviousAdmissions,
      required this.hasPreviousOperations,
      required this.numberOfPreviousAdmissions,
      required this.dateOfLastAdmission,
      required this.reasonOfAdmission,
      required this.dateOfLastOperation,
      required this.operationProcedure,
      required this.otherIllness,
      required this.listOfIlllness});

  bool hasPreviousIllnesses;
  bool hasPreviousAdmissions;
  bool hasPreviousOperations;
  String numberOfPreviousAdmissions;
  String dateOfLastAdmission;
  String reasonOfAdmission;
  String dateOfLastOperation;
  String operationProcedure;
  String otherIllness;
  List<Map<String, dynamic>> listOfIlllness;

  factory PastMedicalHistory.fromJson(Map<String, dynamic> json) {
    List<dynamic> rawListOfIllness = json['listOfIllness'];
    List<Map<String, dynamic>> convertedList = rawListOfIllness
        .map((e) => {"name": e['name'], "value": e['value']})
        .toList();

    return PastMedicalHistory(
        hasPreviousIllnesses: json["hasPreviousIllnesses"],
        hasPreviousAdmissions: json["hasPreviousAdmissions"],
        hasPreviousOperations: json["hasPreviousOperations"],
        numberOfPreviousAdmissions: json["numberOfPreviousAdmissions"],
        dateOfLastAdmission: json["dateOfLastAdmission"],
        reasonOfAdmission: json["reasonOfAdmission"],
        dateOfLastOperation: json["dateOfLastOperation"],
        operationProcedure: json["operationProcedure"],
        otherIllness: json['otherIllness'],
        listOfIlllness: convertedList);
  }

  Map<String, dynamic> toJson() => {
        "hasPreviousIllnesses": hasPreviousIllnesses,
        "hasPreviousAdmissions": hasPreviousAdmissions,
        "hasPreviousOperations": hasPreviousOperations,
        "numberOfPreviousAdmissions": numberOfPreviousAdmissions,
        "dateOfLastAdmission": dateOfLastAdmission,
        "reasonOfAdmission": reasonOfAdmission,
        "dateOfLastOperation": dateOfLastOperation,
        "operationProcedure": operationProcedure,
        "otherIllness": otherIllness,
        "listOfIllness": listOfIlllness
      };
}
