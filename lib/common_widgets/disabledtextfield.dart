import 'package:englishcoach/config/color.dart';
import 'package:flutter/material.dart';

import 'profiletextfieldcontainer.dart';

class DisabledInputField extends StatefulWidget {
  final ValueChanged<String>? onFieldSubmitted;
  final Widget? child;
  final String? hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final IconData? icon;
  const DisabledInputField(
      {Key? key,
      this.onFieldSubmitted,
      this.hintText,
      this.controller,
      this.validator,
      this.child,
      this.icon})
      : super(key: key);

  @override
  _DisabledInputFieldState createState() => _DisabledInputFieldState();
}

class _DisabledInputFieldState extends State<DisabledInputField> {
  // bool _enabled = false;
  // void _toggle() {
  //   setState(() {
  //     _enabled = !_enabled;
  //   });
  // }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    return ProfileFieldContainer(
      child: TextFormField(
        enabled: false,
        controller: widget.controller,
        validator: widget.validator,
        onFieldSubmitted: widget.onFieldSubmitted,
        cursorColor: primaryColor,
        decoration: InputDecoration(
          hintText: widget.hintText,
          prefixIcon: Icon(
            widget.icon,
            color: accentcolor,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
