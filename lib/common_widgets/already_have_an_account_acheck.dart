import '/config/color.dart';
import '/localization/language_constants.dart';
import 'package:flutter/material.dart';

class AlreadyHaveAnAccountCheck extends StatelessWidget {
  final void Function()? press;
  const AlreadyHaveAnAccountCheck({
    Key? key,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          getTranslated(context, 'already'),
          style: TextStyle(color: Colors.black),
        ),
        Flexible(
          child: GestureDetector(
            onTap: press,
            child: Text(
              getTranslated(context, 'login'),
              style: TextStyle(
                color: accentcolor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        )
      ],
    );
  }
}
