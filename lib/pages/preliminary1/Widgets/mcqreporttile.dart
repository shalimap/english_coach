import 'package:englishcoach/pages/preliminary1/Models/mcq_option.dart';
import 'package:englishcoach/pages/preliminary1/providers/mcq_options.dart';
import 'package:englishcoach/pages/preliminary1/providers/mcq_questions.dart';
import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class McqReportTile extends StatefulWidget {
  final int prelimMcquesNum;
  final int testId;
  final int prelimAns;
  final int index;

  McqReportTile(this.prelimMcquesNum, this.testId, this.prelimAns, this.index);
  @override
  _McqReportTileState createState() => _McqReportTileState();
}

class _McqReportTileState extends State<McqReportTile> {
  var _isLoading = false;
  var _isInit = true;
  var _correct = false;

  List<Mcqoptions> mcqoptionsList = [];

  @override
  void didChangeDependencies() {
    if (_isInit) {
      if (!mounted) return;
      setState(() {
        _isLoading = true;
      });
      Provider.of<McqOption>(context, listen: false)
          .fetchOptions(widget.prelimMcquesNum)
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
        Provider.of<McqQuestion>(context).findQuestions(widget.prelimMcquesNum);

    // var optionss = Provider.of<McqOption>(context, listen: false)
    //     .fetchOptions(widget.prelimMcquesNum)
    //     .then((option) {
    //   mcqoptionsList = option;
    // });
    if (widget.prelimAns.toString() == loadedQuestion.prelimMcqId.toString()) {
      setState(() {
        _correct = true;
      });
    }

    // for (var i = 0; i < mcqoptionsList.length; i++) {
    //   Provider.of<McqOption>(context, listen: false)
    //       .fetchOptions(widget.prelimMcquesNum)
    //       .then((option) {
    //     mcqoptionsList = option;
    //   });
    // }

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
                    loadedQuestion.prelimMcquesQuestion.toString(),
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
                choiceButton(3),
                SizedBox(
                  height: 40,
                ),
              ],
            ),
          );
  }

  Widget choiceButton(int pos) {
    final loadedQuestion =
        Provider.of<McqQuestion>(context).findQuestions(widget.prelimMcquesNum);
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
            //widget.prelimAns.toString() == loadedQuestion.prelimMcqId.toString()
            mcqoptionsList[pos].prelimMcqId.toString() ==
                    widget.prelimAns.toString()
                ? widget.prelimAns.toString() ==
                        loadedQuestion.prelimMcqId.toString()
                    ? Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      )
                    : Icon(
                        Icons.cancel,
                        color: Colors.red,
                      )
                : mcqoptionsList[pos].prelimMcqId.toString() ==
                        loadedQuestion.prelimMcqId.toString()
                    ? Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      )
                    : Icon(
                        Icons.adjust,
                        color: Colors.grey,
                      ),
            SizedBox(width: 15),
            Text(mcqoptionsList[pos].prelimMcqAnswer!),
          ],
        ),
      ),
    );
  }
}
