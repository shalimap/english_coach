import 'package:englishcoach/pages/Modules/models/module_answer.dart';
import 'package:englishcoach/pages/Modules/providers/module_answers.dart';
import 'package:englishcoach/pages/Modules/providers/module_questions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class ModuleReportTile extends StatefulWidget {
  final int mMarkId;
  final int mTestid;
  final int exeNum;
  final String mMarkAnswer;
  final bool topic;
  final int index;

  ModuleReportTile(
    this.mMarkId,
    this.mTestid,
    this.exeNum,
    this.mMarkAnswer,
    this.topic,
    this.index,
  );

  @override
  _ModuleReportTileState createState() => _ModuleReportTileState();
}

class _ModuleReportTileState extends State<ModuleReportTile> {
  var _isLoading = false;
  var _isInit = true;
  var _correct = false;

  List<ModuleAnswer> loadedModuleAnswer = [];
  @override
  void didChangeDependencies() {
    if (_isInit) {
      if (!mounted) return;
      setState(() {
        _isLoading = true;
      });
      Provider.of<ModuleAnswers>(context, listen: false)
          .fetchAnswer(widget.exeNum)
          .then((answer) {
        loadedModuleAnswer = answer;
        if (!mounted) return;
        setState(() {
          _isLoading = false;
        });
        _isInit = false;
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final loadedModuleQuestion =
        Provider.of<ModuleQuestions>(context, listen: false)
            .findById(widget.exeNum);
    for (var i = 0; i < loadedModuleAnswer.length; i++) {
      if (widget.mMarkAnswer.trim() ==
          loadedModuleAnswer[i].modAnsAnswer!.trim()) {
        setState(() {
          _correct = true;
        });
      }
    }
    Widget _checkTopicAnswer() {
      for (var i = 0; i < loadedModuleAnswer.length; i++) {
        if (widget.mMarkAnswer.trim() ==
            loadedModuleAnswer[0].modAnsAnswer!.trim()) {
          return Text(
            'Accurate Answer - ' + loadedModuleAnswer[0].modAnsAnswer!,
            style: TextStyle(color: Colors.green, fontSize: 15),
          );
        }
      }
      for (var i = 1; i < loadedModuleAnswer.length; i++) {
        if (widget.mMarkAnswer.trim() ==
            loadedModuleAnswer[i].modAnsAnswer!.trim()) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: widget.mMarkAnswer.isEmpty
                    ? Text(
                        'Your Translation :  ' + ' Not Attended ',
                        style:
                            TextStyle(color: Colors.orangeAccent, fontSize: 15),
                      )
                    : Text(
                        'Your Translation :  ' + widget.mMarkAnswer,
                        style:
                            TextStyle(color: Colors.orangeAccent, fontSize: 15),
                      ),
              ),
              Text(
                'Accurate Translation :  ' +
                    loadedModuleAnswer[0].modAnsAnswer!,
                style: TextStyle(color: Colors.green, fontSize: 15),
              ),
            ],
          );
        }
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: widget.mMarkAnswer.isEmpty
                ? Text(
                    'Your Translation :  ' + ' Not Attended ',
                    style: TextStyle(color: Colors.orangeAccent, fontSize: 15),
                  )
                : Text(
                    'Your Translation :  ' + widget.mMarkAnswer,
                    style: TextStyle(color: Colors.red, fontSize: 15),
                  ),
          ),
          Text(
            'Accurate Translation :  ' + loadedModuleAnswer[0].modAnsAnswer!,
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
            //scrollDirection: Axis.horizontal,
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
                              loadedModuleQuestion.modQueQuestion!,
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
                              child: _checkTopicAnswer(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Divider()
                ],
              ),
            ),
          );
  }
}
