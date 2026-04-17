import '../provider/audiotests.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../widget/audio_testlist.dart';
import '../screen/audio_testrules.dart';
import 'package:lottie/lottie.dart';

class AudioTestReportScreen extends StatefulWidget {
  static const routename = '/audiotestreportscreen';

  @override
  _AudioTestReportScreenState createState() => _AudioTestReportScreenState();
}

class _AudioTestReportScreenState extends State<AudioTestReportScreen> {
  var isLoading = false;
  var isInit = true;
  var nullTest = false;
  @override
  void didChangeDependencies() {
    final data = ModalRoute.of(context)!.settings.arguments as Map;
    final userId = data['userId'];
    final audNum = data['audNum'];
    if (isInit) {
      if (!mounted) return;
      setState(() {
        isLoading = true;
      });

      Provider.of<AudioTests>(context, listen: false)
          .fetchTests(userId, audNum)
          .then((tests) {
        if (tests.isEmpty) {
          nullTest = true;
        }
        if (!mounted) return;
        setState(() {
          isLoading = false;
        });
      });
      isInit = false;
    }
    super.didChangeDependencies();
  }

  Future<void> _refreshAudioTests(BuildContext context) async {
    final data = ModalRoute.of(context)!.settings.arguments as Map;
    final userId = data['userId'];
    final audNum = data['audNum'];
    await Provider.of<AudioTests>(context, listen: false)
        .fetchTests(userId, audNum);
  }

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments as Map;
    final userId = data['userId'];
    final audNum = data['audNum'];
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.chevron_left,
              size: 40,
              color: Colors.black,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          elevation: 0.0,
          title: Text(
            "Audio Test Reports",
            style: GoogleFonts.solway(
                textStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
        ),
        floatingActionButton: isLoading
            ? null
            : FloatingActionButton.extended(
                label: Text(
                  'Take Test',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                backgroundColor: Color(0xFF205072),
                onPressed: () {
                  Navigator.of(context).popAndPushNamed(
                    AudioTestRules.routeName,
                    arguments: {
                      'userId': userId,
                      'audNum': audNum,
                      'nullTest': nullTest,
                    },
                  );
                },
              ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: RefreshIndicator(
          onRefresh: () => _refreshAudioTests(context),
          backgroundColor: Color(0xFF205072),
          child: isLoading
              ? Center(
                  child: SpinKitCircle(
                    color: Color(0xFF205072),
                  ),
                )
              : nullTest
                  ? Column(
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
                    )
                  : Consumer<AudioTests>(
                      builder: (context, value, child) =>
                          AudioTestList(userId)),
        ));
  }
}
