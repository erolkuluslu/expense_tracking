import 'package:flutter/material.dart';

import 'package:expense_tracking/core/theme/pallete.dart';

class LoginField extends StatelessWidget {
  const LoginField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.onTap,
    this.isEmail,
  });
  final String hintText;
  final TextEditingController controller;
  final VoidCallback onTap;
  final bool? isEmail;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 400,
      ),
      child: TextFormField(
        controller: controller,
        onTap: onTap,
        keyboardType: isEmail == true
            ? TextInputType
                .emailAddress // Shows email keyboard if isEmail is true
            : TextInputType
                .text, // Default keyboard if isEmail is false or null
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(27),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Pallete.borderColor,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Pallete.gradient2,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          hintText: hintText,
        ),
      ),
    );
  }
}
