import 'package:flutter/material.dart';

/// Standard text input field for Sportify forms.
class SportifyTextField extends StatelessWidget {
  const SportifyTextField({
    required this.label,
    super.key,
    this.controller,
    this.hint,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
  });

  /// Controls the text being edited.
  final TextEditingController? controller;

  /// Label shown above the field or inline when empty.
  final String label;

  /// Hint text shown when empty.
  final String? hint;

  /// Type of keyboard to display.
  final TextInputType? keyboardType;

  /// Whether to hide the text (e.g. for passwords).
  final bool obscureText;

  /// Validator function for form fields.
  final String? Function(String?)? validator;

  /// Icon shown before the input text.
  final Widget? prefixIcon;

  /// Icon shown after the input text.
  final Widget? suffixIcon;

  /// Callback when text changes.
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
