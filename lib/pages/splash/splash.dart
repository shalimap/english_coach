import 'dart:async';
import 'dart:convert';

import 'package:englishcoach/common_providers/users.dart';
import 'package:englishcoach/config/widgetHelper.dart';
import 'package:englishcoach/pages/Modules/screens/menu_dashboard_page.dart';
import 'package:englishcoach/pages/introSlider/introSlider.dart';
import 'package:englishcoach/pages/preliminary1/screens/mcqlandingpage.dart';
import 'package:englishcoach/pages/profile/screen/profilePage.dart';
import 'package:englishcoach/pages/trial/screens/menu_dashboard_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/pages/login/screen/login.dart';
import '/config/color.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  timer() async {
    var _duration = new Duration(seconds: kIsWeb ? 0 : 3);
    return new Timer(_duration, navigate);
  }

  Future<void> navigate() async {
    final user = Provider.of<Userprovider>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey('userData')) {
      final extractedUserData =
          json.decode(prefs.getString('userData')!) as Map;

      await user.getUserwithphonenum(extractedUserData['usermob']);

      try {
        var statusrsp = await user.getStatus(extractedUserData['userid']);
        print(statusrsp[0]);
        if (statusrsp[0]['status'] == '1') {
          try {
            var levelrsp = await user.getLevel(extractedUserData['userid']);
            if (levelrsp[0]['sl_level'] == 'b' ||
                levelrsp[0]['sl_level'] == 'i' ||
                levelrsp[0]['sl_level'] == 'e') {
              try {
                var paymentrsp =
                    await user.getpaymentStatus(extractedUserData['userid']);
                print(paymentrsp[0]);

                for (var i = 0; i < paymentrsp.length; i++) {
                  if (paymentrsp[i].containsValue('1')) {
                    prefs.setBool('trial', false);
                    Navigator.of(context).pushReplacementNamed(
                        MenuDashboardPage.routeName,
                        arguments: extractedUserData['userid']);
                    print(extractedUserData['userid']);
                  } else if (!paymentrsp[i].containsValue('1') &&
                      paymentrsp[i].containsValue('0')) {
                    print('im in');
                    //!!check
                    prefs.setBool('trial', true);
                    Navigator.of(context).pushReplacementNamed(
                        TrialDashboardPage.routeName,
                        arguments: extractedUserData['userid']);
                  }
                }
              } catch (error) {
                print(error);
                Navigator.of(context).pushReplacementNamed(
                    TrialDashboardPage.routeName,
                    arguments: extractedUserData['userid']);
              }
            } else {
              Navigator.of(context).pushReplacementNamed(
                  McqLandingPage.routename,
                  arguments: extractedUserData['userid']);
            }
          } catch (error) {
            Navigator.of(context).pushReplacementNamed(McqLandingPage.routename,
                arguments: extractedUserData['userid']);
          }
        } else {
          Navigator.of(context).pushReplacementNamed(ProfilePage.routename);
        }
      } catch (error) {
        print(error);
        Navigator.of(context).pushReplacementNamed(ProfilePage.routename);
      }
    } else {
      bool isFirstTime = await WidgetHelper.getPrefrenceBool('isfirst');

      if (isFirstTime && !kIsWeb) {
        Navigator.of(context).pushReplacement(
          PageTransition(
            child: IntroSliders(),
            type: PageTransitionType.leftToRightWithFade,
          ),
        );
      } else {
        Navigator.of(context).pushReplacement(
          PageTransition(
            child: LoginPage(),
            type: PageTransitionType.leftToRightWithFade,
          ),
        );
      }
    }
  }

  @override
  void initState() {
    timer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: !kIsWeb ? splashbgcolor : Colors.white,
      body: Center(
        child: Image.asset(
          'assets/splash/splashicon.png',
          scale: 2,
        ),
      ),
    );
  }
}
