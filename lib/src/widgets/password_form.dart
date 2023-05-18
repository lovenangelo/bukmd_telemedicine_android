// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:bukmd_telemedicine/src/features/authentication/controllers/auth_view_models.dart';
import 'package:bukmd_telemedicine/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PasswordForm extends ConsumerWidget {
  const PasswordForm(
      {Key? key,
      required this.underlineBorder,
      required this.formText,
      required this.hideUnhideText,
      this.isConfirmPasswordForm = false})
      : super(key: key);
  final bool underlineBorder;
  final String formText;
  final bool hideUnhideText;
  final bool isConfirmPasswordForm;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isVisible = ref.watch(passwordObscurationProvider);
    final password = ref.watch(passwordProvider);
    final confirmPassword = ref.watch(confirmPasswordProvider);
    return Column(
      children: [
        TextFormField(
          cursorColor: primaryColor,
          obscureText: isConfirmPasswordForm ? true : !isVisible,
          decoration: InputDecoration(
            labelText: formText,
            border: underlineBorder ? const UnderlineInputBorder() : null,
            focusedBorder:
                underlineBorder ? const UnderlineInputBorder() : null,
            suffixIcon: hideUnhideText || password.isEmpty
                ? null
                : IconButton(
                    onPressed: () {
                      ref
                          .read(passwordObscurationProvider.notifier)
                          .toggleVisibility();
                    },
                    icon: isVisible
                        ? const Icon(
                            Icons.visibility_off,
                            color: primaryColor,
                          )
                        : const Icon(
                            Icons.visibility,
                            color: primaryColor,
                          ),
                  ),
          ),
          onChanged: (value) {
            if (isConfirmPasswordForm) {
              ref.read(confirmPasswordProvider.notifier).setPassword(value);
            } else {
              ref.read(passwordProvider.notifier).setPassword(value);
            }
          },
          validator: isConfirmPasswordForm
              ? (value) {
                  if (value == null || value.isEmpty)
                    return 'Please enter a password';

                  if (password != confirmPassword)
                    return 'Passwords do not match';

                  return null;
                }
              : (value) {
                  if (value == null || value.isEmpty)
                    return 'Please enter a password';

                  if (value.length < 8)
                    return 'Password should be at least 8 characters';

                  return null;
                },
        ),
      ],
    );
  }
}
