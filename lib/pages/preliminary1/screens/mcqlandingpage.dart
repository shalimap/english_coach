import 'package:englishcoach/common_widgets/toast_widget.dart';
import 'package:englishcoach/config/color.dart';
import 'package:englishcoach/pages/login/screen/login.dart';
import 'package:englishcoach/pages/preliminary1/screens/mcqrules.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:oktoast/oktoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/responsive.dart';

class McqLandingPage extends StatelessWidget {
  static const routename = '/mcqlanding-page';

  void _showDialogs(BuildContext context) {
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
                        'Confirmation',
                        style: GoogleFonts.solway(
                          textStyle: TextStyle(fontWeight: FontWeight.bold),
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Are you sure you want to logout ?',
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
                              onPressed: () async {
                                final prefs =
                                    await SharedPreferences.getInstance();
                                prefs.clear();
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
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Cancel',
                                style: GoogleFonts.solway(
                                    fontSize: 14, color: accentcolor),
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

  void _showDialogNote(BuildContext context) {
    final getuserid = ModalRoute.of(context)!.settings.arguments;
    Size size = MediaQuery.of(context).size;
    showDialog(
        context: context,
        barrierDismissible: false,
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
                  margin: EdgeInsets.all(20),
                  height: size.height * .45,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'നിർദ്ദേശങ്ങൾ',
                        style: GoogleFonts.solway(
                          textStyle: TextStyle(fontWeight: FontWeight.bold),
                          fontSize: Responsive.isDesktop(context) ? 20 : 16,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '1. നിങ്ങൾക്ക് ഒരു തവണ മാത്രമേ ഈ പരീക്ഷ എഴുതാൻ കഴിയൂ',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.solway(
                          fontSize: Responsive.isDesktop(context) ? 16 : 12,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        '2. ആരംഭിച്ചുകഴിഞ്ഞാൽ 2 പരീക്ഷകൾ പൂർത്തിയാക്കുക.\n പരീക്ഷകൾക്കിടയിൽ ഉപേക്ഷിക്കാൻ ശ്രമിക്കരുത്',
                        style: GoogleFonts.solway(
                          fontSize: Responsive.isDesktop(context) ? 16 : 12,
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
                                Navigator.of(context).pushReplacementNamed(
                                  MCQRules.routename,
                                  arguments: getuserid,
                                );
                              },
                              child: Text(
                                'ആരംഭിക്കുക',
                                style: GoogleFonts.solway(
                                  fontSize:
                                      Responsive.isDesktop(context) ? 16 : 12,
                                  color: accentcolor,
                                ),
                              )),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'പിന്നീട് ചെയ്യും',
                                style: GoogleFonts.solway(
                                  fontSize:
                                      Responsive.isDesktop(context) ? 16 : 12,
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

  // void _showDialog(BuildContext context) {
  //   var alertDialog = AlertDialog(
  //     title: Text('Confirmation'),
  //     content: Text('Are you sure you want to logout ?'),
  //     actions: <Widget>[
  //       FlatButton(
  //           onPressed: () {
  //             Navigator.of(context).pushNamedAndRemoveUntil(
  //                 LoginBody.routename, (route) => false);
  //           },
  //           child: Text('Yes')),
  //       FlatButton(
  //           onPressed: () {
  //             Navigator.of(context).pop();
  //           },
  //           child: Text('No'))
  //     ],
  //   );
  //   showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (BuildContext context) {
  //         return alertDialog;
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    //final getuserid = ModalRoute.of(context).settings.arguments;
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.chevron_left,
              size: 40,
              color: Colors.white,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          elevation: 0.0,
          title: Center(
            child: Text(
              'Preliminary Tests',
              style: GoogleFonts.solway(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.power_settings_new),
                onPressed: () {
                  _showDialogs(context);
                })
          ],
        ),
        body: Center(
          child: Padding(
            padding: Responsive.isDesktop(context)
                ? EdgeInsets.symmetric(horizontal: size.width * 0.3)
                : Responsive.isTablet(context)
                    ? EdgeInsets.symmetric(horizontal: size.width * 0.2)
                    : const EdgeInsets.all(0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ButtonTheme(
                    height: 80,
                    buttonColor: Color(0xFF56c590),
                    minWidth: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigator.of(context).pushReplacementNamed(
                        //   MCQRules.routename,
                        //   arguments: getuserid,
                        // );
                        _showDialogNote(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Launch Test 1',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                            ),
                          ),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        elevation: 5,
                        backgroundColor: Color(0xFF56c590),
                        padding: EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ButtonTheme(
                    height: 80,
                    minWidth: double.infinity,
                    buttonColor: Colors.grey,
                    child: ElevatedButton(
                      onPressed: () {
                        showToastWidget(
                          ToastWidget(
                            title: 'ടെസ്റ്റ് 1 എടുക്കുക',
                            description: '',
                          ),
                          duration: Duration(seconds: 3),
                          dismissOtherToast: true,
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.lock_outline,
                            color: Colors.white,
                            size: 30,
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Text(
                            ' Test 2',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                            ),
                          ),
                          SizedBox(
                            width: 50,
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: Colors.white,
                            size: 30,
                          )
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        elevation: 5,
                        backgroundColor: Colors.grey,
                        padding: EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
