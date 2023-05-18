import 'package:bukmd_telemedicine/src/features/search_students/model/search_students_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchStudentsService {
  final _collection = FirebaseFirestore.instance.collection('students');

  Stream<List<SearchStudents>> getStudents(String query) {
    final input = query.toLowerCase();
    final suggestions = _collection.snapshots().map((snapshot) {
      final list = snapshot.docs.where((doc) {
        final student = SearchStudents.fromJson(doc.data());
        student.id = doc.id;
        final studentName = student.name.toLowerCase();
        return studentName.contains(input);
      }).toList();
      return list;
    });

    return suggestions.map((snapshot) {
      final list = snapshot.map((doc) {
        final medicine = SearchStudents.fromJson(doc.data());
        medicine.id = doc.id;
        return medicine;
      }).toList();
      return list;
    });
  }
}
