import 'dart:developer';

import 'package:bukmd_telemedicine/src/features/profiling/application/checkboxes/personal_social_history_checkboxes.dart';
import 'package:bukmd_telemedicine/src/features/profiling/application/personal_social_history_form_provider.dart';

import 'package:bukmd_telemedicine/src/features/profiling/models/personal_social_history.dart';
import 'package:bukmd_telemedicine/src/theme/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:validatorless/validatorless.dart';

import '../../../widgets/remove_screen_keyboard.dart';
import '../../../widgets/snackbar.dart';
import '../../../widgets/title_container.dart';

import '../application/students_firestore_controller.dart';

class PersonalSocialHistoryLVScreen extends ConsumerStatefulWidget {
  const PersonalSocialHistoryLVScreen(
      {Key? key, required this.pageController, required this.data})
      : super(key: key);
  final PageController pageController;
  final PersonalSocialHistory? data;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PersonalSocialHistoryLVScreenState();
}

class _PersonalSocialHistoryLVScreenState
    extends ConsumerState<PersonalSocialHistoryLVScreen> {
  bool hasAllergies = false;
  bool isSmoker = false;
  bool isDrinker = false;
  bool isTakingMedicationsRegularly = false;

  final _formKey = GlobalKey<FormState>();
  final _studentsFirestore = StudentsFirestoreController();

  final _foodTextController = TextEditingController();
  final _medicationsTextController = TextEditingController();
  final _yearStartedSmokingTextController = TextEditingController();
  final _numOfSticksPerDayTextController = TextEditingController();
  final _howOftenDrinksTextController = TextEditingController();
  final _isTakingMedicationsRegularlyTextController = TextEditingController();

  @override
  void initState() {
    initializeFields();
    super.initState();
  }

  void initializeFields() async {
    if (widget.data == null) return;
    _foodTextController.text =
        widget.data!.foodAllergies == 'none' ? '' : widget.data!.foodAllergies;
    _medicationsTextController.text = widget.data!.medicationAllergies == 'none'
        ? ''
        : widget.data!.medicationAllergies;
    _yearStartedSmokingTextController.text =
        widget.data!.yearStartedSmoking == 'none'
            ? ''
            : widget.data!.yearStartedSmoking;
    _numOfSticksPerDayTextController.text =
        widget.data!.numberOfSticksPerDay == 0
            ? '0'
            : widget.data!.numberOfSticksPerDay.toString();
    _howOftenDrinksTextController.text = widget.data!.howOftenDrinks == 'none'
        ? ''
        : widget.data!.howOftenDrinks;
    _isTakingMedicationsRegularlyTextController.text =
        widget.data!.specifiedMedication == 'none'
            ? ''
            : widget.data!.specifiedMedication;

    if (widget.data!.medicationAllergies == 'none' &&
        widget.data!.foodAllergies == 'none') {
      hasAllergies = false;
    } else {
      hasAllergies = true;
    }

    widget.data!.isSmoker ? isSmoker = true : isSmoker = false;
    widget.data!.isDrinker ? isDrinker = true : isDrinker = false;
    widget.data!.isTakingMedicationsRegularly
        ? isTakingMedicationsRegularly = true
        : isTakingMedicationsRegularly = false;
  }

  @override
  void dispose() {
    _foodTextController.dispose();
    _medicationsTextController.dispose();
    _yearStartedSmokingTextController.dispose();
    _numOfSticksPerDayTextController.dispose();
    _howOftenDrinksTextController.dispose();
    _isTakingMedicationsRegularlyTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cbStates = ref.watch(personalSocialHistoryCBProvider);
    final formState = ref.watch(personalSocialHistoryFormProvider);
    // final personalSocialHistory =
    //     ref.watch(studentPersonalSocialHistoryProvider);

    forms(PersonalSocialHistoryCheckBoxes cbStates,
        PersonalSocialHistory formState) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Align(
                            alignment: Alignment.topLeft,
                            child: TitleContainer(
                              title: 'Personal-Social History',
                            ),
                          ),
                          const SizedBox(height: 32),
                          Text(
                            'Do you have allergies?',
                            style: TextStyle(
                              color: Colors.grey[30],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: CheckboxListTile(
                                  activeColor: primaryColor,
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  title: const Text(
                                    'None',
                                  ),
                                  value: !hasAllergies,
                                  onChanged: ((value) {
                                    if (value != null) {
                                      setState(() {
                                        hasAllergies = !value;
                                      });
                                    }
                                  }),
                                ),
                              ),
                              Expanded(
                                  child: CheckboxListTile(
                                      activeColor: primaryColor,
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      title: const Text(
                                        'Yes',
                                      ),
                                      value: hasAllergies,
                                      onChanged: ((value) {
                                        if (value != null) {
                                          setState(() {
                                            hasAllergies = value;
                                          });
                                        }
                                      }))),
                            ],
                          ),
                          hasAllergies
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 16),
                                    const Text(
                                      'Known Allergies',
                                      style: TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                        'Separate each allergies with a coma and leave fields empty if none.'),
                                    TextFormField(
                                      controller: _foodTextController,
                                      cursorColor: primaryColor,
                                      decoration: const InputDecoration(
                                        label: Text(
                                          'Food Allergies',
                                        ),
                                        border: UnderlineInputBorder(),
                                        focusedBorder: UnderlineInputBorder(),
                                      ),
                                      validator:
                                          _foodTextController.text.isNotEmpty ||
                                                  _medicationsTextController
                                                      .text.isNotEmpty
                                              ? null
                                              : Validatorless.required(
                                                  'This field is required'),
                                    ),
                                    TextFormField(
                                      cursorColor: primaryColor,
                                      controller: _medicationsTextController,
                                      decoration: const InputDecoration(
                                        label: Text(
                                          'Medication Allergies',
                                        ),
                                        border: UnderlineInputBorder(),
                                        focusedBorder: UnderlineInputBorder(),
                                      ),
                                      validator:
                                          _foodTextController.text.isNotEmpty ||
                                                  _medicationsTextController
                                                      .text.isNotEmpty
                                              ? null
                                              : Validatorless.required(
                                                  'This field is required'),
                                    ),
                                  ],
                                )
                              : Container(),
                          const SizedBox(height: 24),
                          // --- //
                          Text(
                            'Do you smoke?',
                            style: TextStyle(
                              color: Colors.grey[30],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: CheckboxListTile(
                                  activeColor: primaryColor,
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  title: const Text(
                                    'No',
                                  ),
                                  value: !isSmoker,
                                  onChanged: ((value) {
                                    if (value != null) {
                                      setState(() {
                                        isSmoker = !value;
                                      });
                                    }
                                  }),
                                ),
                              ),
                              Expanded(
                                  child: CheckboxListTile(
                                      activeColor: primaryColor,
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      title: const Text(
                                        'Yes',
                                      ),
                                      value: isSmoker,
                                      onChanged: ((value) {
                                        if (value != null) {
                                          setState(() {
                                            isSmoker = value;
                                          });
                                        }
                                      }))),
                            ],
                          ),
                          isSmoker
                              ? Column(
                                  children: [
                                    TextFormField(
                                      cursorColor: primaryColor,
                                      controller:
                                          _yearStartedSmokingTextController,
                                      decoration: const InputDecoration(
                                        labelText: 'Year started',
                                        border: UnderlineInputBorder(),
                                        focusedBorder: UnderlineInputBorder(),
                                      ),
                                      keyboardType: TextInputType.number,
                                      validator: isSmoker
                                          ? Validatorless.multiple([
                                              Validatorless.number(
                                                  'This field must be a number'),
                                              Validatorless.required(
                                                  'This field is required')
                                            ])
                                          : null,
                                    ),
                                    TextFormField(
                                      cursorColor: primaryColor,
                                      controller:
                                          _numOfSticksPerDayTextController,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        labelText: 'Number of sticks per day',
                                        border: UnderlineInputBorder(),
                                        focusedBorder: UnderlineInputBorder(),
                                      ),
                                      validator: isSmoker
                                          ? Validatorless.multiple([
                                              Validatorless.number(
                                                  'This field must be a number'),
                                              Validatorless.required(
                                                  'This field is required')
                                            ])
                                          : null,
                                    ),
                                  ],
                                )
                              : Container(),
                          const SizedBox(height: 24),
                          //---//
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Do you drink alcoholic beverages?',
                                style: TextStyle(
                                  color: Colors.grey[30],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: CheckboxListTile(
                                      activeColor: primaryColor,
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      title: const Text(
                                        'No',
                                      ),
                                      value: !isDrinker,
                                      onChanged: ((value) {
                                        if (value != null) {
                                          setState(() {
                                            isDrinker = !value;
                                          });
                                        }
                                      }),
                                    ),
                                  ),
                                  Expanded(
                                      child: CheckboxListTile(
                                          activeColor: primaryColor,
                                          controlAffinity:
                                              ListTileControlAffinity.leading,
                                          title: const Text(
                                            'Yes',
                                          ),
                                          value: isDrinker,
                                          onChanged: ((value) {
                                            if (value != null) {
                                              setState(() {
                                                isDrinker = value;
                                              });
                                            }
                                          }))),
                                ],
                              ),
                              isDrinker
                                  ? Column(
                                      children: [
                                        TextFormField(
                                          cursorColor: primaryColor,
                                          controller:
                                              _howOftenDrinksTextController,
                                          decoration: const InputDecoration(
                                            labelText: 'How often?',
                                            border: UnderlineInputBorder(),
                                            focusedBorder:
                                                UnderlineInputBorder(),
                                          ),
                                          validator: isDrinker
                                              ? Validatorless.required(
                                                  'This field is required')
                                              : null,
                                        ),
                                      ],
                                    )
                                  : Container(),
                            ],
                          ),
                          //---//
                          const SizedBox(height: 24),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Do you take medications regularly?',
                                style: TextStyle(
                                  color: Colors.grey[30],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: CheckboxListTile(
                                      activeColor: primaryColor,
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      title: const Text(
                                        'No',
                                      ),
                                      value: !isTakingMedicationsRegularly,
                                      onChanged: ((value) {
                                        if (value != null) {
                                          setState(() {
                                            isTakingMedicationsRegularly =
                                                !value;
                                          });
                                        }
                                      }),
                                    ),
                                  ),
                                  Expanded(
                                      child: CheckboxListTile(
                                          activeColor: primaryColor,
                                          controlAffinity:
                                              ListTileControlAffinity.leading,
                                          title: const Text(
                                            'Yes',
                                          ),
                                          value: isTakingMedicationsRegularly,
                                          onChanged: ((value) {
                                            if (value != null) {
                                              setState(() {
                                                isTakingMedicationsRegularly =
                                                    value;
                                              });
                                            }
                                          }))),
                                ],
                              ),
                              isTakingMedicationsRegularly
                                  ? Column(
                                      children: [
                                        TextFormField(
                                          cursorColor: primaryColor,
                                          controller:
                                              _isTakingMedicationsRegularlyTextController,
                                          decoration: const InputDecoration(
                                            labelText: 'Specify',
                                            border: UnderlineInputBorder(),
                                            focusedBorder:
                                                UnderlineInputBorder(),
                                          ),
                                          validator:
                                              isTakingMedicationsRegularly
                                                  ? Validatorless.required(
                                                      'This field is required')
                                                  : null,
                                        ),
                                      ],
                                    )
                                  : Container(),
                              const SizedBox(height: 24),
                              //---//
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: 50,
                                width: 100,
                                child: TextButton(
                                  onPressed: () async {
                                    removeKeyboard();

                                    if (_formKey.currentState!.validate()) {
                                      EasyLoading.show(status: 'loading...');
                                      try {
                                        // snackBar(context, 'Saving...', Colors.green);
                                        ref
                                            .read(
                                                personalSocialHistoryFormProvider
                                                    .notifier)
                                            .setHasAllergies(hasAllergies);
                                        ref
                                            .read(
                                                personalSocialHistoryFormProvider
                                                    .notifier)
                                            .setFoodAllergies(
                                                _foodTextController.text.isEmpty
                                                    ? 'none'
                                                    : _foodTextController.text);
                                        ref
                                            .read(
                                                personalSocialHistoryFormProvider
                                                    .notifier)
                                            .setMedicationAllergies(
                                                _medicationsTextController
                                                        .text.isEmpty
                                                    ? 'none'
                                                    : _medicationsTextController
                                                        .text);
                                        ref
                                            .read(
                                                personalSocialHistoryFormProvider
                                                    .notifier)
                                            .setIsSmoker(isSmoker);
                                        ref
                                            .read(
                                                personalSocialHistoryFormProvider
                                                    .notifier)
                                            .setYearStartedSmoking(
                                                _yearStartedSmokingTextController
                                                            .text.isEmpty ||
                                                        !isSmoker
                                                    ? 'none'
                                                    : _yearStartedSmokingTextController
                                                        .text);
                                        ref
                                            .read(
                                                personalSocialHistoryFormProvider
                                                    .notifier)
                                            .setNumOfSticksPerDay(
                                                _numOfSticksPerDayTextController
                                                            .text.isEmpty ||
                                                        !isSmoker
                                                    ? 0
                                                    : int.parse(
                                                        _numOfSticksPerDayTextController
                                                            .text));
                                        ref
                                            .read(
                                                personalSocialHistoryFormProvider
                                                    .notifier)
                                            .setIsDrinker(isDrinker);
                                        ref
                                            .read(
                                                personalSocialHistoryFormProvider
                                                    .notifier)
                                            .setHowOftenDrinks(
                                                _howOftenDrinksTextController
                                                        .text.isEmpty
                                                    ? 'none'
                                                    : _howOftenDrinksTextController
                                                        .text);
                                        ref
                                            .read(
                                                personalSocialHistoryFormProvider
                                                    .notifier)
                                            .setIsTakingMedications(
                                                isTakingMedicationsRegularly);
                                        ref
                                            .read(
                                                personalSocialHistoryFormProvider
                                                    .notifier)
                                            .setSpecifiedMedication(
                                                _isTakingMedicationsRegularlyTextController
                                                        .text.isEmpty
                                                    ? 'none'
                                                    : _isTakingMedicationsRegularlyTextController
                                                        .text);
                                        await _studentsFirestore
                                            .createStudentPersonalSocialHistoryData(
                                                personalSocialHistory:
                                                    formState);
                                        EasyLoading.dismiss();
                                        final _ = ref.refresh(
                                            studentPersonalSocialHistoryProvider);
                                        await widget.pageController.nextPage(
                                            duration: const Duration(
                                                milliseconds: 100),
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
              ],
            )
          ],
        ),
      );
    }

    return Scrollbar(
      child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: 1,
          itemBuilder: (context, index) => forms(cbStates, formState)),
    );
  }
}
