import 'package:google_fonts/google_fonts.dart';

import '../providers/final_test_marksheet.dart';
import '../providers/final_test_questions.dart';

import '../widgets/final_test_tile.dart';
import '../models/final_answers.dart';
import '../providers/final_test_answers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ReportDetailscreen extends StatefulWidget {
  static const routename = '/finalreportdetailscreen';

  @override
  _ReportDetailscreenState createState() => _ReportDetailscreenState();
}

class _ReportDetailscreenState extends State<ReportDetailscreen> {
  var _isInit = true;
  var isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        isLoading = true;
      });
      final FinalTestTile testIdMark =
          ModalRoute.of(context)!.settings.arguments as FinalTestTile;
      Provider.of<FinaltestMarksheet>(context)
          .fetchMarksheet(testIdMark.finalTestId)
          .then((_) => setState(() {
                isLoading = false;
              }));
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final FinalTestTile testIdMark =
        ModalRoute.of(context)!.settings.arguments as FinalTestTile;
    final loadedTest = Provider.of<FinaltestMarksheet>(context)
        .findByTestId(testIdMark.finalTestId);

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
          'Test Report',
          style: GoogleFonts.solway(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
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
                    'Marks Scored',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    testIdMark.finalTestPoints.toString(),
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
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
              : Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(10.0),
                    shrinkWrap: true,
                    itemCount: loadedTest.length,
                    itemBuilder: (ctx, i) => FinalReportTile(
                      loadedTest[i].fmarksheetId!,
                      loadedTest[i].finalTestId!,
                      loadedTest[i].finalQuesNumber!,
                      loadedTest[i].finalUserAnswer!,
                      i,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

class FinalReportTile extends StatefulWidget {
  final int fmarksheetId;
  final int finalTestId;
  final int finalQuesNumber;
  final String finalUserAnswer;
  final int index;

  FinalReportTile(this.fmarksheetId, this.finalTestId, this.finalQuesNumber,
      this.finalUserAnswer, this.index);

  @override
  _FinalReportTileState createState() => _FinalReportTileState();
}

class _FinalReportTileState extends State<FinalReportTile> {
  var _isLoading = false;
  var _isInit = true;
  var _correct = false;
  List<Finalanswer> loadedFinalAnswer = [];

  @override
  void didChangeDependencies() {
    if (_isInit) {
      if (!mounted) return;
      setState(() {
        _isLoading = true;
      });
      Provider.of<FinaltestAnswers>(context, listen: false)
          .fetchAnswer(widget.finalQuesNumber)
          .then((answer) {
        loadedFinalAnswer = answer;
        if (!mounted) return;

        setState(() {
          _isLoading = false;
        });
      });
      _isInit = false;
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final loadedQuestion =
        Provider.of<FinaltestQuestions>(context, listen: false)
            .findQuestions(widget.finalQuesNumber);

    for (var i = 0; i < loadedFinalAnswer.length; i++) {
      if (widget.finalUserAnswer.trim() == loadedFinalAnswer[i].finalAnswers) {
        setState(() {
          _correct = true;
        });
      }
    }

    Widget _checkFinalAnswer() {
      for (var i = 0; i < loadedFinalAnswer.length; i++) {
        if (widget.finalUserAnswer.toLowerCase() ==
            loadedFinalAnswer[0].finalAnswers!.toLowerCase()) {
          return Text(
            'Accurate Answer - ' + loadedFinalAnswer[0].finalAnswers!,
            style: TextStyle(color: Colors.green, fontSize: 15),
          );
        }
      }
      for (var i = 1; i < loadedFinalAnswer.length; i++) {
        if (widget.finalUserAnswer.toLowerCase() ==
            loadedFinalAnswer[i].finalAnswers!.toLowerCase()) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  'Your Translation :  ' + widget.finalUserAnswer,
                  style: TextStyle(color: Colors.orangeAccent, fontSize: 15),
                ),
              ),
              Text(
                'Accurate Translation :  ' + loadedFinalAnswer[0].finalAnswers!,
                style: TextStyle(color: Colors.green, fontSize: 15),
              ),
            ],
          );
        }
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Padding(padding: EdgeInsets.all(5)),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              'Your Translation :  ' + widget.finalUserAnswer,
              style: TextStyle(color: Colors.red, fontSize: 15),
            ),
          ),
          Text(
            'Accurate Translation :  ' + loadedFinalAnswer[0].finalAnswers!,
            style: TextStyle(color: Colors.green, fontSize: 15),
          ),
        ],
      );
    }

    return _isLoading
        ? Center(
            child: SpinKitThreeBounce(
              color: Color(0xFF56c590),
            ),
          )
        : SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [
                          _correct
                              ? Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                )
                              : Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Question No ' + (widget.index + 1).toString(),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 35,
                          ),
                          Text(
                            loadedQuestion.finalQuestions!,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 35,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 8),
                            child: _checkFinalAnswer(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}
