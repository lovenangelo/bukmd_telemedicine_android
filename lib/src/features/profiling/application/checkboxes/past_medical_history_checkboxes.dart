import 'package:flutter_riverpod/flutter_riverpod.dart';

final pastMedicalHistoryCBProvider = StateNotifierProvider<
    PastMedicalHistoryCheckBoxesNotifier, PastMedicalHistoryCheckBoxes>((ref) {
  return PastMedicalHistoryCheckBoxesNotifier();
});

class PastMedicalHistoryCheckBoxesNotifier
    extends StateNotifier<PastMedicalHistoryCheckBoxes> {
  PastMedicalHistoryCheckBoxesNotifier()
      : super(PastMedicalHistoryCheckBoxes(
            hasPrevIllnesses: false,
            hasPrevAdmissions: false,
            hasPrevOperations: false));

  toggleHasPrevIllnesses() => state.hasPrevIllnesses = !state.hasPrevIllnesses;

  toggleHasPrevAdmissions() =>
      state.hasPrevAdmissions = !state.hasPrevAdmissions;

  toggleHasPrevOperations() =>
      state.hasPrevOperations = !state.hasPrevOperations;
}

class PastMedicalHistoryCheckBoxes {
  bool hasPrevIllnesses;
  bool hasPrevAdmissions;
  bool hasPrevOperations;

  PastMedicalHistoryCheckBoxes({
    required this.hasPrevIllnesses,
    required this.hasPrevAdmissions,
    required this.hasPrevOperations,
  });
}
