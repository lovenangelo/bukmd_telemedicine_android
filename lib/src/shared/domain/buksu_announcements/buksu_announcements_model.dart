// To parse this JSON data, do
//
//     final bukSuAnnouncementsApi = bukSuAnnouncementsApiFromJson(jsonString);

import 'dart:convert';

BuksuAnnouncements bukSuAnnouncementsApiFromJson(String str) =>
    BuksuAnnouncements.fromJson(json.decode(str));

String bukSuAnnouncementsApiToJson(BuksuAnnouncements data) =>
    json.encode(data.toJson());

class BuksuAnnouncements {
  BuksuAnnouncements({
    required this.date,
    required this.description,
    required this.location,
    required this.title,
  });

  String date;
  String description;
  String location;
  String title;

  factory BuksuAnnouncements.fromJson(Map<String, dynamic> json) =>
      BuksuAnnouncements(
        date: json["date"],
        description: json["description"],
        location: json["location"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "date": date,
        "description": description,
        "location": location,
        "title": title,
      };
}
