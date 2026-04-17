import 'package:flutter/material.dart';

class FieldContainer extends StatelessWidget {
  final Widget? child;
  const FieldContainer({
    Key? key,
    this.child,
  }) : super(key: key);

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(color: Colors.grey[400]!, width: 0.5),
      borderRadius: BorderRadius.all(
          Radius.circular(29) //         <--- border radius here
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: size.width * 0.83,

      decoration: myBoxDecoration(),
      // decoration: BoxDecoration(
      //   color: kPrimaryLightColor,
      //   borderRadius: BorderRadius.circular(29),
      // ),
      child: child,
    );
  }
}
