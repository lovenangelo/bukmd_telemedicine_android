import 'package:bukmd_telemedicine/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BasicInformationForm extends ConsumerStatefulWidget {
  const BasicInformationForm(
      {Key? key,
      this.keyboardType = TextInputType.text,
      required this.labelText,
      required this.validator,
      required this.data,
      required this.controller})
      : super(key: key);

  final TextInputType keyboardType;
  final String labelText;
  final String? Function(String?)? validator;
  final String? data;
  final TextEditingController controller;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BasicInformationFormState();
}

class _BasicInformationFormState extends ConsumerState<BasicInformationForm> {
  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      initialValue: widget.data ?? '',
      keyboardType: widget.keyboardType,
      cursorColor: primaryColor,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        labelText: widget.labelText,
        border: const UnderlineInputBorder(),
        focusedBorder: const UnderlineInputBorder(),
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: widget.validator,
    );
  }
}
