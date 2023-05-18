// To parse this JSON data, do
//
//     final searchStudents = searchStudentsFromJson(jsonString);

import 'dart:convert';

SearchStudents searchStudentsFromJson(String str) =>
    SearchStudents.fromJson(json.decode(str));

String searchStudentsToJson(SearchStudents data) => json.encode(data.toJson());

class SearchStudents {
  SearchStudents({
    required this.name,
    this.id,
  });

  String name;
  String? id;

  factory SearchStudents.fromJson(Map<String, dynamic> json) =>
      SearchStudents(name: json["fullName"]);

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
      };
}
