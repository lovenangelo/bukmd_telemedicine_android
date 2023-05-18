// To parse this JSON data, do
//
//     final newsApi = newsApiFromJson(jsonString);

import 'dart:convert';

NewsApi newsApiFromJson(String str) => NewsApi.fromJson(json.decode(str));

String newsApiToJson(NewsApi data) => json.encode(data.toJson());

class NewsApi {
  NewsApi({
    this.date,
    this.title,
    this.url,
    this.id,
  });

  String? date;
  String? title;
  String? url;
  String? id;

  factory NewsApi.fromJson(Map<String, dynamic> json) => NewsApi(
      date: json["date"],
      title: json["title"],
      url: json["url"],
      id: json["id"]);

  Map<String, dynamic> toJson() => {
        "date": date,
        "title": title,
        "url": url,
      };
}
