import 'package:bukmd_telemedicine/src/features/news_health_updates/models/philippines_news_model.dart';
import 'package:bukmd_telemedicine/src/shared/domain/buksu_announcements/buksu_announcements_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/news_health_model.dart';
import '../../../shared/infrastructure/service/buksu_announcements/buksu_announcements_firestore.dart';
import '../services/remote_service.dart';

final _bukSUFirestore = BuksuAnnouncementsFirestore();

final newsProvider = FutureProvider<NewsHealthModel?>((ref) async {
  final news = await RemoteService().getNews();
  final BuksuAnnouncements? buksuNews = await _bukSUFirestore.getAnnouncement();

  final newsHealthData = NewsHealthModel(
      newsApi: news, bukSuAnnouncementsApi: buksuNews?.toJson());
  return newsHealthData;
});
