import 'dart:convert';

AppointmentResult appointmentResponseFromJson(String str) =>
    AppointmentResult.fromJson(json.decode(str));

String appointmentResponseToJson(AppointmentResult data) =>
    json.encode(data.toJson());

class AppointmentResult {
  AppointmentResult({
    this.date,
    this.diagnosis,
    this.name,
    this.doctor,
    this.prescriptionUrl,
    this.patientId,
    this.college,
    this.consultationType,
  });

  DateTime? date;
  String? diagnosis;
  String? name;
  String? doctor;
  String? prescriptionUrl;
  String? appointmentId;
  String? patientId;
  String? college;
  String? consultationType;

  factory AppointmentResult.fromJson(Map<String, dynamic> json) =>
      AppointmentResult(
        diagnosis: json["diagnosis"],
        date: DateTime.parse(json["date"].toDate().toString()),
        name: json["name"],
        doctor: json["doctor"],
        prescriptionUrl: json["prescriptionUrl"],
        patientId: json["patientId"],
        college: json["college"],
        consultationType: json["consultationType"],
      );

  Map<String, dynamic> toJson() => {
        "diagnosis": diagnosis,
        "date": date,
        "name": name,
        "doctor": doctor,
        "prescriptionUrl": prescriptionUrl,
        "patientId": patientId,
        "college": college,
        "consultationType": consultationType
      };
}
