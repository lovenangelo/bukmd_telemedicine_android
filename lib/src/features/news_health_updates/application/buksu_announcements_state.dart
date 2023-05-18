import 'package:flutter_riverpod/flutter_riverpod.dart';

final showBuksuAnnouncementProvider =
    StateNotifierProvider<ShowBuksuAnnouncement, bool>((ref) {
  return ShowBuksuAnnouncement();
});

class ShowBuksuAnnouncement extends StateNotifier<bool> {
  ShowBuksuAnnouncement() : super(true);

  setFalse() {
    state = false;
  }

  setTrue() {
    state = true;
  }
}
