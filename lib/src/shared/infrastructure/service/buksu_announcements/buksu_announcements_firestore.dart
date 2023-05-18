import 'package:bukmd_telemedicine/src/shared/domain/buksu_announcements/buksu_announcements_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BuksuAnnouncementsFirestore {
  final _db = FirebaseFirestore.instance;

  Future createAnnouncement(BuksuAnnouncements ba) async {
    final announcement = ba.toJson();
    try {
      await _db
          .collection("buksu_announcements")
          .doc('announcement')
          .set(announcement);
    } on FirebaseAuthException {
      return null;
    }
  }

  Future getAnnouncement() async {
    final snapshot =
        await _db.collection("buksu_announcements").doc('announcement').get();

    if (snapshot.exists) {
      return BuksuAnnouncements.fromJson(snapshot.data()!);
    } else {
      return null;
    }
  }

  Future deleteAnnouncement() async {
    try {
      await _db.collection("buksu_announcements").doc('announcement').delete();
    } catch (e) {
      return null;
    }
  }
}
