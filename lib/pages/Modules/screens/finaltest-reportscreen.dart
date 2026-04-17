import 'package:englishcoach/config/color.dart';
import 'package:englishcoach/pages/Modules/screens/finaltest-taketestscreen.dart';
import 'package:lottie/lottie.dart';

import '../providers/final_test_tests.dart';
import '../widgets/final_test_list.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class TestReportScreen extends StatefulWidget {
  static const routename = '/Testreportscreen';

  @override
  _TestReportScreenState createState() => _TestReportScreenState();
}

class _TestReportScreenState extends State<TestReportScreen> {
  var isLoading = false;
  var isInit = true;
  var nullTest = false;
  var limitExpired = false;

  Future<void> _refreshFinalTests(BuildContext context) async {
    final userId = ModalRoute.of(context)!.settings.arguments;
    await Provider.of<FinalTestChecks>(context, listen: false)
        .fetchTests(int.parse(userId.toString()));
  }

  @override
  void didChangeDependencies() {
    final userId = ModalRoute.of(context)!.settings.arguments;
    if (isInit) {
      if (!mounted) return;
      setState(() {
        isLoading = true;
      });

      Provider.of<FinalTestChecks>(context)
          .fetchTests(int.parse(userId.toString()))
          .then((tests) {
        if (!mounted) return;
        setState(
          () {
            if (tests.length == 0) {
              nullTest = true;
            }
            if (tests.length > 2) {
              limitExpired = true;
              final courseExpireCheck =
                  tests.where((mark) => mark.finalTestPoints! >= 80).toList();
              courseExpireCheck.isEmpty ? _showDialog(context) : Text('');
            }
            isLoading = false;
          },
        );
      });
      isInit = false;
    }
    super.didChangeDependencies();
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
                        'Your course has expired',
                        style: GoogleFonts.solway(
                          textStyle: TextStyle(fontWeight: FontWeight.bold),
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          'Due to the continuous failure of final tests your course has been expired.',
                          style: GoogleFonts.solway(
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
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
                                'close',
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

  @override
  Widget build(BuildContext context) {
    final userId = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.chevron_left,
              size: 40,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          elevation: 0.0,
          title: Text(
            'Final Test Reports',
            style: GoogleFonts.solway(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        floatingActionButton: limitExpired
            ? null
            : isLoading
                ? null
                : FloatingActionButton.extended(
                    elevation: 5,
                    tooltip: "New Test",
                    onPressed: () {
                      Navigator.of(context).popAndPushNamed(
                          TaketestScreen.routename,
                          arguments: userId);
                    },
                    label: Text(
                      "Start Test",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: RefreshIndicator(
          onRefresh: () => _refreshFinalTests(context),
          backgroundColor: Color(0xFF205072),
          child: isLoading
              ? Center(
                  child: SpinKitCircle(
                    color: Color(0xFF205072),
                  ),
                )
              : nullTest
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset(
                            'assets/images/781-no-notifications.json',
                          ),
                          Text(
                            'Time to take a test !',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )
                  : Consumer<FinalTestChecks>(
                      builder: (context, value, child) =>
                          FinalTestList(int.parse(userId.toString()))),
        ));
  }
}
