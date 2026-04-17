import 'package:google_fonts/google_fonts.dart';

import '../provider/audiomarksheets.dart';
import '../provider/audioquestions.dart';
import '../widget/audio_player.dart';
import '../widget/audio_testtile.dart';
import '../model/audioanswer.dart';
import '../model/audioquestion.dart';
import '../provider/audioanswers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AudioReportDetail extends StatefulWidget {
  static const routename = '/audioreportdetail';

  @override
  _AudioReportDetailState createState() => _AudioReportDetailState();
}

class _AudioReportDetailState extends State<AudioReportDetail> {
  var _isInit = true;
  var isLoading = false;
  var loadedTest;
  List<AudioAnswer> loadedAudioAnswer = [];
  List<AudioQuestion> audioQuestion = [];

  @override
  void didChangeDependencies() {
    if (_isInit) {
      if (!mounted) return;
      setState(() {
        isLoading = true;
      });
      final AudioTestTile testIdMark =
          ModalRoute.of(context)!.settings.arguments as AudioTestTile;
      Provider.of<AudioMarksheets>(context, listen: false)
          .fetchMarksheet(testIdMark.audTestId)
          .then((_) {
        final test = Provider.of<AudioMarksheets>(context, listen: false)
            .findByTestId(testIdMark.audTestId);
        loadedTest = test;
        Provider.of<AudioAnswers>(context, listen: false)
            .fetchAnswer(test[0].audQuesNum!)
            .then((answer) => loadedAudioAnswer = answer)
            .then((_) {
          final audQues = Provider.of<AudioQuestions>(context, listen: false)
              .findById(test[0].audQuesNum!);
          audioQuestion = audQues;
        }).then((_) {
          if (!mounted) return;
          setState(() {
            isLoading = false;
          });
        });
      });

      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final AudioTestTile testIdMark =
        ModalRoute.of(context)!.settings.arguments as AudioTestTile;
    Size size = MediaQuery.of(context).size;
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
          "Test Report",
          style: GoogleFonts.solway(
              textStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xFF205072)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'Accuracy Percentage',
                      style: GoogleFonts.solway(
                        textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      testIdMark.score.toString() + " %",
                      style: GoogleFonts.solway(
                        textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            isLoading
                ? Center(
                    child: SpinKitThreeBounce(
                      color: Color(0xFF56c590),
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          fit: FlexFit.loose,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              width: size.width * 0.9,
                              child: Card(
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Audio Track',
                                        style: GoogleFonts.solway(
                                          textStyle: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ),
                                      Divider(
                                        endIndent: 10,
                                        indent: 10,
                                      ),
                                      AudioPlayerUrl(
                                        audUrl: audioQuestion[0].audUrl,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.loose,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              width: size.width * 0.9,
                              child: Card(
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Your Answer',
                                        style: GoogleFonts.solway(
                                          textStyle: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ),
                                      Divider(
                                        endIndent: 10,
                                        indent: 10,
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        loadedTest[0].audAnswered.isEmpty
                                            ? 'Not Attended'
                                            : loadedTest[0]
                                                .audAnswered
                                                .toString(),
                                        style: GoogleFonts.solway(
                                          textStyle: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.loose,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              width: size.width * 0.9,
                              child: Card(
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Accurate Answer',
                                        style: GoogleFonts.solway(
                                            textStyle: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        )),
                                      ),
                                      Divider(
                                        endIndent: 10,
                                        indent: 10,
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        loadedAudioAnswer[0].audTextAnswer!,
                                        style: GoogleFonts.solway(
                                          textStyle: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
