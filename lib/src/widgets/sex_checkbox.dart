import 'package:bukmd_telemedicine/src/widgets/providers/checkbox_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SexCheckBox extends ConsumerStatefulWidget {
  const SexCheckBox({Key? key, required this.studentSex}) : super(key: key);
  final String? studentSex;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SexCheckBoxState();
}

class _SexCheckBoxState extends ConsumerState<SexCheckBox> {
  @override
  Widget build(BuildContext context) {
    String? studentSex = widget.studentSex;
    final maleCB = ref.watch(maleCheckBoxProvider(studentSex));
    final femaleCB = ref.watch(femaleCheckBoxProvider(studentSex));

    return Row(
      children: [
        Checkbox(
            activeColor: Colors.green[400],
            value: maleCB,
            onChanged: (value) {
              if (!ref.read(femaleCheckBoxProvider(studentSex))) {
                ref
                    .read(maleCheckBoxProvider(studentSex).notifier)
                    .toggleMale();
              } else {
                ref
                    .read(femaleCheckBoxProvider(studentSex).notifier)
                    .toggleFemale();
                ref
                    .read(maleCheckBoxProvider(studentSex).notifier)
                    .toggleMale();
              }
            }),
        const Text(
          'Male',
        ),
        Checkbox(
            activeColor: Colors.green[400],
            value: femaleCB,
            onChanged: (value) {
              if (!ref.read(maleCheckBoxProvider(studentSex))) {
                ref
                    .read(femaleCheckBoxProvider(studentSex).notifier)
                    .toggleFemale();
              } else {
                ref
                    .read(maleCheckBoxProvider(studentSex).notifier)
                    .toggleMale();
                ref
                    .read(femaleCheckBoxProvider(studentSex).notifier)
                    .toggleFemale();
              }
            }),
        const Text(
          'Female',
        ),
      ],
    );
  }
}
