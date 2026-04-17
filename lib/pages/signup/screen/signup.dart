import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:englishcoach/common_models/user.dart';
import 'package:englishcoach/common_providers/users.dart';
import 'package:englishcoach/services/authservice.dart';
import 'package:englishcoach/services/fb_appevents.dart';
import 'package:flutter/foundation.dart';
import '../../../config/responsive.dart';
import '/config/widgetHelper.dart';
import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:email_validator/email_validator.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '/common_widgets/already_have_an_account_acheck.dart';
import '/common_widgets/countrycode.dart';
import '/common_widgets/rounded_button.dart';
import '/common_widgets/rounded_input_field.dart';
import '/common_widgets/rounded_password_field.dart';
import '/config/color.dart';
import '/localization/language_constants.dart';
import '/pages/login/screen/login.dart';

class SignupPage extends StatefulWidget {
  static const routename = '/signup-screen';
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formkey = GlobalKey<FormState>();
  //textediting controllers
  final _namecontroller = TextEditingController();
  final _emailcontroller = TextEditingController();
  final _mobilecontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();
  final _confirmcontroller = TextEditingController();

//focus nodes
  final _emailFocus = FocusNode();
  final _phnFocus = FocusNode();
  final _pswdFocus = FocusNode();
  final _confirmFocus = FocusNode();

  var countryCode = '+91';
  bool _checkboxValue = false;
  final _auth = AuthServices();
  final _fb = FBAppevents();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final curScaleFactor = MediaQuery.of(context).textScaleFactor;
    return SafeArea(
        child: Consumer<Userprovider>(builder: (context, user, child) {
      return Scaffold(
        body: Form(
            key: _formkey,
            child: Padding(
              padding: Responsive.isMobile(context)
                  ? EdgeInsets.only(
                      top: size.height * 0.058,
                      left: size.width * 0.058,
                      right: size.width * 0.058)
                  : EdgeInsets.only(
                      top: size.height * 0.04,
                      left: size.width * 0.2,
                      right: size.width * 0.2),
              child: Stack(
                children: [
                  ListView(
                    children: [
                      _getTitle(curScaleFactor),
                      SizedBox(height: size.height * 0.03),
                      _nameField(),
                      _emailField(),
                      _phonenumberField(),
                      _passwordField(),
                      _confirmPassword(),
                      _termsandConditionString(size),
                      _signupButton(user),
                      SizedBox(height: size.height * 0.03),
                      _alreadyHaveaccount(),
                      SizedBox(height: size.height * 0.03),
                    ],
                  ),
                  WidgetHelper.getProgressBar(user.state),
                ],
              ),
            )),
      );
    }));
  }

  _getTitle(double curScaleFactor) {
    return Text(
      getTranslated(context, 'signup'),
      style: TextStyle(
        fontSize: 20 * curScaleFactor,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }

  _nameField() {
    return RoundedInputField(
      controller: _namecontroller,
      textInputAction: TextInputAction.next,
      validator: (_namecontroller) {
        if (_namecontroller!.isEmpty) {
          return getTranslated(context, 'name_cannot');
        } else {
          return null;
        }
      },
      hintText: getTranslated(context, 'your_name'),
      onFieldSubmitted: (value) {
        _namecontroller.text = value;
        FocusScope.of(context).requestFocus(_emailFocus);
      },
    );
  }

  _emailField() {
    return RoundedInputField(
      controller: _emailcontroller,
      textInputAction: TextInputAction.next,
      focusNode: _emailFocus,
      validator: (value) {
        if (EmailValidator.validate(value!)) {
          return null;
        } else {
          return getTranslated(context, 'Invalid_email');
        }
      },
      hintText: getTranslated(context, 'your_email'),
      onFieldSubmitted: (value) {
        _emailcontroller.text =
            value.toLowerCase().replaceAll(new RegExp(r"\s+"), "");
        FocusScope.of(context).requestFocus(_phnFocus);
      },
      icon: Icons.email,
    );
  }

  _phonenumberField() {
    return CountryInputField(
      keyboard: TextInputType.number,
      controller: _mobilecontroller,
      focusNode: _phnFocus,
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
        FocusScope.of(context).requestFocus(_pswdFocus);
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

  _passwordField() {
    return RoundedPasswordField(
      controller: _passwordcontroller,
      focusNode: _pswdFocus,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value!.isEmpty) {
          return getTranslated(context, 'password_cannot');
        }
        if (value.length < 5) {
          return getTranslated(context, 'password_too_short');
        } else {
          return null;
        }
      },
      onFieldSubmitted: (value) {
        _passwordcontroller.text = value;
        FocusScope.of(context).requestFocus(_confirmFocus);
      },
      hintText: getTranslated(context, 'password'),
    );
  }

  _confirmPassword() {
    return RoundedPasswordField(
      controller: _confirmcontroller,
      focusNode: _confirmFocus,
      validator: (val) {
        if (val!.isEmpty) {
          return getTranslated(context, 'Field_cannot');
        }
        if (_confirmcontroller.text.trim() != _passwordcontroller.text.trim()) {
          return getTranslated(context, 'pswd_not_match');
        } else {
          return null;
        }
      },
      onFieldSubmitted: (value) {
        _confirmcontroller.text = value;
      },
      hintText: getTranslated(context, 'confirm_password'),
    );
  }

  _signupButton(Userprovider user) {
    return Container(
      // color: Colors.amberAccent,
      child: Padding(
        padding: Responsive.isDesktop(context)
            ? EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.15)
            : const EdgeInsets.all(0.0),
        child: RoundedButton(
            text: getTranslated(context, 'signup'),
            color: accentcolor,
            press: () {
              if (_formkey.currentState!.validate()) {
                String phoneNumber =
                    countryCode + _mobilecontroller.text.trim();
                generateMd5();
                var _newuser = User(
                  userName: _namecontroller.text,
                  userEmail: _emailcontroller.text
                      .toLowerCase()
                      .replaceAll(new RegExp(r"\s+"), ""),
                  userMob: phoneNumber,
                  userPswd: md,
                );
                _checkTandCaccepeted(user, _newuser, phoneNumber);
              }
            }),
      ),
    );
  }

  _checkTandCaccepeted(
      Userprovider user, User newuser, String phoneNumber) async {
    if (_checkboxValue == false) {
      setState(() {
        _checkboxValue = true;
      });
      return termsAndconditions(context);
    } else {
      await user.isMobileNumExists(phoneNumber).then((usr) {
        if (usr.isEmpty) {
          user.setPhonenumber(phoneNumber);
          // user.setnumwithoutcountrycode(_mobilecontroller.text.trim());
          user.addUser(newuser, context).then((_) async =>
              !kIsWeb ? await _auth.phoneVerification(phoneNumber) : null);
          _fb.registrationEvent(phoneNumber);
        } else {
          _showDialog(context);
        }
      });
    }
  }

  _termsandConditionString(Size size) {
    return InkWell(
      child: Row(
        children: <Widget>[
          Checkbox(
              value: _checkboxValue,
              onChanged: (value) {
                setState(() {
                  _checkboxValue = value!;
                });
              }),
          SizedBox(width: size.width * 0.02),
          Text(
            getTranslated(context, 'agree'),
          ),
          SizedBox(width: size.width * 0.01),
          Flexible(
            child: Text(
              'Terms & Conditions',
              style: TextStyle(color: accentcolor, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      onTap: () {
        termsAndconditions(context);
      },
    );
  }

  _alreadyHaveaccount() {
    return AlreadyHaveAnAccountCheck(
      press: () {
        Navigator.of(context).pushReplacementNamed(LoginPage.routename);
      },
    );
  }

  var md;

  generateMd5() {
    var decoded =
        md5.convert(utf8.encode(_passwordcontroller.text.trim())).toString();
    print(decoded);
    setState(() {
      md = decoded;
    });
  }

  //terms & conditions dialogbox
  void termsAndconditions(BuildContext context) {
    final curScaleFactor = MediaQuery.of(context).textScaleFactor;
    Size size = MediaQuery.of(context).size;
    var alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      title: Text(
        'Terms & Conditions',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Text(
            'English Coach: E learning platform developed to learn English language using online methods.',
            style: TextStyle(fontSize: 14 * curScaleFactor),
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: size.height * 0.01),
          Text(
            'Duration of the course: The course duration per day is approximately thirty minutes for an individual. Somehow it depends on the learning abilities of the user.',
            style: TextStyle(fontSize: 14 * curScaleFactor),
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: size.height * 0.01),
          Text(
            'Validity of the Course: 90 continuous days, irrespective of lockdown, pandemic and any natural or unnatural occurring abnormalities in the globe across the world. The administrator has the full right to add more days or subtract days from the above mentioned 90 continuous days.',
            style: TextStyle(fontSize: 14 * curScaleFactor),
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: size.height * 0.01),
          Text(
            'Privacy: The personal details of a registered user such as registered mobile number, e mail ID and bank details will not be shared with any authorities unless compelled by the corresponding governments using legal methods.',
            style: TextStyle(fontSize: 14 * curScaleFactor),
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: size.height * 0.03),
          Text(
            'For full set of terms and conditions please visit',
            style: TextStyle(fontSize: 14 * curScaleFactor),
          ),
          SizedBox(height: size.height * 0.01),
          GestureDetector(
            onTap: () => _urlLauncher(),
            child: Text(
              'www.englishcoach.app ',
              style:
                  TextStyle(color: accentcolor, fontSize: 14 * curScaleFactor),
            ),
          ),
        ],
      )),
      actions: <Widget>[
        TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                color: accentcolor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              alignment: Alignment.center,
              height: 50,
              width: size.height * 80,
              child: Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  _urlLauncher() async {
    const url = 'https://www.englishcoach.app/privacypolicy.html';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _showDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                Container(
                  height: 250,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Alert',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Phone Number Already exists',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Ok',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: accentcolor,
                                ),
                              )),
                        ],
                      )
                    ],
                  ),
                ),
                Positioned(
                    top: -50,
                    child: CircleAvatar(
                      backgroundColor: Color(0xFF205072),
                      radius: 50,
                      child: Image.asset('assets/icons/Icon.png'),
                    ))
              ],
            ),
          );
        });
  }
}
