import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/past_medical_history.dart';

final pastMedicalHistoryFormProvider =
    StateNotifierProvider<PastMedicalHistoryFormNotifier, PastMedicalHistory>(
        (ref) {
  return PastMedicalHistoryFormNotifier();
});

class PastMedicalHistoryFormNotifier extends StateNotifier<PastMedicalHistory> {
  PastMedicalHistoryFormNotifier()
      : super(PastMedicalHistory(
            hasPreviousIllnesses: false,
            hasPreviousAdmissions: false,
            hasPreviousOperations: false,
            numberOfPreviousAdmissions: '',
            dateOfLastAdmission: '',
            reasonOfAdmission: '',
            dateOfLastOperation: '',
            operationProcedure: '',
            otherIllness: '',
            listOfIlllness: []));

  setHasPreviousIllness(bool hasPreviousIllness) {
    state.hasPreviousIllnesses = hasPreviousIllness;
  }

  setHasPreviousAdmissions(bool hasPreviousAdmissions) {
    state.hasPreviousAdmissions = hasPreviousAdmissions;
  }

  setHasPreviousOperations(bool hasPreviousOperations) {
    state.hasPreviousOperations = hasPreviousOperations;
  }

  setNumberOfPreviousAdmissions(String numberOfPreviousAdmissions) {
    state.numberOfPreviousAdmissions = numberOfPreviousAdmissions;
  }

  setDateOfLastAdmission(String dateOfLastAdmission) {
    state.dateOfLastAdmission = dateOfLastAdmission;
  }

  setReasonOfAdmission(String reasonOfAdmission) {
    state.reasonOfAdmission = reasonOfAdmission;
  }

  setDateOfLastOperation(String dateOfLastOperation) {
    state.dateOfLastOperation = dateOfLastOperation;
  }

  setOperationProcedure(String operationProcedure) {
    state.operationProcedure = operationProcedure;
  }

  setOtherIllness(String otherIllness) {
    state.otherIllness = otherIllness;
  }

  setListOfIllness(List<Map<String, dynamic>> list) {
    state.listOfIlllness = list;
  }
}
