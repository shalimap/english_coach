import 'package:englishcoach/common_widgets/toast_widget.dart';
import 'package:englishcoach/pages/preliminary2/screens/prelim_testrules_page.dart';
import 'package:flutter/material.dart';

import 'package:oktoast/oktoast.dart';

import '../../../config/responsive.dart';

class TransLandingPage extends StatelessWidget {
  static const routeName = '/translanding-page';
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final routeArgs = ModalRoute.of(context)!.settings.arguments as Map;

    final userid = routeArgs['userid'];
    final testid = routeArgs['testid'];
    final mcqpoints = routeArgs['totalmark'];
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
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
                    minWidth: double.infinity,
                    buttonColor: Colors.grey,
                    child: ElevatedButton(
                      onPressed: () {
                        showToastWidget(
                          ToastWidget(
                            title: 'ടെസ്റ്റ് 2 എടുക്കുക',
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
                            'Test 1',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                            ),
                          ),
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
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ButtonTheme(
                    height: 80,
                    minWidth: double.infinity,
                    buttonColor: Color(0xFF56c590),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed(
                            Prelim2TestRules.routeName,
                            arguments: {
                              'userid': userid,
                              'testid': testid,
                              'mcqpoints': mcqpoints,
                            });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Launch Test 2',
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
                        backgroundColor: Color(0xFF56c590),
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
