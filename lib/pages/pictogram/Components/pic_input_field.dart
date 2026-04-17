import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'text_field_container.dart';

class PictInputField extends StatelessWidget {
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;
  final String? hintText;
  final TextInputType? keyboard;
  final IconData? icon;
  final Icon? icon1;
  final ValueChanged<String>? onFieldSubmitted;
  const PictInputField(
      {Key? key,
      this.hintText,
      this.keyboard,
      this.icon,
      this.icon1,
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
        autocorrect: false,
        enableSuggestions: false,
        validator: validator,
        controller: controller,
        textInputAction: textInputAction,
        focusNode: focusNode,
        keyboardType: keyboard,
        onFieldSubmitted: onFieldSubmitted,
        cursorColor: Color(0xFF6F35A5),
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: Color(0xFF56C590),
          ),
          suffixIcon: icon1,
          hintText: hintText,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(29),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF56C590)),
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
