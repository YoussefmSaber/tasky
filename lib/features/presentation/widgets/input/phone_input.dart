import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:tasky/core/core.dart';

/// A widget that provides an input field for international phone numbers.
class PhoneInput extends StatelessWidget {
  /// Controller for the phone number input field.
  final TextEditingController controller;
  final String? Function(String?) validator;

  /// Creates a [PhoneInput] widget.
  ///
  /// The [controller] parameter must not be null.
  const PhoneInput(
      {super.key, required this.controller, required this.validator});

  @override
  Widget build(BuildContext context) {
    /// Initial phone number value with default dial code and ISO code.
    PhoneNumber initialValue =
        PhoneNumber(phoneNumber: "", dialCode: "+20", isoCode: "EG");

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
          border: Border.all(color: AppColors.secondaryTextColor),
          borderRadius: BorderRadius.circular(8)),
      child: InternationalPhoneNumberInput(
        initialValue: initialValue,
        keyboardType: TextInputType.number,
        inputBorder: WidgetStyles.borderStyle,
        validator: validator,
        onInputChanged: (PhoneNumber value) {
          controller.text = value.phoneNumber!;
        },
        formatInput: false,
        selectorConfig: const SelectorConfig(
            selectorType: PhoneInputSelectorType.DIALOG, trailingSpace: false),
        inputDecoration: InputDecoration(
            contentPadding: const EdgeInsets.only(bottom: 12),
            border: InputBorder.none,
            hintText: "123 456-7890",
            hintStyle: FontStyles.hintTextStyle),
      ),
    );
  }
}
