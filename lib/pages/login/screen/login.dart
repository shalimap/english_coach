import 'dart:convert';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:crypto/crypto.dart';
import 'package:englishcoach/common_providers/users.dart';
import 'package:englishcoach/common_widgets/countrycode.dart';
import 'package:englishcoach/config/widgetHelper.dart';
import 'package:englishcoach/pages/Forgotpassword/screen/forgot_password.dart';
import 'package:englishcoach/pages/Modules/screens/menu_dashboard_page.dart';
import 'package:englishcoach/pages/otp/screen/verificationpage.dart';
import 'package:englishcoach/pages/preliminary1/screens/mcqlandingpage.dart';
import 'package:englishcoach/pages/profile/screen/profilePage.dart';
import 'package:englishcoach/pages/signup/screen/signup.dart';
import 'package:englishcoach/pages/trial/screens/menu_dashboard_page.dart';
import 'package:englishcoach/services/authservice.dart';
import 'package:englishcoach/services/fb_appevents.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/responsive.dart';
import '../../../main.dart';
import '/common_widgets/rounded_input_field.dart';
import '/common_widgets/rounded_password_field.dart';
import 'package:flutter_svg/svg.dart';
import '/common_widgets/rounded_button.dart';
import '/config/color.dart';
import '/common_widgets/or_divider.dart';
import '/classes/lang.dart';
import '/localization/language_constants.dart';

class LoginPage extends StatefulWidget {
  static const routename = '/login-screen';
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _mobilecontroller = TextEditingController();
  final _usernamecontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();
  final _nextFocus = FocusNode();
  final _loginkey = GlobalKey<FormState>();
  final _fb = FBAppevents();
  final _auth = AuthServices();
  var _isLoading = false;
  var countryCode = '+91';
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final curScaleFactor = MediaQuery.of(context).textScaleFactor;
    return Consumer<Userprovider>(builder: (context, user, child) {
      return Scaffold(
        body: _mainbody(size, curScaleFactor, user),
      );
    });
  }

  _mainbody(Size size, double curScaleFactor, Userprovider user) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Form(
            key: _loginkey,
            child: Center(
              child: Padding(
                padding: Responsive.isDesktop(context)
                    ? EdgeInsets.symmetric(horizontal: size.width * 0.2)
                    : const EdgeInsets.all(0.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: size.height * 0.06),
                    _mainLogo(size),
                    SizedBox(height: size.height * 0.03),
                    _phonenumberField(),
                    //_usernameField(),
                    _passwordField(),
                    _isLoading == false
                        ? _forgotpassword(curScaleFactor)
                        : Container(),
                    _isLoading == false
                        ? _login(user)
                        : WidgetHelper.buttonloading,
                    _isLoading == false ? OrDivider() : Container(),
                    _isLoading == false ? _gotoSignup() : Container(),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    _isLoading == false ? _localization() : Container(),
                    SizedBox(
                      height: size.height * 0.04,
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }

  _mainLogo(Size size) {
    return SvgPicture.asset(
      "assets/icons/loginec.svg",
      height: size.height * 0.28,
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
        FocusScope.of(context).requestFocus(_nextFocus);
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

  _usernameField() {
    return RoundedInputField(
      controller: _usernamecontroller,
      hintText: getTranslated(context, 'registered_mobilenum'),
      keyboard: TextInputType.number,
      validator: (val) {
        if (val!.isEmpty) {
          return getTranslated(context, 'Enter_your_mobile');
        }
        return null;
      },
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(_nextFocus);
      },
    );
  }

  _passwordField() {
    return RoundedPasswordField(
      controller: _passwordcontroller,
      validator: (val) {
        if (val!.isEmpty) {
          return getTranslated(context, 'Enter_your_password');
        }
        return null;
      },
      hintText: getTranslated(context, 'password'),
      focusNode: _nextFocus,
    );
  }

  _forgotpassword(double curScaleFactor) {
    return InkWell(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Container(
          // margin: EdgeInsets.only(left: size.width * 0.50),
          child: Text(
            getTranslated(context, 'Forgot_password'),
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black,
                fontSize: 15 * curScaleFactor,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
      onTap: () {
        Navigator.of(context).pushNamed(ForgotPasswordscreen.routeName);
      },
    );
  }

  _gotoSignup() {
    return Padding(
      padding: Responsive.isDesktop(context)
          ? EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.15)
          : const EdgeInsets.all(0.0),
      child: RoundedButton(
        text: getTranslated(context, 'signup'),
        color: accentcolor,
        press: () {
          Navigator.of(context).pushNamed(SignupPage.routename);
        },
      ),
    );
  }

  _localization() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.language,
          color: accentcolor,
        ),
        SizedBox(
          width: 20,
        ),
        DropdownButton(
          onChanged: (Language? language) {
            _changeLanguage(language!);
          },

          hint: Text(
            getTranslated(context, 'language'),
          ),
          underline: SizedBox(),
          //icon: Icon(Icons.language),
          items: Language.languageList()
              .map<DropdownMenuItem<Language>>((lang) => DropdownMenuItem(
                    value: lang,
                    child: Text(lang.name),
                  ))
              .toList(),
        ),
      ],
    );
  }

  void _changeLanguage(Language language) async {
    Locale _temp = await setLocale(language.languageCode);
    MyApp.setLocale(context, _temp);
  }

  _login(Userprovider user) {
    return Padding(
      padding: Responsive.isDesktop(context)
          ? EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.15)
          : const EdgeInsets.all(0.0),
      child: RoundedButton(
          text: getTranslated(context, 'login'),
          color: accentcolor,
          press: () async {
            if (_loginkey.currentState!.validate()) {
              String phoneNumber = countryCode + _mobilecontroller.text.trim();
              print(phoneNumber);
              generateMd5();
              _apploadState(true);
              await user.login(phoneNumber, md);
              if (user.user != null) {
                print('Login success');
                user.user!.userPermission == '0'
                    ? _notverifiedusers(user, phoneNumber)
                    : _gotoCompletedPages(user);
                // Navigator.of(context).pushReplacementNamed(ProfilePage.routename);
              } else {
                invalidPswd();
                _apploadState(false);
              }
            }
          }),
    );
  }

  invalidPswd() {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
      getTranslated(context, "invalid_login"),
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.redAccent),
    )));
  }

  var md;
  generateMd5() {
    var decoded = md5
        .convert(utf8.encode(
          _passwordcontroller.text.trim(),
        ))
        .toString();
    print(decoded);
    setState(() {
      md = decoded;
    });
  }

  _notverifiedusers(Userprovider user, String phoneNumber) async {
    user.setPhonenumber(phoneNumber);
    if (!kIsWeb) await _auth.phoneVerification(phoneNumber);
    Navigator.of(context).pushReplacementNamed(
      PhoneVerification.routename,
      arguments: {
        'key': 1,
      },
    );
    _apploadState(false);
  }

  _gotoCompletedPages(Userprovider user) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var statusrsp = await user.getStatus(user.user!.userId!);
      print(statusrsp[0]);
      if (statusrsp[0]['status'] == '1') {
        try {
          var levelrsp = await user.getLevel(user.user!.userId!);
          if (levelrsp[0]['sl_level'] == 'b' ||
              levelrsp[0]['sl_level'] == 'i' ||
              levelrsp[0]['sl_level'] == 'e') {
            try {
              var paymentrsp = await user.getpaymentStatus(user.user!.userId!);
              print(paymentrsp[0]);

              for (var i = 0; i < paymentrsp.length; i++) {
                if (paymentrsp[i].containsValue('1')) {
                  prefs.setBool('trial', false);
                  Navigator.of(context).pushReplacementNamed(
                      MenuDashboardPage.routeName,
                      arguments: user.user!.userId!);
                } else {
                  prefs.setBool('trial', true);
                  Navigator.of(context).pushReplacementNamed(
                      TrialDashboardPage.routeName,
                      arguments: user.user!.userId!);
                  _fb.loggedUsers(user.user!.userId!);
                }
              }
            } catch (error) {
              print(error);
              Navigator.of(context).pushReplacementNamed(
                  TrialDashboardPage.routeName,
                  arguments: user.user!.userId!);
            }
          } else {
            Navigator.of(context).pushReplacementNamed(McqLandingPage.routename,
                arguments: user.user!.userId!);
          }
        } catch (error) {
          Navigator.of(context).pushReplacementNamed(McqLandingPage.routename,
              arguments: user.user!.userId!);
        }
      } else {
        Navigator.of(context).pushReplacementNamed(ProfilePage.routename);
      }
    } catch (error) {
      print(error);
      Navigator.of(context).pushReplacementNamed(ProfilePage.routename);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  _apploadState(bool value) {
    return setState(() {
      _isLoading = value;
    });
  }
}
