import 'package:bukmd_telemedicine/src/features/appointment_scheduling/application/appointment_calendar/appointment_calendar_provider.dart';
import 'package:bukmd_telemedicine/src/theme/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../widgets/remove_screen_keyboard.dart';
import '../../../widgets/snackbar.dart';
import '../../../widgets/title_container.dart';
import '../application/checkboxes/immunization_history_list_provider.dart';
import '../application/students_firestore_controller.dart';

class ImmunizationHistoryLVScreen extends ConsumerStatefulWidget {
  const ImmunizationHistoryLVScreen({Key? key, required this.pageController})
      : super(key: key);
  final PageController pageController;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ImmunizationHistoryLVScreenState();
}

class _ImmunizationHistoryLVScreenState
    extends ConsumerState<ImmunizationHistoryLVScreen> {
  final _studentsFirestore = StudentsFirestoreController();

  // @override
  // void initState() {
  //   initializeFields();
  //   super.initState();
  // }

  // void initializeFields() async {
  //   final data = await _studentsFirestore.readStudentImmunizationHistory();
  //   if (data == null) return;
  //   ref.read(immunizationHistoryIllnessListProvider.notifier).updateState(data);
  // }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> illnessList =
        ref.watch(immunizationHistoryIllnessListProvider);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TitleContainer(
              title: 'Immunization History',
            ),
            const SizedBox(height: 16),
            immunizationHistCheckboxes(illnessList),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 50,
                  width: 100,
                  child: TextButton(
                    onPressed: () async {
                      await widget.pageController.previousPage(
                          duration: const Duration(milliseconds: 100),
                          curve: Curves.easeInOut);
                    },
                    child: const Text(
                      'Back',
                      style: TextStyle(color: primaryColor),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                  width: 100,
                  child: TextButton(
                    onPressed: () async {
                      removeKeyboard();

                      try {
                        EasyLoading.show(status: 'saving...');

                        await _studentsFirestore
                            .createStudentImmunizationHistoryData(
                                immunizationHistory: illnessList);
                        await _studentsFirestore.updateHasMedicalRecord(true);
                        EasyLoading.dismiss();

                        final _ = ref.refresh(appointmentCalendarProvider);
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).removeCurrentSnackBar();
                        snackBar(
                            context,
                            'Medical record updated',
                            primaryColor,
                            const Icon(
                              Icons.check,
                              color: Colors.white,
                            ));
                      } on FirebaseException catch (e) {
                        EasyLoading.dismiss();

                        snackBar(
                            context,
                            'Something went wrong, try again later',
                            Colors.red);
                        print(e.toString());
                      }
                    },
                    child: const Text(
                      'Finish',
                      style: TextStyle(color: primaryColor),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  GridView immunizationHistCheckboxes(List<Map<String, dynamic>> data) {
    List<String> namesList = data.map((e) => e["name"].toString()).toList();
    List valuesList = data.map((e) => e["value"]).toList();
    return GridView.count(
        shrinkWrap: true,
        primary: false,
        childAspectRatio: 3.0,
        padding: EdgeInsets.zero,
        physics: const BouncingScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 0.0,
        mainAxisSpacing: 0.0,
        children: List.generate(data.length, (index) {
          return SizedBox(
            child: CheckboxListTile(
                activeColor: primaryColor,
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: const EdgeInsets.all(0),
                title: Text(
                  namesList[index],
                ),
                value: valuesList[index],
                onChanged: (value) {
                  ref
                      .read(immunizationHistoryIllnessListProvider.notifier)
                      .toggleValue(index);
                  setState(() {});
                }),
          );
        }));
  }
}
