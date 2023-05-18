import 'package:flutter_riverpod/flutter_riverpod.dart';

final immunizationHistoryIllnessListProvider = StateNotifierProvider<
    ImmunizationHistoryIllnessList, List<Map<String, dynamic>>>(
  (ref) {
    return ImmunizationHistoryIllnessList();
  },
);

class ImmunizationHistoryIllnessList
    extends StateNotifier<List<Map<String, dynamic>>> {
  ImmunizationHistoryIllnessList()
      : super([
          {"name": 'BCG', "value": false},
          {"name": 'Hepatitis A', "value": false},
          {"name": 'Hepatitis B', "value": false},
          {"name": 'Pneumonococcal Vax', "value": false},
          {"name": 'Poilio Vax', "value": false},
          {"name": 'Chickenpox', "value": false},
          {"name": 'Diptheria/Pertussis/Tetanus', "value": false},
          {"name": 'Anti-Rabies Vax', "value": false},
          {"name": 'Measles/Mumps/Rubella', "value": false},
          {"name": 'Tetanus toxoid/booster', "value": false},
          {"name": 'I cannot recall', "value": false},
          {"name": 'I have no information', "value": false},
          {"name": 'I am against vaccination', "value": false},
        ]);

  toggleValue(int index) {
    state[index]["value"] = !state[index]["value"];
  }

  updateState(List<Map<String, dynamic>> list) {
    state = list;
  }
}
