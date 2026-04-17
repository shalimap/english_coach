import 'dart:async';

import 'package:englishcoach/common_providers/users.dart';
import 'package:englishcoach/common_widgets/rounded_button.dart';
import 'package:englishcoach/config/color.dart';
import 'package:englishcoach/localization/language_constants.dart';
import 'package:englishcoach/pages/Forgotpassword/screen/resetpassword.dart';
import 'package:englishcoach/pages/profile/screen/profilePage.dart';
import 'package:englishcoach/services/authservice.dart';
import 'package:englishcoach/services/fb_appevents.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../../../config/responsive.dart';

class PhoneVerification extends StatefulWidget {
  static const routename = '/otp-screen';
  const PhoneVerification({Key? key}) : super(key: key);

  @override
  _PhoneVerificationState createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification> {
  final _phone = TextEditingController();
  final _verifiedkey = GlobalKey<FormState>();

  String currentText = "";
  StreamController<ErrorAnimationType>? errorController;
  bool hasError = false;
  bool _isResend = false;
  bool _isInit = true;

  Timer? _timer;
  int _start = 60;

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();
    _timer!.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (kIsWeb && _isInit) {
      webVerification();
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  var temp;

  webVerification() async {
    final user = Provider.of<Userprovider>(context, listen: false);
    String phone = await user.getPhonenumber();

    temp = await _auth.phoneVerificationWeb(phone);
  }

  final _auth = AuthServices();
  final _fb = FBAppevents();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<Userprovider>(builder: (context, user, child) {
      return Scaffold(
        appBar: _getAppbar(),
        body: Form(
            key: _verifiedkey,
            child: SingleChildScrollView(
              child: Container(
                height: 500,
                child: Padding(
                  padding: Responsive.isDesktop(context)
                      ? EdgeInsets.symmetric(horizontal: size.width * 0.3)
                      : Responsive.isTablet(context)
                          ? EdgeInsets.symmetric(horizontal: size.width * 0.2)
                          : const EdgeInsets.all(0.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 30),
                      _getTitle(),
                      SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: otpfield(
                            context: context,
                            currentText: currentText,
                            errorController: errorController,
                            onChanged: (value) {
                              print(value);
                              setState(() {
                                currentText = value;
                              });
                            },
                            phone: _phone),
                      ),
                      _getMsg(),
                      SizedBox(height: 15),
                      _verifyButton(user),
                      SizedBox(height: 15),
                      _isResend ? _resendbutton(user) : _resendText(),
                    ],
                  ),
                ),
              ),
            )),
      );
    });
  }

  _getAppbar() {
    return AppBar(
      title: Text(
        getTranslated(context, 'verification'),
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      leading: IconButton(
        icon: Icon(
          Icons.chevron_left,
          size: 40,
          color: Colors.white,
        ),
        onPressed: null,
      ),
      elevation: 0.0,
      centerTitle: true,
    );
  }

  _getTitle() {
    return Flexible(
      child: Text(
        getTranslated(context, 'verification_code'),
      ),
    );
  }

  _getMsg() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Text(
        hasError ? getTranslated(context, 'correct_otp') : "",
        style: TextStyle(
            color: Colors.red,
            //fontSize: 12 * curScaleFactor,
            fontWeight: FontWeight.w400),
      ),
    );
  }

  _verifyButton(Userprovider user) {
    return RoundedButton(
      press: () async {
        String phone = await user.getPhonenumber();
        //  String phonewithoutcode = await user.getnumwithoutcountrycode();
        kIsWeb
            ? await _auth.authenticateWeb(temp, currentText)
            : await _auth.signinwithcredential(currentText);
        if (_auth.statusCode != 200) {
          errorController!.add(ErrorAnimationType.shake);
          setState(() {
            hasError = true;
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(_auth.errorMsg)));
          });
        } else {
          success(context, phone, user);
          //_showDialog(context);
          // await user.editPermission();
          // user.getUserwithphonenum(phonewithoutcode);
          // _fb.verificationEvent(phone);
          setState(() {
            hasError = false;
          });
        }
      },
      text: getTranslated(context, 'verify'),
      color: accentcolor,
    );
  }

  _resendbutton(Userprovider user) {
    return RoundedButton(
      press: () async {
        String phone = await user.getPhonenumber();
        print(phone);
        kIsWeb ? webVerification() : await _auth.phoneVerification(phone);
        setState(() {
          _isResend = false;
          _start = 60;
          startTimer();
        });
      },
      text: getTranslated(context, 'resend'),
      color: accentcolor,
    );
  }

  _resendText() {
    return Flexible(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: getTranslated(context, 'wait_resend'),
          style: TextStyle(
            color: Colors.black,
          ),
          children: [
            TextSpan(
              text: '00:' + _start.toString(),
              style: TextStyle(
                color: primarySwatch,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            _isResend = true;
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  void success(BuildContext context, String phone, Userprovider user) async {
    final routeArgs = ModalRoute.of(context)!.settings.arguments as Map;

    final getkey = routeArgs['key'];

    if (getkey == 1) {
      _showDialog(context);
      await user.editPermission();
      await user.getUserwithphonenum(phone);
      _fb.verificationEvent(phone);
    } else {
      Navigator.of(context)
          .popAndPushNamed(ResetPassword.routename, arguments: phone);
    }
  }

  PinCodeTextField otpfield(
      {required BuildContext context,
      required String currentText,
      required StreamController<ErrorAnimationType>? errorController,
      required Function(String) onChanged,
      required TextEditingController phone}) {
    return PinCodeTextField(
      appContext: context,
      length: 6,
      obscureText: false,
      animationType: AnimationType.fade,
      pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(5),
          fieldHeight: 50,
          fieldWidth: 50,
          activeFillColor: Colors.white,
          inactiveColor: Colors.grey),
      animationDuration: Duration(milliseconds: 300),
      errorAnimationController: errorController,
      controller: phone,
      keyboardType: TextInputType.number,
      onCompleted: (v) {
        print("Completed");
      },
      onChanged: onChanged,
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
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
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Registered Successfully',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      //!! phonenumber with countrycode added in login screen
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: Text(
                      //     'Username - രജിസ്റ്റർ ചെയ്ത ഫോൺ നമ്പർ ആയിരിക്കും.',
                      //     textAlign: TextAlign.center,
                      //     style: TextStyle(
                      //       fontSize: 18,
                      //     ),
                      //   ),
                      // ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    ProfilePage.routename, (route) => false);
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
