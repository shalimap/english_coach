import 'package:englishcoach/config/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'text_field_container.dart';

class RoundedInputField extends StatelessWidget {
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;
  final String? hintText;
  final TextInputType? keyboard;
  final IconData? icon;
  final ValueChanged<String>? onFieldSubmitted;
  const RoundedInputField(
      {Key? key,
      this.hintText,
      this.keyboard,
      this.icon = Icons.person_pin,
      this.onFieldSubmitted,
      this.validator,
      this.controller,
      this.textInputAction,
      this.focusNode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        validator: validator,
        controller: controller,
        textInputAction: textInputAction,
        focusNode: focusNode,
        keyboardType: keyboard,
        onFieldSubmitted: onFieldSubmitted,
        cursorColor: primaryColor,
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: accentcolor,
          ),
          hintText: hintText,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(29),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: accentcolor),
            borderRadius: BorderRadius.circular(29),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.redAccent),
            borderRadius: BorderRadius.circular(29),
          ),
        ),
      ),
    );
  }
}
