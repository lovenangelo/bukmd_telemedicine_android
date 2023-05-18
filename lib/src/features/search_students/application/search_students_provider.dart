import 'package:bukmd_telemedicine/src/features/search_students/infrastructure/search_students_service.dart';
import 'package:bukmd_telemedicine/src/features/search_students/model/search_students_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchStudentsProvider = StreamProvider.autoDispose
    .family<List<SearchStudents>, String>((ref, query) {
  return SearchStudentsService().getStudents(query);
});
