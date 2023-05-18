// To parse this JSON data, do
//
//     final event = eventFromJson(jsonString);

import 'dart:convert';

Event eventFromJson(String str) => Event.fromJson(json.decode(str));

String eventToJson(Event data) => json.encode(data.toJson());

class Event {
  Event({
    this.type,
    this.start,
    this.end,
    this.description,
    this.name,
    this.hex,
    this.status,
    this.id,
    this.createdAt
  });

  String? type;
  DateTime? start;
  DateTime? end;
  String? description;
  String? name;
  String? hex;
  String? status;
  String? id;
  DateTime? createdAt;

  factory Event.fromJson(Map<String, dynamic> json) => Event(
      type: json["type"],
      start: DateTime.parse(json["start"].toDate().toString()),
      end: DateTime.parse(json["end"].toDate().toString()),
      description: json["description"],
      name: json["name"],
      hex: json["hex"],
      status: json["status"],
      id: json["id"],
      createdAt: DateTime.parse(json["createdAt"].toDate().toString()),);

  Map<String, dynamic> toJson() => {
        "type": type,
        "start": start,
        "end": end,
        "description": description,
        "name": name,
        "hex": hex,
        "status": status,
        "id": id,
        "createdAt": createdAt
      };
}
