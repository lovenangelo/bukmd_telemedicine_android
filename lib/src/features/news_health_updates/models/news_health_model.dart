import 'package:bukmd_telemedicine/src/features/news_health_updates/models/philippines_news_model.dart';

class NewsHealthModel {
  NewsHealthModel({required this.newsApi, required this.bukSuAnnouncementsApi});

  List<NewsApi> newsApi;
  Map<String, dynamic>? bukSuAnnouncementsApi;
}
