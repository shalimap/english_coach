import '/config/color.dart';
import 'package:flutter/material.dart';

import 'text_field_container.dart';

class RoundedPasswordField extends StatefulWidget {
  final ValueChanged<String>? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final String? hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  const RoundedPasswordField(
      {Key? key,
      this.onFieldSubmitted,
      this.textInputAction,
      this.hintText,
      this.controller,
      this.validator,
      this.focusNode})
      : super(key: key);

  @override
  _RoundedPasswordFieldState createState() => _RoundedPasswordFieldState();
}

class _RoundedPasswordFieldState extends State<RoundedPasswordField> {
  bool _obscureText = true;
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        controller: widget.controller,
        validator: widget.validator,
        textInputAction: widget.textInputAction,
        obscureText: _obscureText,
        focusNode: widget.focusNode,
        onFieldSubmitted: widget.onFieldSubmitted,
        cursorColor: primaryColor,
        decoration: InputDecoration(
          hintText: widget.hintText,
          prefixIcon: Icon(
            Icons.lock,
            color: accentcolor,
          ),
          suffixIcon: GestureDetector(
            child: !_obscureText
                ? Icon(
                    Icons.visibility,
                    color: accentcolor,
                  )
                : Icon(
                    Icons.visibility_off,
                    color: accentcolor,
                  ),
            onTap: _toggle,
          ),
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
