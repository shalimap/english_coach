import 'package:englishcoach/pages/trialTest/Models/trial_option.dart';
import 'package:englishcoach/pages/trialTest/providers/trial_options.dart';
import 'package:englishcoach/pages/trialTest/providers/trial_questions.dart';
import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class TrialReportTile extends StatefulWidget {
  final int trailMcqNum;
  final int testId;
  final int trialAns;
  final int index;

  TrialReportTile(this.trailMcqNum, this.testId, this.trialAns, this.index);
  @override
  _TrialReportTileState createState() => _TrialReportTileState();
}

class _TrialReportTileState extends State<TrialReportTile> {
  var _isLoading = false;
  var _isInit = true;
  var _correct = false;

  List<Trialoptions> mcqoptionsList = [];

  @override
  void didChangeDependencies() {
    if (_isInit) {
      if (!mounted) return;
      setState(() {
        _isLoading = true;
      });
      Provider.of<TrialOption>(context, listen: false)
          .fetchOptions(widget.trailMcqNum)
          .then((option) {
        mcqoptionsList = option;

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
        Provider.of<TrialQuestion>(context).findQuestions(widget.trailMcqNum);

    if (widget.trialAns.toString() == loadedQuestion.trialMcqId.toString()) {
      setState(() {
        _correct = true;
      });
    }

    return _isLoading
        ? Center(
            child: SpinKitThreeBounce(
              color: Colors.transparent,
            ),
          )
        : SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
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
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    loadedQuestion.trailMcqQuestion.toString(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                choiceButton(0),
                choiceButton(1),
                choiceButton(2),
                SizedBox(
                  height: 40,
                ),
              ],
            ),
          );
  }

  Widget choiceButton(int pos) {
    final loadedQuestion =
        Provider.of<TrialQuestion>(context).findQuestions(widget.trailMcqNum);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: MediaQuery.of(context).size.height * 12 / 140,
        width: double.infinity,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: Colors.black38),
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: Row(
          children: [
            SizedBox(width: 10),
            mcqoptionsList[pos].trialMcqId.toString() ==
                    widget.trialAns.toString()
                ? widget.trialAns.toString() ==
                        loadedQuestion.trialMcqId.toString()
                    ? Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      )
                    : Icon(
                        Icons.cancel,
                        color: Colors.red,
                      )
                : mcqoptionsList[pos].trialMcqId.toString() ==
                        loadedQuestion.trialMcqId.toString()
                    ? Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      )
                    : Icon(
                        Icons.adjust,
                        color: Colors.grey,
                      ),
            SizedBox(width: 15),
            Text(mcqoptionsList[pos].trialMcqAnswer!),
          ],
        ),
      ),
    );
  }
}
