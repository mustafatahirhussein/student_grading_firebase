import 'package:flutter/material.dart';

class SgFormFields extends TextFormField {
  SgFormFields.border({
    super.key,
    required TextEditingController controller,
    required String hint,
    Widget? prefix,
    suffix,
    TextInputType? inputType,
    bool obscure = false,
  }) : super(
            obscureText: obscure,
            controller: controller,
            keyboardType: inputType,
            decoration: InputDecoration(
              hintText: hint,
              suffixIcon: suffix,
              prefixIcon: prefix,
            ));
}
