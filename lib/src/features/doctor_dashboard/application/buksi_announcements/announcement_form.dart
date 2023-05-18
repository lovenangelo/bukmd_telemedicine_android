import 'package:bukmd_telemedicine/src/shared/domain/buksu_announcements/buksu_announcements_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final announcementFormProvider = StateNotifierProvider.autoDispose<
    AnnouncementFormNotifier, BuksuAnnouncements>((ref) {
  return AnnouncementFormNotifier();
});

class AnnouncementFormNotifier extends StateNotifier<BuksuAnnouncements> {
  AnnouncementFormNotifier()
      : super(BuksuAnnouncements(
            date: '', description: '', location: '', title: ''));

  setDate(String date) {
    state.date = date;
  }

  setDescription(String description) {
    state.description = description;
  }

  setLocation(String location) {
    state.location = location;
  }

  setTitle(String title) {
    state.title = title;
  }
}
