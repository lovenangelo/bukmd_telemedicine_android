import 'package:bukmd_telemedicine/src/features/news_health_updates/models/philippines_news_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RemoteService {
  Future<List<NewsApi>> getNews() async {
    final snapshots =
        await FirebaseFirestore.instance.collection('doh_press_releases').get();
    return snapshots.docs.map((doc) {
      final eventFromFirestore = NewsApi.fromJson(doc.data());
      eventFromFirestore.id = doc.id;
      return eventFromFirestore;
    }).toList();
  }
}
