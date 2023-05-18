import 'dart:developer';

import 'package:bukmd_telemedicine/src/features/profiling/application/checkboxes/illness_list_checkboxes.dart';
import 'package:bukmd_telemedicine/src/features/profiling/application/past_medical_history_form_provider.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:validatorless/validatorless.dart';

import '../../../theme/theme.dart';

import '../../../widgets/remove_screen_keyboard.dart';
import '../../../widgets/snackbar.dart';
import '../../../widgets/title_container.dart';
import '../application/students_firestore_controller.dart';
import '../models/past_medical_history.dart';

class PastMedicalHistoryLVScreen extends ConsumerStatefulWidget {
  const PastMedicalHistoryLVScreen(
      {Key? key, required this.pageController, required this.data})
      : super(key: key);
  final PageController pageController;
  final PastMedicalHistory? data;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PastMedicalHistoryLVScreenState();
}

class _PastMedicalHistoryLVScreenState
    extends ConsumerState<PastMedicalHistoryLVScreen> {
  final numberOfPreviousAdmissionsTextController = TextEditingController();
  final lastAdmissionTextController = TextEditingController();
  final dateOfLastOperationTextController = TextEditingController();
  final procedureTextController = TextEditingController();
  final reasonOfAdmissionTextController = TextEditingController();
  final otherIllnessTextController = TextEditingController();
  bool hasPrevIllnessesCB = false;
  bool hasPrevAdmissionsCB = false;
  bool hasPrevOperationsCB = false;
  bool hasProvidedIllnesses = false;
  bool hasProvidedOtherIllnesses = false;
  List<Map<String, dynamic>> illnessList = [];

  @override
  void initState() {
    initializeFields();
    super.initState();
  }

  void initializeFields() async {
    // final widget.data = await _studentsFirestore.readStudentPastMedicalHistory();

    if (widget.data == null) return;

    numberOfPreviousAdmissionsTextController.text =
        widget.data!.numberOfPreviousAdmissions == 'none'
            ? ''
            : widget.data!.numberOfPreviousAdmissions;
    lastAdmissionTextController.text =
        widget.data!.dateOfLastAdmission == 'none'
            ? ''
            : widget.data!.dateOfLastAdmission;
    dateOfLastOperationTextController.text =
        widget.data!.dateOfLastOperation == 'none'
            ? ''
            : widget.data!.dateOfLastOperation;
    procedureTextController.text = widget.data!.operationProcedure == 'none'
        ? ''
        : widget.data!.operationProcedure;
    reasonOfAdmissionTextController.text =
        widget.data!.reasonOfAdmission == 'none'
            ? ''
            : widget.data!.reasonOfAdmission;
    otherIllnessTextController.text =
        widget.data!.otherIllness == 'none' ? '' : widget.data!.otherIllness;

    hasPrevIllnessesCB = widget.data!.hasPreviousIllnesses;
    hasProvidedIllnesses = widget.data!.hasPreviousIllnesses;
    hasProvidedOtherIllnesses = widget.data!.otherIllness.isNotEmpty;
    hasPrevAdmissionsCB = widget.data!.hasPreviousAdmissions;
    hasPrevOperationsCB = widget.data!.hasPreviousOperations;

    illnessList = widget.data!.listOfIlllness;

    illnessList = ref.read(illnessListProvider);
  }

  @override
  void dispose() {
    numberOfPreviousAdmissionsTextController.dispose();
    lastAdmissionTextController.dispose();
    dateOfLastOperationTextController.dispose();
    procedureTextController.dispose();
    reasonOfAdmissionTextController.dispose();
    otherIllnessTextController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  final _studentsFirestore = StudentsFirestoreController();

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(pastMedicalHistoryFormProvider);
    final list = ref.watch(illnessListProvider);

    forms() => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TitleContainer(
                  title: 'Past Medical History',
                ),
                const SizedBox(height: 32),
                Text(
                  'Do you have previous illnesses?',
                  style: TextStyle(
                    color: Colors.grey[30],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: CheckboxListTile(
                          activeColor: primaryColor,
                          controlAffinity: ListTileControlAffinity.leading,
                          title: const Text(
                            'None',
                          ),
                          value: (!hasPrevIllnessesCB),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                hasPrevIllnessesCB = !value;
                                setState(() {
                                  for (var element in list) {
                                    hasProvidedIllnesses =
                                        element.containsValue(true);
                                    if (hasProvidedIllnesses) return;
                                  }
                                });
                              });
                            }
                          }),
                    ),
                    Expanded(
                      child: CheckboxListTile(
                          activeColor: primaryColor,
                          controlAffinity: ListTileControlAffinity.leading,
                          title: const Text(
                            'Yes',
                          ),
                          value: (hasPrevIllnessesCB),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                hasPrevIllnessesCB = value;

                                for (var element in list) {
                                  hasProvidedIllnesses =
                                      element.containsValue(true);
                                  if (hasProvidedIllnesses) return;
                                }
                                log(hasProvidedIllnesses.toString());
                              });
                            }
                          }),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                hasPrevIllnessesCB
                    ? Column(
                        children: [
                          FormField(
                            builder: ((field) {
                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.black54),
                                        ),
                                        child: illnessCheckboxes(illnessList)),
                                  ),
                                  field.errorText != null
                                      ? Text(
                                          field.errorText!,
                                          style: TextStyle(
                                            color: Theme.of(context).errorColor,
                                            fontSize: 12,
                                          ),
                                        )
                                      : Container(),
                                ],
                              );
                            }),
                            validator: (_) {
                              if (!hasProvidedIllnesses &&
                                  otherIllnessTextController.text.isEmpty) {
                                return 'Check the illnesses that you had previously';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                              cursorColor: primaryColor,
                              controller: otherIllnessTextController,
                              decoration: const InputDecoration(
                                labelText: 'Other',
                                border: UnderlineInputBorder(),
                                focusedBorder: UnderlineInputBorder(),
                              ),
                              onChanged: (_) {
                                setState(() {});
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: !hasProvidedIllnesses &&
                                      otherIllnessTextController.text.isNotEmpty
                                  ? Validatorless.required(
                                      'This field is required')
                                  : null),
                        ],
                      )
                    : Container(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Text(
                      'Do you have previous admissions?',
                      style: TextStyle(
                        color: Colors.grey[30],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CheckboxListTile(
                              activeColor: primaryColor,
                              controlAffinity: ListTileControlAffinity.leading,
                              title: const Text(
                                'None',
                              ),
                              value: (!hasPrevAdmissionsCB),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    hasPrevAdmissionsCB = !value;
                                  });
                                }
                              }),
                        ),
                        Expanded(
                          child: CheckboxListTile(
                            activeColor: primaryColor,
                            controlAffinity: ListTileControlAffinity.leading,
                            title: const Text(
                              'Yes',
                            ),
                            value: (hasPrevAdmissionsCB),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  hasPrevAdmissionsCB = value;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    hasPrevAdmissionsCB
                        ? Column(
                            children: [
                              TextFormField(
                                cursorColor: primaryColor,
                                controller:
                                    numberOfPreviousAdmissionsTextController,
                                decoration: const InputDecoration(
                                  labelText: 'No. of previous admissions',
                                  border: UnderlineInputBorder(),
                                  focusedBorder: UnderlineInputBorder(),
                                ),
                                onChanged: (_) {
                                  // setState(() {});
                                },
                                validator: hasPrevAdmissionsCB
                                    ? _isEmptyValidator
                                    : null,
                              ),
                              TextFormField(
                                cursorColor: primaryColor,
                                controller: lastAdmissionTextController,
                                decoration: const InputDecoration(
                                  labelText: 'Date of last admission',
                                  border: UnderlineInputBorder(),
                                  focusedBorder: UnderlineInputBorder(),
                                ),
                                onChanged: (_) {
                                  setState(() {});
                                },
                                validator: hasPrevAdmissionsCB
                                    ? _isEmptyValidator
                                    : null,
                              ),
                              TextFormField(
                                cursorColor: primaryColor,
                                controller: reasonOfAdmissionTextController,
                                decoration: const InputDecoration(
                                  labelText: 'Reason of admission',
                                  border: UnderlineInputBorder(),
                                  focusedBorder: UnderlineInputBorder(),
                                ),
                                onChanged: (_) {
                                  setState(() {});
                                },
                                validator: hasPrevAdmissionsCB
                                    ? _isEmptyValidator
                                    : null,
                              ),
                            ],
                          )
                        : Container(),
                    const SizedBox(height: 16),
                    Text(
                      'Do you have previous operations?',
                      style: TextStyle(
                        color: Colors.grey[30],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CheckboxListTile(
                              activeColor: primaryColor,
                              controlAffinity: ListTileControlAffinity.leading,
                              title: const Text(
                                'None',
                              ),
                              value: (!hasPrevOperationsCB),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    hasPrevOperationsCB = !value;
                                  });
                                }
                              }),
                        ),
                        Expanded(
                          child: CheckboxListTile(
                              activeColor: primaryColor,
                              controlAffinity: ListTileControlAffinity.leading,
                              title: const Text(
                                'Yes',
                              ),
                              value: (hasPrevOperationsCB),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    hasPrevOperationsCB = value;
                                  });
                                }
                              }),
                        ),
                      ],
                    ),
                    hasPrevOperationsCB
                        ? Column(
                            children: [
                              TextFormField(
                                cursorColor: primaryColor,
                                controller: dateOfLastOperationTextController,
                                decoration: const InputDecoration(
                                  labelText: 'Date',
                                  border: UnderlineInputBorder(),
                                  focusedBorder: UnderlineInputBorder(),
                                ),
                                onChanged: (_) {
                                  setState(() {});
                                },
                                validator: hasPrevOperationsCB
                                    ? _isEmptyValidator
                                    : null,
                              ),
                              TextFormField(
                                cursorColor: primaryColor,
                                controller: procedureTextController,
                                decoration: const InputDecoration(
                                  labelText: 'Procedure',
                                  border: UnderlineInputBorder(),
                                  focusedBorder: UnderlineInputBorder(),
                                ),
                                onChanged: (_) {
                                  setState(() {});
                                },
                                validator: hasPrevOperationsCB
                                    ? _isEmptyValidator
                                    : null,
                              ),
                            ],
                          )
                        : Container(),
                    const SizedBox(height: 24),
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
                              )),
                        ),
                        SizedBox(
                          height: 50,
                          width: 100,
                          child: TextButton(
                            onPressed: () async {
                              removeKeyboard();
                              if (_formKey.currentState!.validate()) {
                                EasyLoading.show(status: 'loading...');

                                try {
                                  // snackBar(
                                  //     context, 'Saving...', Colors.green);
                                  ref
                                      .read(pastMedicalHistoryFormProvider
                                          .notifier)
                                      .setHasPreviousIllness(
                                          hasPrevIllnessesCB);
                                  ref
                                      .read(pastMedicalHistoryFormProvider
                                          .notifier)
                                      .setHasPreviousAdmissions(
                                          hasPrevAdmissionsCB);
                                  ref
                                      .read(pastMedicalHistoryFormProvider
                                          .notifier)
                                      .setHasPreviousOperations(
                                          hasPrevOperationsCB);
                                  ref
                                      .read(pastMedicalHistoryFormProvider
                                          .notifier)
                                      .setDateOfLastAdmission(
                                          lastAdmissionTextController
                                                  .text.isEmpty
                                              ? 'none'
                                              : lastAdmissionTextController
                                                  .text);
                                  ref
                                      .read(pastMedicalHistoryFormProvider
                                          .notifier)
                                      .setDateOfLastOperation(
                                          dateOfLastOperationTextController
                                                  .text.isEmpty
                                              ? 'none'
                                              : dateOfLastOperationTextController
                                                  .text);
                                  ref
                                      .read(pastMedicalHistoryFormProvider
                                          .notifier)
                                      .setNumberOfPreviousAdmissions(
                                          numberOfPreviousAdmissionsTextController
                                                  .text.isEmpty
                                              ? 'none'
                                              : numberOfPreviousAdmissionsTextController
                                                  .text);
                                  ref
                                      .read(pastMedicalHistoryFormProvider
                                          .notifier)
                                      .setOperationProcedure(
                                          procedureTextController.text.isEmpty
                                              ? 'none'
                                              : procedureTextController.text);

                                  ref
                                      .read(pastMedicalHistoryFormProvider
                                          .notifier)
                                      .setReasonOfAdmission(
                                          reasonOfAdmissionTextController
                                                  .text.isEmpty
                                              ? 'none'
                                              : reasonOfAdmissionTextController
                                                  .text);
                                  ref
                                      .read(pastMedicalHistoryFormProvider
                                          .notifier)
                                      .setOtherIllness(
                                          otherIllnessTextController
                                                  .text.isEmpty
                                              ? 'none'
                                              : otherIllnessTextController
                                                  .text);

                                  log(illnessList.toString());

                                  if (!hasPrevIllnessesCB) {
                                    illnessList = illnessList.map((illness) {
                                      return {
                                        "name": illness["name"],
                                        "value": false
                                      };
                                    }).toList();
                                    log(illnessList.toString());
                                  }

                                  ref
                                      .read(pastMedicalHistoryFormProvider
                                          .notifier)
                                      .setListOfIllness(illnessList);

                                  await _studentsFirestore
                                      .createStudentPastMedicalHistoryData(
                                          pastMedicalHistory: formState);
                                  EasyLoading.dismiss();
                                  final _ = ref.refresh(
                                      studentPastMedicalHistoryProvider);
                                  await widget.pageController.nextPage(
                                      duration:
                                          const Duration(milliseconds: 100),
                                      curve: Curves.easeInOut);
                                } on FirebaseException catch (e) {
                                  EasyLoading.dismiss();

                                  snackBar(
                                      context,
                                      'Something went wrong, try again later',
                                      Colors.red);
                                  print(e.toString());
                                }
                              }
                            },
                            child: const Text(
                              'Next',
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );

    return Scrollbar(
      child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: 1,
          itemBuilder: (context, index) => forms()),
    );
  }

  GridView illnessCheckboxes(List<Map<String, dynamic>> data) {
    List<String> namesList = data.map((e) => e["name"].toString()).toList();
    List valuesList = data.map((e) => e["value"]).toList();
    final list = ref.watch(illnessListProvider);
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
                  ref.read(illnessListProvider.notifier).toggleValue(index);
                  setState(() {
                    for (var element in list) {
                      hasProvidedIllnesses = element.containsValue(true);
                      if (hasProvidedIllnesses) return;
                    }
                  });
                  log(hasProvidedIllnesses.toString());
                }),
          );
        }));
  }

  String? _isEmptyValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Don't leave this field empty";
    } else {
      return null;
    }
  }
}
