import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:englishcoach/config/color.dart';
import 'package:englishcoach/pages/trialTest/providers/trial_questions.dart';
import 'package:englishcoach/pages/trialTest/screens/trialtaketest.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import '../providers/trial_tests.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';

import '../Widgets/trail_testlist.dart';

import 'package:flutter/services.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:ndialog/ndialog.dart';

class TrialReportscreen extends StatefulWidget {
  static const routename = '/trialreportscreen';

  @override
  _TrialReportscreenState createState() => _TrialReportscreenState();
}

class _TrialReportscreenState extends State<TrialReportscreen> {
  var isLoading = false;
  var isInit = true;
  var nullTest = false;
  Future<void> _refreshFinalTests(BuildContext context) async {
    final routeArgs = ModalRoute.of(context)!.settings.arguments as Map;
    final userId = routeArgs['userId'];
    final modId = routeArgs['mod'];
    // final userId = ModalRoute.of(context).settings.arguments;
    await Provider.of<TrialTest>(context, listen: false)
        .fetchTests(modId, userId);
  }

  // final userId = 10000;
  // final modId = 10000;
  // @override
  // void didChangeDependencies() {
  //   final routeArgs = ModalRoute.of(context).settings.arguments as Map;
  //   final userId = routeArgs['userId'];
  //   final modId = routeArgs['mod'];
  //   if (isInit) {
  //     if (!mounted) return;
  //     setState(() {
  //       isLoading = true;
  //     });

  //     Provider.of<TrialQuestion>(context, listen: false).fetchQuestions(modId);

  //     Provider.of<TrialTest>(context).fetchTests(modId, userId).then((tests) {
  //       if (!mounted) return;
  //       setState(
  //         () {
  //           if (tests.length == 0) {
  //             nullTest = true;
  //           }

  //           isLoading = false;
  //         },
  //       );
  //     });
  //     isInit = false;
  //   }
  //   super.didChangeDependencies();
  // }

  var connected;
  bool checkConnectivity() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        setState(() {
          connected = true;
        });
      } else {
        setState(() {
          connected = false;
        });
      }
    });
    return connected ?? true;
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context)!.settings.arguments as Map;
    final userId = routeArgs['userId'];
    final modId = routeArgs['mod'];
    //final userId = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.chevron_left,
              size: 40,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              // Navigator.of(context).pushReplacementNamed(
              //     TrialDashboardPage.routeName,
              //     arguments: userId.toString());
            }),
        elevation: 0.0,
        title: Text(
          ' Test Reports',
          style: GoogleFonts.solway(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: checkConnectivity()
          ? FloatingActionButton.extended(
              backgroundColor: accentcolor,
              label: Text(
                "Start Test",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(TrialTaketest.routename, arguments: {
                  'userId': userId,
                  'modId': modId,
                });
              })
          : Text(''),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: OfflineBuilder(
        connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget child,
        ) {
          final bool connected = connectivity != ConnectivityResult.none;
          return connected
              ? StreamBuilder(
                  stream: Stream.fromFuture(Provider.of<TrialTest>(context)
                      .fetchTests(modId, userId)),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      // List tests = snapshot.data;
                      // if (tests.length == 0) {
                      //   nullTest = true;
                      // }

                      Provider.of<TrialQuestion>(context, listen: false)
                          .fetchQuestions(modId);

                      return RefreshIndicator(
                        onRefresh: () => _refreshFinalTests(context),
                        backgroundColor: Color(0xFF205072),
                        child:
                            // isLoading
                            //     ? Center(
                            //         child: SpinKitCircle(
                            //           color: Color(0xFF205072),
                            //         ),
                            //       )
                            //     :
                            snapshot.data.length == 0
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Lottie.asset(
                                          'assets/images/781-no-notifications.json',
                                        ),
                                        Text(
                                          'Time to take a test !',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  )
                                : Consumer<TrialTest>(
                                    builder: (context, value, child) =>
                                        TrailTestList(modId, userId)),
                      );
                    }
                    return Center(
                      child: SpinKitCircle(
                        color: Color(0xFF205072),
                      ),
                    );
                  },
                )
              : showError();
        },
        child: Text(''),
      ),
    );
  }

  showError() {
    return DialogBackground(
      barrierColor: Colors.grey.withOpacity(1),
      blur: 0,
      dialog: AlertDialog(
        title: Row(
          children: [
            SizedBox(
              width: 40,
            ),
            Text(
              "No Internet",
              textAlign: TextAlign.center,
            ),
            SizedBox(
              width: 10,
            ),
            Icon(Icons.wifi_off_rounded)
          ],
        ),
        content: Text("You are not conneted to the Internet."),
        actions: <Widget>[
          TextButton(
            child: Text("Retry"),
            onPressed: () {
              //Navigator.of(context).pop();
              // Navigator.of(context).pushReplacementNamed(DemoPage.routeName);

              SystemChannels.platform.invokeMethod('Systemnavigator.pop');
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(' Connecting'),
                  SizedBox(width: 30),
                  CircularProgressIndicator(
                    strokeWidth: 2.0,
                  ),
                ],
              )));
            },
          ),
        ],
      ),
    );
  }
}
