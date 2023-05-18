import 'package:bukmd_telemedicine/src/features/doctor_dashboard/infrastructure/service/firestore_news_health.dart';
import 'package:bukmd_telemedicine/src/features/news_health_updates/models/philippines_news_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final newsHealthProvider = StreamProvider<List<NewsApi>>((ref) {
  return NewsHealthFirestore().getNews();
});
