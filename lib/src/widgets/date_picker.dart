import 'package:bukmd_telemedicine/src/features/profiling/application/student_info_form_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DatePicker extends ConsumerStatefulWidget {
  const DatePicker({Key? key, required this.studentBirthDay}) : super(key: key);
  final String? studentBirthDay;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DatePickerState();
}

class _DatePickerState extends ConsumerState<DatePicker> {
  String? dateSlash;
  Map datePickerResult = {'userBirthDate': String, 'isLegal': false};
  TextEditingController datePickerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.studentBirthDay == null || widget.studentBirthDay!.isEmpty
        ? datePickerController.text = ''
        : datePickerController.text = widget.studentBirthDay!;
  }

  @override
  void dispose() {
    super.dispose();
    datePickerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future pickDateRange() async {
      DateTime? datePick = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
      );
      if (datePick == null) return;
      datePickerController.text = datePick.toString().substring(0, 10).trim();

      ref
          .read(studentInformationFormProvider.notifier)
          .setBirthDate(datePickerController.text);
    }

    return TextFormField(
      controller: datePickerController,
      onTap: () async {
        await pickDateRange();
      },
      decoration: const InputDecoration(
        labelText: 'Date of birth',
        border: UnderlineInputBorder(),
        focusedBorder: UnderlineInputBorder(),
      ),
      validator: dateValidator,
    );
  }
}

String? dateValidator(String? value) {
  if (value == null || value.isEmpty) {
    return "Don't leave this field empty";
  } else {
    return null;
  }
}
