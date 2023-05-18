import 'package:flutter_riverpod/flutter_riverpod.dart';

final familyHistoryIllnessListProvider =
    StateNotifierProvider<FamilyHistoryIllnessList, List<Map<String, dynamic>>>(
  (ref) {
    return FamilyHistoryIllnessList();
  },
);

class FamilyHistoryIllnessList
    extends StateNotifier<List<Map<String, dynamic>>> {
  FamilyHistoryIllnessList()
      : super([
          {"name": 'Asthma', "value": false},
          {"name": 'High Blood Pressure', "value": false},
          {"name": 'Cancer', "value": false},
          {"name": 'Heart Problems', "value": false},
          {"name": 'Diabetes', "value": false},
          {"name": 'Blood Disorders', "value": false},
          {"name": 'Seizures/Convulsion', "value": false},
          {"name": 'Arthritis', "value": false},
          {"name": 'Psychiatric Problems', "value": false},
        ]);

  toggleValue(int index) {
    state[index]["value"] = !state[index]["value"];
  }

  updateState(List<Map<String, dynamic>> list) {
    state = list;
  }
}
