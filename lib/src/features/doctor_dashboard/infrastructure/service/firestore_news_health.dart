import 'package:bukmd_telemedicine/src/features/news_health_updates/models/philippines_news_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewsHealthFirestore {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Stream<List<NewsApi>> getNews() {
    final querySnapshots = _firestore.collection('doh_press_releases');

    return querySnapshots.snapshots().map((event) {
      final list = event.docs.map((doc) {
        final appointmentRecordFromFirestore = NewsApi.fromJson(doc.data());
        appointmentRecordFromFirestore.id = doc.id;
        return appointmentRecordFromFirestore;
      }).toList();
      return list;
    });
  }

  Future addNews(NewsApi addNews) async {
    try {
      await FirebaseFirestore.instance
          .collection('doh_press_releases')
          .doc()
          .set(addNews.toJson());
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  Future updateNews(NewsApi news) async {
    try {
      await FirebaseFirestore.instance
          .collection('doh_press_releases')
          .doc(news.id)
          .update(news.toJson());
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  Future deleteNewsHealth(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('doh_press_releases')
          .doc(id)
          .delete();
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  Future deleteAllNewsHealth() async {
    try {
      final docRef = await FirebaseFirestore.instance
          .collection('doh_press_releases')
          .get()
          .then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
      });
    } on FirebaseException catch (e) {
      print(e);
    }
  }
}
