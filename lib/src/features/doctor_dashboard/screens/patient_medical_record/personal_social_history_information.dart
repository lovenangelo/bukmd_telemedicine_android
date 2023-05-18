import 'package:bukmd_telemedicine/src/theme/theme.dart';
import 'package:bukmd_telemedicine/src/widgets/divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/presentation/error_page.dart';
import '../../application/medical_record/medical_record_provider.dart';

class PersonalSocialHistoryInformation extends ConsumerStatefulWidget {
  const PersonalSocialHistoryInformation({Key? key, required this.id})
      : super(key: key);
  final String id;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PersonalSocialHistoryInformationState();
}

class _PersonalSocialHistoryInformationState
    extends ConsumerState<PersonalSocialHistoryInformation> {
  @override
  Widget build(BuildContext context) {
    final personalSocialHistory =
        ref.watch(personalSocialHistoryMRProvider(widget.id));
    return personalSocialHistory.when(
        data: (data) {
          return data == null
              ? Column(
                  children: const [
                    SizedBox(
                      height: 8,
                    ),
                    Text('Did not provide data yet'),
                    SizedBox(height: 16),
                  ],
                )
              : body(data);
        },
        error: (e, st) {
          return const Expanded(child: ErrorPage(isNoInternetError: false));
        },
        loading: () => const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Center(
                child: SizedBox(
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator(color: primaryColor)),
              ),
            ));
  }

  body(PatientMedicalRecord data) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(color: Colors.orange[50]),
            child: Column(
              children: [
                const Text(
                  'Personal-Social History',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
                const SizedBox(height: 16.0),
                yesOrNoData('SMOKES', data.psh!.isSmoker),
                data.psh!.isSmoker
                    ? Column(
                        children: [
                          const SizedBox(height: 4.0),
                          Row(
                            children: [
                              const Text(
                                'YEAR STARTED: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Container(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  color: Colors.greenAccent,
                                  child: Text(data.psh!.yearStartedSmoking)),
                            ],
                          ),
                          const SizedBox(height: 4.0),
                          Row(
                            children: [
                              const Text(
                                'STICKS PER DAY: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Container(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  color: Colors.greenAccent,
                                  child: Text(data.psh!.numberOfSticksPerDay
                                      .toString())),
                            ],
                          ),
                        ],
                      )
                    : Container(),
                horizontalDivider,
                yesOrNoData('DRINKS ALCOHOLIC BEVERAGES', data.psh!.isDrinker),
                data.psh!.isDrinker
                    ? Column(
                        children: [
                          const SizedBox(height: 4),
                          listData('FREQUENCY', data.psh!.howOftenDrinks),
                        ],
                      )
                    : Container(),
                horizontalDivider,
                data.psh!.hasAllergies
                    ? Column(
                        children: [
                          listData('FOOD ALLERGIES', data.psh!.foodAllergies),
                          const SizedBox(height: 16),
                          listData('MEDICATION ALLERGIES',
                              data.psh!.medicationAllergies),
                        ],
                      )
                    : listData('ALLERGIES', 'none'),
                horizontalDivider,
                listData('REGULAR MEDICATIONS', data.psh!.specifiedMedication),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 64.0),
            child: horizontalDivider,
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(color: Colors.orange[50]),
            child: Column(
              children: [
                const Text(
                  'Past Medical History',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline),
                ),
                const SizedBox(height: 16),
                listData(
                    'PREVIOUS ILLNESS',
                    data.pmh!.listOfIlllness
                            .every((element) => element.values.contains(true))
                        ? data.pmh!.listOfIlllness
                            .map((element) => element['name'])
                            .toList()
                            .join(', ')
                        : 'none'),
                const SizedBox(height: 16),
                data.pmh!.hasPreviousAdmissions
                    ? Column(
                        children: [
                          listData('NO. OF PREVIOUS ADMISSIONS',
                              data.pmh!.numberOfPreviousAdmissions),
                          const SizedBox(height: 16),
                          listData('DATE', data.pmh!.dateOfLastAdmission),
                        ],
                      )
                    : listData('PREVOUS ADMISSIONS', 'none'),
                const SizedBox(height: 16),
                data.pmh!.hasPreviousOperations
                    ? Column(
                        children: [
                          listData('PROCEDURE OF PREVIOUS ADMISSIONS',
                              data.pmh!.operationProcedure),
                          const SizedBox(height: 16),
                          listData('DATE', data.pmh!.dateOfLastOperation),
                        ],
                      )
                    : listData('PREVOUS OPERATIONS', 'none'),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 64.0),
            child: horizontalDivider,
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(color: Colors.orange[50]),
            child: Column(
              children: [
                const Text(
                  'Family History',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
                const SizedBox(height: 16),
                listData(
                    'ILLNESSES',
                    data.familyHist!
                            .every((element) => element.values.contains(true))
                        ? data.familyHist!
                            .map((element) => element['name'])
                            .toList()
                            .join(', ')
                        : 'none'),
                const SizedBox(height: 16),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 64.0),
            child: horizontalDivider,
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(color: Colors.orange[50]),
            child: Column(
              children: [
                const Text(
                  'Immunization History',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
                const SizedBox(height: 16),
                listData(
                    'IMMUNIZATIONS',
                    data.familyHist!
                            .every((element) => element.values.contains(true))
                        ? data.immunizationHist!
                            .map((element) => element['name'])
                            .toList()
                            .join(', ')
                        : 'none'),
                const SizedBox(height: 16),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

Widget yesOrNoData(String label, bool letTrue) => Row(
      children: [
        Text(
          '$label: ',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            letTrue
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    color: Colors.greenAccent,
                    child: const Text('Yes'))
                : Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    color: Colors.greenAccent,
                    child: const Text('No')),
          ],
        ),
      ],
    );

Widget listData(String label, String data) => data == 'none'
    ? Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              color: Colors.greenAccent,
              child: Text(data)),
        ],
      )
    : Align(
        alignment: Alignment.topLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$label: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                color: Colors.greenAccent,
                child: Text(data)),
          ],
        ),
      );
