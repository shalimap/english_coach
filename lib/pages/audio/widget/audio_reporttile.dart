import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/audioanswer.dart';
import '../provider/audioanswers.dart';

class AudioReportTile extends StatefulWidget {
  final loadedTest;
  final loadedAudioAnswer;

  AudioReportTile({this.loadedTest, this.loadedAudioAnswer});

  @override
  _AudioReportTileState createState() => _AudioReportTileState();
}

class _AudioReportTileState extends State<AudioReportTile> {
  var _isInit = true;
  List<AudioAnswer> loadedAudioAnswer = [];

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<AudioAnswers>(context, listen: false)
          .fetchAnswer(widget.loadedTest[0].audQuesNum)
          .then((answer) => loadedAudioAnswer = answer);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            width: size.width * 0.9,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Text(
                      'Your Answer',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      widget.loadedTest[0].audAnswered.toString(),
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
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
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            width: size.width * 0.9,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Text(
                      'Accurate Answer',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      widget.loadedAudioAnswer[0].audTextAnswer.toString(),
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
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
      ],
    );
  }
}
