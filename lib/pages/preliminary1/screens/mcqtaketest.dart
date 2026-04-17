import 'dart:math';

import 'package:englishcoach/common_widgets/toast_widget.dart';
import 'package:englishcoach/config/color.dart';
import 'package:englishcoach/pages/preliminary1/Models/mcq_marksheet.dart';
import 'package:englishcoach/pages/preliminary1/Models/mcq_option.dart';
import 'package:englishcoach/pages/preliminary1/Models/mcq_question.dart';
import 'package:englishcoach/pages/preliminary1/Models/mcq_test.dart';
import 'package:englishcoach/pages/preliminary1/providers/mcq_answered.dart';
import 'package:englishcoach/pages/preliminary1/providers/mcq_options.dart';
import 'package:englishcoach/pages/preliminary1/providers/mcq_questions.dart';
import 'package:englishcoach/pages/preliminary1/providers/mcq_tests.dart';
import 'package:englishcoach/pages/preliminary2/screens/landing_page.dart';
import 'package:flutter/material.dart';

import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class McqTaketest extends StatefulWidget {
  static const routename = '/mcqtaketest';
  @override
  _McqTaketestState createState() => _McqTaketestState();
}

class _McqTaketestState extends State<McqTaketest>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  String selectedOption = "0";
  AppLifecycleState? _notification;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _notification = state;

      if (_notification == AppLifecycleState.paused) {
        _isloading = true;
        final randomQuestions =
            Provider.of<McqQuestion>(context, listen: false).randomQues();
        exerciseQuestions = randomQuestions;
        _loadedQuestion = false;
        Provider.of<McqOption>(context, listen: false)
            .fetchOptions(exerciseQuestions[questionIndex].prelimMcquesNum)
            .then((option) {
          mcqoptionsList = option;
        }).then((_) {
          setState(() {
            _isloading = false;
            resetTimer();
          });
        });
      }
    });
  }

  var questionIndex = 0;
  double totalMark = 0;

  var _isBusy = true;
  var currentTestId;
  var _isloading = false;
  var _isInit = true;

  List<Mcqoptions> mcqoptionsList = [];
  var _addedMarksheet = Mcqmarksheet(
    testId: null,
    prelimMcquesNum: null,
    prelimAns: null,
  );

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    animationController?.dispose();
    super.dispose();
  }

  AnimationController? animationController;

  String get timerString {
    Duration duration =
        animationController!.duration! * animationController!.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  void didChangeDependencies() {
    final userId = ModalRoute.of(context)!.settings.arguments;
    var _addTest = Mcqtests(
      userId: int.parse(userId.toString()),
    );
    if (_isInit) {
      setState(() {
        _isloading = true;
      });
      Provider.of<McqQuestion>(context, listen: false)
          .fetchQuestions()
          .then((_) {
        if (_loadedQuestion) {
          final randomQuestions =
              Provider.of<McqQuestion>(context, listen: false).randomQues();
          exerciseQuestions = randomQuestions;
          _loadedQuestion = false;
        }
      }).then((_) {
        Provider.of<McqOption>(context, listen: false)
            .fetchOptions(exerciseQuestions[questionIndex].prelimMcquesNum)
            .then((option) {
              mcqoptionsList = option;
            })
            .then((_) =>
                Provider.of<McqTest>(context, listen: false).addTest(_addTest))
            .then((id) {
              setState(() {
                currentTestId = id;
                print(currentTestId);
                _isloading = false;
                resetTimer();
              });
            });
      });
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  List<Mcqquestions> exerciseQuestions = [];
  var _loadedQuestion = true;
  Future<bool> _willpopScope() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Center(
              child: Text('Alert'),
            ),
            content: Text('You cannot go back at this stage'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('ok'))
            ],
          ),
        ) ??
        false;
  }

  var questionCount = 10;

  @override
  Widget build(BuildContext context) {
    //final getuserid = ModalRoute.of(context).settings.arguments;
    // final questionData =
    //     Provider.of<McqQuestion>(context, listen: false).mcqquestions;

    //questionCount = questionData.length = 10;

    for (var i = 0; i < mcqoptionsList.length; i++) {
      print(mcqoptionsList[i].prelimMcqAnswer);
    }

    return WillPopScope(
      onWillPop: _willpopScope,
      child: Scaffold(
        body: _isloading
            ? Center(
                child: SpinKitCircle(
                  color: Color(0xFF205072),
                ),
              )
            : SafeArea(
                child: Container(
                  padding: EdgeInsets.all(10),
                  color: Color(0xFF205072),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      color: Colors.white,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Center(
                                child: Container(
                              width: 80,
                              height: 80,
                              child: timeRemaining(),
                            )),
                            Center(
                              child: Text(
                                (questionIndex + 1).toString() +
                                    ' of ' +
                                    (questionCount).toString(),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Center(
                              child: Text(
                                exerciseQuestions[questionIndex]
                                    .prelimMcquesQuestion!,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            choiceButton(0),
                            choiceButton(1),
                            choiceButton(2),
                            choiceButton(3),
                            MaterialButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              color: Color(0xFF56c590),
                              textColor: Colors.white,
                              child: Text('Submit'),
                              onPressed: () {
                                if (selectedOption != "0") {
                                  _saveForm();
                                } else {
                                  showToastWidget(
                                    ToastWidget(
                                      title: '',
                                      description: 'select an answer ',
                                    ),
                                    duration: Duration(seconds: 3),
                                    dismissOtherToast: true,
                                  );
                                }

                                setState(() {
                                  _isBusy = false;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget choiceButton(int pos) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedOption = mcqoptionsList[pos].prelimMcqId.toString();
        });
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 12 / 140,
        width: double.infinity,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(
              width: 2,
              color:
                  selectedOption == mcqoptionsList[pos].prelimMcqId.toString()
                      ? Colors.green
                      : Colors.black38),
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: Row(
          children: [
            SizedBox(width: 10),
            selectedOption == mcqoptionsList[pos].prelimMcqId.toString()
                ? Icon(
                    Icons.check_circle,
                    color: accentcolor,
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

  void _saveForm() async {
    final userId = ModalRoute.of(context)!.settings.arguments;
    _isloading = true;

    final questionData =
        Provider.of<McqQuestion>(context, listen: false).mcqquestions;

    var questionCount = questionData.length = 10;

    Provider.of<McqOption>(context, listen: false)
        .fetchOptions(exerciseQuestions[questionIndex + 1].prelimMcquesNum)
        .then((option) {
      mcqoptionsList = option;
    }).then((_) {
      setState(() {
        print(selectedOption);

        if (questionIndex < questionCount - 1) {
          _addedMarksheet = Mcqmarksheet(
            userId: int.parse(userId.toString()),
            testId: currentTestId,
            prelimMcquesNum: exerciseQuestions[questionIndex].prelimMcquesNum,
            prelimAns: int.parse(selectedOption),
          );

          Provider.of<McqAnswered>(context, listen: false)
              .addNewMarksheet(_addedMarksheet);
          print('before:' + totalMark.toString());

          if (selectedOption ==
              exerciseQuestions[questionIndex].prelimMcqId.toString()) {
            totalMark = totalMark + 1;
            print('after:' + totalMark.toString());
          }

          questionIndex++;
        } else {
          _addedMarksheet = Mcqmarksheet(
            userId: int.parse(userId.toString()),
            testId: currentTestId,
            prelimMcquesNum: exerciseQuestions[questionIndex].prelimMcquesNum,
            prelimAns: int.parse(selectedOption),
          );

          Provider.of<McqAnswered>(context, listen: false)
              .addNewMarksheet(_addedMarksheet);

          if (selectedOption ==
              exerciseQuestions[questionIndex].prelimMcqId.toString()) {
            totalMark = totalMark + 1;
            print('last:' + totalMark.toString());
          }

          totalMark = ((totalMark / questionCount) * 100);
          Navigator.of(context)
              .pushReplacementNamed(TransLandingPage.routeName, arguments: {
            'userid': int.parse(userId.toString()),
            'testid': currentTestId,
            'totalmark': totalMark.round(),
          });
        }

        print('totalmark :' + totalMark.round().toString());
        resetTimer();
        _isloading = false;
      });
    });
  }

  resetTimer() {
    selectedOption = "0";
    animationController?.dispose();
    animationController = AnimationController(
        vsync: this, duration: Duration(seconds: 60)); // timer count setting
    animationController!.reverse(
        from: animationController!.value == 0.0
            ? 1.0
            : animationController!.value);
    animationController!.addStatusListener((AnimationStatus status) {
      print(status);
      if (status == AnimationStatus.dismissed) _saveForm();
    });
  }

  Widget timeRemaining() {
    return AspectRatio(
        aspectRatio: 1.0,
        child: Stack(children: <Widget>[
          Positioned.fill(
            child: AnimatedBuilder(
              animation: animationController!,
              builder: (BuildContext context, Widget? child) {
                return CustomPaint(
                  painter: TimerPainter(
                      animation: animationController!,
                      backgroundColor: Colors.black26,
                      color: Theme.of(context).colorScheme.secondary),
                );
              },
            ),
          ),
          Align(
              alignment: FractionalOffset.center,
              child: AnimatedBuilder(
                  animation: animationController!,
                  builder: (_, Widget? child) {
                    return Text(
                      timerString,
                      style: Theme.of(context).textTheme.titleLarge,
                    );
                  }))
        ]));
  }
}

class TimerPainter extends CustomPainter {
  final Animation<double>? animation;
  final Color? backgroundColor;
  final Color? color;

  TimerPainter({this.animation, this.backgroundColor, this.color})
      : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor!
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = color!;
    double progress = (1.0 - animation!.value) * 2 * pi;
    canvas.drawArc(Offset.zero & size, pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(TimerPainter old) {
    return animation!.value != old.animation!.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}
