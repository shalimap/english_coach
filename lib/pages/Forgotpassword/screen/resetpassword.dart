import 'dart:convert';

import 'package:englishcoach/common_providers/users.dart';
import 'package:englishcoach/common_widgets/rounded_button.dart';
import 'package:englishcoach/common_widgets/rounded_password_field.dart';
import 'package:englishcoach/config/color.dart';
import 'package:englishcoach/pages/login/screen/login.dart';
import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:crypto/crypto.dart';
import 'package:google_fonts/google_fonts.dart';

class ResetPassword extends StatefulWidget {
  static const routename = '/resetscreen';

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formkey = GlobalKey<FormState>();

  final _passwordcontroller = TextEditingController();

  final _confirmcontroller = TextEditingController();

  final _pswdFocus = FocusNode();

  final _confirmFocus = FocusNode();

  void success(BuildContext context) {
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
                        'Success',
                        style: GoogleFonts.solway(
                          textStyle: TextStyle(fontWeight: FontWeight.bold),
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Password reset successful.',
                        style: GoogleFonts.solway(
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
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    LoginPage.routename, (route) => false);
                              },
                              child: Text(
                                'Ok',
                                style: GoogleFonts.solway(
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

  var md;

  generateMd5() {
    var decoded = md5.convert(utf8.encode(_confirmcontroller.text)).toString();
    print(decoded);
    setState(() {
      md = decoded;
    });
  }

  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    final getusermob = ModalRoute.of(context)!.settings.arguments as String;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            size: 40,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Reset Password',
          style: GoogleFonts.solway(),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formkey,
            child: Column(
              children: <Widget>[
                SizedBox(height: size.height * 0.09),
                RoundedPasswordField(
                  controller: _passwordcontroller,
                  focusNode: _pswdFocus,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Password cannot be empty';
                    }
                    if (value.length < 5) {
                      return 'Password too short';
                    } else {
                      return null;
                    }
                  },
                  onFieldSubmitted: (value) {
                    _passwordcontroller.text = value;
                    FocusScope.of(context).requestFocus(_confirmFocus);
                  },
                  hintText: 'Enter new password',
                ),
                RoundedPasswordField(
                  controller: _confirmcontroller,
                  focusNode: _confirmFocus,
                  validator: (_confirmcontroller) {
                    if (_confirmcontroller!.isEmpty) {
                      return 'Field cannot be Empty';
                    }
                    if (_confirmcontroller != _passwordcontroller.text.trim()) {
                      return 'Passwords not match';
                    } else {
                      return null;
                    }
                  },
                  onFieldSubmitted: (value) {
                    _confirmcontroller.text = value;
                  },
                  hintText: 'Confirm Password',
                ),
                isLoading
                    ? Center(
                        child: SpinKitThreeBounce(
                          color: Color(0xFF56c590),
                        ),
                      )
                    : RoundedButton(
                        text: 'Submit',
                        color: accentcolor,
                        press: () async {
                          if (_formkey.currentState!.validate()) {
                            generateMd5();
                            setState(() {
                              isLoading = true;
                            });

                            Provider.of<Userprovider>(context, listen: false)
                                .reset(getusermob, md)
                                .then((_) {
                              setState(() {
                                isLoading = false;
                                success(context);
                              });
                            });
                          }
                        },
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
