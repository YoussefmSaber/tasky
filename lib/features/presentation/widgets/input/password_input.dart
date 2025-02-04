import 'package:flutter/material.dart';
import 'package:tasky/core/core.dart';

/// A custom password input widget that allows toggling the visibility of the password.
class PasswordInput extends StatefulWidget {
  /// The type of input expected (e.g., text, number, email, etc.).
  final TextInputType inputType;

  /// The controller for the text input.
  final TextEditingController controller;

  /// The validator function for the input.
  final String? Function(String?) validator;

  /// Creates a [PasswordInput] widget.
  const PasswordInput({
    super.key,
    required this.controller,
    required this.inputType,
    required this.validator,
  });

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  /// Whether the password is visible or not.
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: !showPassword,
      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
      decoration: InputDecoration(
        suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                showPassword = !showPassword;
              });
            },
            icon: Icon(showPassword
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined)),
        hintText: 'Password...', // Added
        hintStyle: FontStyles.hintTextStyle,// labelText
        border: WidgetStyles.borderStyle,
        focusedBorder: WidgetStyles.borderStyle,
      ),
      keyboardType: widget.inputType,
      maxLines: 1,
      validator: widget.validator,
    );
  }
}