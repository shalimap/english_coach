import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../providers/topictest_questions.dart';
import '../providers/topictest_answers.dart';
import '../models/topic_answer.dart';

class TopicReportTile extends StatefulWidget {
  final int topAnsId;
  final int ttestId;
  final int topicQueNum;
  final String topicAnsAnswer;
  final bool topic;
  final int index;

  TopicReportTile(
    this.topAnsId,
    this.ttestId,
    this.topicQueNum,
    this.topicAnsAnswer,
    this.topic,
    this.index,
  );

  @override
  _TopicReportTileState createState() => _TopicReportTileState();
}

class _TopicReportTileState extends State<TopicReportTile> {
  var _isLoading = false;
  var _isInit = true;
  var _correct = false;

  List<TopicAnswer> loadedTopicAnswer = [];
  @override
  void didChangeDependencies() {
    if (_isInit) {
      if (!mounted) return;
      setState(() {
        _isLoading = true;
      });
      Provider.of<TopicTestAnswer>(context, listen: false)
          .fetchAnswer(widget.topicQueNum)
          .then((answer) {
        loadedTopicAnswer = answer;
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
    final loadedTopicQuestion =
        Provider.of<TopicTestQuestion>(context, listen: false)
            .findById(widget.topicQueNum);
    for (var i = 0; i < loadedTopicAnswer.length; i++) {
      if (widget.topicAnsAnswer.trim() ==
          loadedTopicAnswer[i].topicAnsAnswer!.trim()) {
        setState(() {
          _correct = true;
        });
      }
    }
    Widget _checkTopicAnswer() {
      for (var i = 0; i < loadedTopicAnswer.length; i++) {
        if (widget.topicAnsAnswer.trim() ==
            loadedTopicAnswer[0].topicAnsAnswer!.trim()) {
          return Text(
            'Accurate Answer - ' + loadedTopicAnswer[0].topicAnsAnswer!,
            style: TextStyle(color: Colors.green, fontSize: 15),
          );
        }
      }
      for (var i = 1; i < loadedTopicAnswer.length; i++) {
        if (widget.topicAnsAnswer.trim() ==
            loadedTopicAnswer[i].topicAnsAnswer!.trim()) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: widget.topicAnsAnswer.isEmpty
                    ? Text(
                        'Your Translation :  ' + ' Not Attended ',
                        style:
                            TextStyle(color: Colors.orangeAccent, fontSize: 15),
                      )
                    : Text(
                        'Your Translation :  ' + widget.topicAnsAnswer,
                        style:
                            TextStyle(color: Colors.orangeAccent, fontSize: 15),
                      ),
              ),
              Text(
                'Accurate Translation :  ' +
                    loadedTopicAnswer[0].topicAnsAnswer!,
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
            child: widget.topicAnsAnswer.isEmpty
                ? Text(
                    'Your Translation :  ' + ' Not Attended ',
                    style: TextStyle(color: Colors.orangeAccent, fontSize: 15),
                  )
                : Text(
                    'Your Translation :  ' + widget.topicAnsAnswer,
                    style: TextStyle(color: Colors.red, fontSize: 15),
                  ),
          ),
          Text(
            'Accurate Translation :  ' + loadedTopicAnswer[0].topicAnsAnswer!,
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
                              loadedTopicQuestion.topicQueQuestion!,
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
