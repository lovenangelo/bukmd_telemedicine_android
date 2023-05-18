import 'package:bukmd_telemedicine/src/constants/strings.dart';
import 'package:bukmd_telemedicine/src/features/authentication/controllers/auth_view_models.dart';
import 'package:bukmd_telemedicine/src/theme/theme.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmailForm extends ConsumerWidget {
  const EmailForm({Key? key, this.underlineBorder = false}) : super(key: key);
  final bool underlineBorder;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool underlineBorder = this.underlineBorder;
    final email = ref.watch(emailProvider);
    return TextFormField(
      cursorColor: primaryColor,
      decoration: InputDecoration(
        labelText: Strings.email,
        border: underlineBorder ? const UnderlineInputBorder() : null,
        focusedBorder: underlineBorder ? const UnderlineInputBorder() : null,
      ),
      onChanged: (value) =>
          {ref.read(emailProvider.notifier).setEmail(value.trim())},
      validator: (value) {
        // if (underlineBorder) {
        //   if (!validateEmail(email)) {
        //     return 'Please use BukSU Institutional Email';
        //   }
        // }
        if (value == null || value.isEmpty) {
          return 'Please enter an email';
        }
        if (!EmailValidator.validate(email)) {
          return 'Enter a valid email address';
        }
        return null;
      },
    );
  }
}

// bool checkIfInstitutionalEmail(String email) {
//   if (('@'.allMatches(email).length != 1)) {
//     return false;
//   }
//   return email.contains('@student.buksu.edu.ph');
// }

// bool validateEmail(String email) {
//   RegExp regex = RegExp(r'^\d{10}@student.buksu.edu.ph$');
//   return regex.hasMatch(email);
// }
