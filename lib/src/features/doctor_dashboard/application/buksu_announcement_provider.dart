import 'package:bukmd_telemedicine/src/shared/infrastructure/service/buksu_announcements/buksu_announcements_firestore.dart';
import 'package:bukmd_telemedicine/src/shared/domain/buksu_announcements/buksu_announcements_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _bukSUFirestore = BuksuAnnouncementsFirestore();

final buksuAnnouncementProvider =
    FutureProvider.autoDispose<BuksuAnnouncements?>((ref) async {
  final buksuNews = await _bukSUFirestore.getAnnouncement();
  return buksuNews;
});

final createBuksuAnnouncementProvider =
    FutureProvider.family<void, BuksuAnnouncements>((ref, ba) async {
  await _bukSUFirestore.createAnnouncement(ba);
});
