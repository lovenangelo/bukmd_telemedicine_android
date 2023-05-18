import 'package:flutter_riverpod/flutter_riverpod.dart';

final illnessListProvider =
    StateNotifierProvider<IllnessListCB, List<Map<String, dynamic>>>(
  (ref) {
    return IllnessListCB();
  },
);

class IllnessListCB extends StateNotifier<List<Map<String, dynamic>>> {
  IllnessListCB()
      : super([
          {"name": 'Asthma', "value": false},
          {"name": 'Pneumonia', "value": false},
          {"name": 'Chickenpox', "value": false},
          {"name": 'Hepatitis', "value": false},
          {"name": 'Heart Problems', "value": false},
          {"name": 'Typhoid Fever', "value": false},
          {"name": 'Measles', "value": false},
          {"name": 'Urinary Tract Infections', "value": false},
          {"name": 'Seizures/Convulsion', "value": false},
          {"name": 'Tuberculosis', "value": false},
          {"name": 'German Measles', "value": false},
        ]);

  toggleValue(int index) {
    state[index]["value"] = !state[index]["value"];
  }
}
