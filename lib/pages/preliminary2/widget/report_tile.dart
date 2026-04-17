import 'package:englishcoach/pages/preliminary2/providers/answers.dart';
import 'package:englishcoach/pages/preliminary2/providers/questions.dart';
import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../models/answer.dart';

class TransReportTile extends StatefulWidget {
  final int marksheetId;
  final int testId;
  final int quesNumber;
  final String userAnswer;
  final int index;

  TransReportTile(this.marksheetId, this.testId, this.quesNumber,
      this.userAnswer, this.index);

  @override
  _TransReportTileState createState() => _TransReportTileState();
}

class _TransReportTileState extends State<TransReportTile> {
  var _isLoading = false;
  var _isInit = true;
  var _correct = false;
  List<PrelimTransAnswer> loadedAnswer = [];

  @override
  void didChangeDependencies() {
    if (_isInit) {
      if (!mounted) return;
      setState(() {
        _isLoading = true;
      });
      Provider.of<PrelimTransAnswers>(context, listen: false)
          .fetchAnswer(widget.quesNumber)
          .then((answer) {
        loadedAnswer = answer;
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
        Provider.of<PrelimTransQuestions>(context, listen: false)
            .findQuestions(widget.quesNumber);

    for (var i = 0; i < loadedAnswer.length; i++) {
      if (widget.userAnswer.trim() ==
          loadedAnswer[i].prelimTransAnswer!.trim()) {
        setState(() {
          _correct = true;
        });
      }
    }

    Widget _checkFinalAnswer() {
      for (var i = 0; i < loadedAnswer.length; i++) {
        if (widget.userAnswer == loadedAnswer[0].prelimTransAnswer) {
          return Text(
            'Accurate Answer - ' + loadedAnswer[0].prelimTransAnswer!,
            style: TextStyle(color: Colors.green, fontSize: 15),
          );
        }
      }
      for (var i = 1; i < loadedAnswer.length; i++) {
        if (widget.userAnswer.trim() ==
            loadedAnswer[i].prelimTransAnswer!.trim()) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: widget.userAnswer.isEmpty
                    ? Text(
                        'Your Translation :  ' + ' Not Attended ',
                        style:
                            TextStyle(color: Colors.orangeAccent, fontSize: 15),
                      )
                    : Text(
                        'Your Translation :  ' + widget.userAnswer,
                        style:
                            TextStyle(color: Colors.orangeAccent, fontSize: 15),
                      ),
              ),
              Text(
                'Accurate Translation :  ' + loadedAnswer[0].prelimTransAnswer!,
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
            child: widget.userAnswer.isEmpty
                ? Text(
                    'Your Translation :  ' + ' Not Attended ',
                    style: TextStyle(color: Colors.orangeAccent, fontSize: 15),
                  )
                : Text(
                    'Your Translation :  ' + widget.userAnswer,
                    style: TextStyle(color: Colors.red, fontSize: 15),
                  ),
          ),
          Text(
            'Accurate Translation :  ' + loadedAnswer[0].prelimTransAnswer!,
            style: TextStyle(color: Colors.green, fontSize: 15),
          ),
        ],
      );
    }

    return _isLoading
        ? Center(
            child: SpinKitThreeBounce(
              color: Colors.transparent,
            ),
          )
        : SingleChildScrollView(
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
                          Expanded(
                            flex: 1,
                            child: Text(
                              loadedQuestion.prelimTransQuestion!,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 35,
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8, bottom: 8),
                              child: _checkFinalAnswer(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Divider(),
                ],
              ),
            ),
          );
  }
}
