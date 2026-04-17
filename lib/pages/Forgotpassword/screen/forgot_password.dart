import 'package:country_code_picker/country_code_picker.dart';
import 'package:englishcoach/common_providers/users.dart';
import 'package:englishcoach/common_widgets/countrycode.dart';
import 'package:englishcoach/common_widgets/rounded_button.dart';
import 'package:englishcoach/config/color.dart';
import 'package:englishcoach/config/widgetHelper.dart';
import 'package:englishcoach/localization/language_constants.dart';
import 'package:englishcoach/pages/otp/screen/verificationpage.dart';
import 'package:englishcoach/services/authservice.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../config/responsive.dart';

class ForgotPasswordscreen extends StatefulWidget {
  static const routeName = '/forgotpassword-screen';
  const ForgotPasswordscreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordscreenState createState() => _ForgotPasswordscreenState();
}

class _ForgotPasswordscreenState extends State<ForgotPasswordscreen> {
  final _formkey = GlobalKey<FormState>();

  final _mobilecontroller = TextEditingController();
  final _emailcontroller = TextEditingController();
  var countryCode = '+91';
  final _auth = AuthServices();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<Userprovider>(builder: (context, user, child) {
      return Scaffold(
        appBar: _appBar(),
        body: _mainbody(user, size),
      );
    });
  }

  _appBar() {
    return AppBar(
      elevation: 0.0,
      leading: IconButton(
        icon: Icon(
          Icons.chevron_left,
          size: 40,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        'Forgot Password',
        style: GoogleFonts.solway(
            textStyle: TextStyle(
          fontWeight: FontWeight.bold,
        )),
      ),
      centerTitle: true,
    );
  }

  _mainbody(Userprovider user, Size size) {
    return SingleChildScrollView(
      child: Form(
        key: _formkey,
        child: Padding(
          padding: Responsive.isDesktop(context)
              ? EdgeInsets.symmetric(horizontal: size.width * 0.2)
              : const EdgeInsets.all(0.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: size.height * 0.09),
                  _gettitle(size),
                  SizedBox(height: size.height * 0.03),
                  _phonenumberField(),
                  _submitButton(user),
                  SizedBox(height: size.height * 0.03),
                ],
              ),
              SizedBox(
                  height: 500, child: WidgetHelper.getProgressBar(user.state)),
            ],
          ),
        ),
      ),
    );
  }

  _gettitle(Size size) {
    return Padding(
      padding: EdgeInsets.all(size.width * 0.05),
      child: Text(
        'Enter your Mobile Number and Email associated with your account & we will send OTP Number',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  _phonenumberField() {
    return CountryInputField(
      keyboard: TextInputType.number,
      controller: _mobilecontroller,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value!.isEmpty) {
          return getTranslated(context, 'Enter_your_mobile');
        }
        if (value.length < 7) {
          return getTranslated(context, 'Enter_valid');
        } else {
          return null;
        }
      },
      hintText: getTranslated(context, 'your_mobile'),
      onFieldSubmitted: (value) {
        _mobilecontroller.text = value;
        print(value.trim());
      },
      icon: CountryCodePicker(
        onChanged: (countrycode) {
          setState(() {
            countryCode = countrycode.dialCode!;
          });
        },
        initialSelection: '+91',
        favorite: ['+91', 'IND'],
        textStyle: TextStyle(color: Colors.orange[900]),
        showFlag: true,
        padding: EdgeInsets.only(left: 10),
      ),
    );
  }

  _submitButton(Userprovider user) {
    return Padding(
      padding: Responsive.isDesktop(context)
          ? EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.15)
          : const EdgeInsets.all(0.0),
      child: RoundedButton(
          text: "Submit",
          color: accentcolor,
          press: () async {
            if (_formkey.currentState!.validate()) {
              String phoneNumber = countryCode + _mobilecontroller.text.trim();

              await user.isMobileNumExists(phoneNumber).then((usr) async {
                if (usr.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                    'User not exists   ',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.solway(color: Colors.redAccent),
                  )));
                } else {
                  user.setPhonenumber(phoneNumber);
                  // user.setnumwithoutcountrycode(_mobilecontroller.text.trim());
                  Navigator.of(context).pushReplacementNamed(
                    PhoneVerification.routename,
                    arguments: {
                      'key': 2,
                    },
                  );
                  await _auth.phoneVerification(phoneNumber);
                }
              });
            }
          }),
    );
  }
}
