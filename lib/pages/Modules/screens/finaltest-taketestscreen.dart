import 'dart:math';
import 'package:englishcoach/pages/Modules/utils/toast_widget.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../models/final_answers.dart';
import '../models/final_marksheet.dart';
import '../models/final_qusetions.dart';
import '../models/final_test.dart';
import '../providers/final_test_answers.dart';
import '../providers/final_test_marksheet.dart';

import '../providers/final_test_questions.dart';
import '../providers/final_test_tests.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:oktoast/oktoast.dart';

class TaketestScreen extends StatefulWidget {
  static const routename = '/Taketestscreen';

  @override
  _TaketestScreenState createState() => _TaketestScreenState();
}

class _TaketestScreenState extends State<TaketestScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  String selectedOption = "0";

  AppLifecycleState? _notification;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _notification = state;
      if (_notification == AppLifecycleState.paused) {
        setState(() {
          resetTimer();
          _textController.clear();
          final randomQuestions =
              Provider.of<FinaltestQuestions>(context, listen: false)
                  .randomQues();
          exerciseQuestions = randomQuestions;
        });
      }
    });
  }

  final _formKey = GlobalKey<FormState>();
  final _centerKey = GlobalKey<FormState>();
  var questionIndex = 0;
  // var totalQuestionCount = 5;
  // var questionCounter = 1;
  double totalMark = 0;
  var _isBusy = true;
  var currentTestId;
  var _addedMarksheet = FinalMarksheet(
    finalTestId: null,
    finalQuesNumber: null,
    finalUserAnswer: '',
  );
  final _answerFocusNode = FocusNode();
  final _textController = TextEditingController();
  var _isloading = false;
  var _isInit = true;
  List<Finalanswer> finalAnswersList = [];

  @override
  void dispose() {
    _answerFocusNode.dispose();
    WidgetsBinding.instance!.removeObserver(this);
    animationController?.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    final userId = ModalRoute.of(context)!.settings.arguments;
    var _addTest = Finaltests(
      userId: int.parse(userId.toString()),
    );
    if (_isInit) {
      setState(() {
        _isloading = true;
      });
      Provider.of<FinaltestQuestions>(context, listen: false)
          .fetchQuestions()
          .then((_) => Provider.of<FinalTestChecks>(context, listen: false)
              .addTest(_addTest))
          .then((id) {
        setState(() {
          currentTestId = id;
          _isloading = false;
          resetTimer();
        });
        if (_loadedQuestion) {
          final randomQuestions =
              Provider.of<FinaltestQuestions>(context, listen: false)
                  .randomQues();
          exerciseQuestions = randomQuestions;
          _loadedQuestion = false;
        }
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  AnimationController? animationController;

  String get timerString {
    Duration duration =
        animationController!.duration! * animationController!.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  List<Finalquestion> exerciseQuestions = [];
  var _loadedQuestion = true;

  var valid = true;
  var questionCount = 10;
  @override
  Widget build(BuildContext context) {
    final questionData =
        Provider.of<FinaltestQuestions>(context, listen: false).finalquestions;

    //var questionCount = questionData.length = 10;

    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
          body: _isloading
              ? Center(
                  child: SpinKitCircle(
                    color: Color(0xFF205072),
                  ),
                )
              : SafeArea(
                  child: Form(
                    key: _formKey,
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
                              children: <Widget>[
                                Flexible(
                                  flex: 3,
                                  fit: FlexFit.tight,
                                  child: Center(
                                      child: Container(
                                    width: 55,
                                    height: 55,
                                    child: timeRemaining(),
                                  )),
                                ),
                                Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: Center(
                                    child: Text(
                                      (questionIndex + 1).toString() +
                                          ' of ' +
                                          (questionCount).toString(),
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 3,
                                  fit: FlexFit.tight,
                                  child: Center(
                                    child: Text(
                                      exerciseQuestions[questionIndex]
                                          .finalQuestions!,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Flexible(
                                  flex: 3,
                                  fit: FlexFit.tight,
                                  child: Center(
                                    child: TextFormField(
                                      key: _centerKey,
                                      textAlign: TextAlign.center,
                                      textInputAction: TextInputAction.none,
                                      autocorrect: false,
                                      enableSuggestions: false,
                                      autofocus: true,
                                      focusNode: _answerFocusNode,
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      maxLines: 2,
                                      controller: _textController,
                                      decoration: InputDecoration(
                                        labelText: "Answer",
                                        labelStyle:
                                            TextStyle(color: Color(0xFF205072)),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          borderSide: BorderSide(
                                            color: Color(0xFF205072),
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                      onFieldSubmitted: (value) {
                                        SystemChannels.textInput
                                            .invokeMethod('TextInput.hide');
                                        FocusScope.of(context)
                                            .requestFocus(_answerFocusNode);
                                      },
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 3,
                                  fit: FlexFit.tight,
                                  child: Center(
                                    child: !_isBusy
                                        ? SpinKitThreeBounce(
                                            color: Color(0xFF56c590),
                                          )
                                        : MaterialButton(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            color: Color(0xFF56c590),
                                            textColor: Colors.white,
                                            child: Text('Submit'),
                                            onPressed: () {
                                              _saveForm();
                                              setState(() {
                                                _isBusy = false;
                                              });
                                            },
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )),
    );
  }

  void _saveForm() async {
    //final userId = ModalRoute.of(context).settings.arguments;
    final questionData =
        Provider.of<FinaltestQuestions>(context, listen: false).finalquestions;

    var questionCount = questionData.length = 10;
    await Provider.of<FinaltestAnswers>(context, listen: false)
        .fetchAnswer(exerciseQuestions[questionIndex].finalQuesNumber)
        .then((answers) {
      finalAnswersList = answers;
      Provider.of<FinaltestAnswers>(context, listen: false).finalanswers;
    });

    setState(() {
      final isValid = _formKey.currentState!.validate();
      if (!isValid) {
        return;
      }
      if (questionIndex != null) if (questionIndex < questionCount - 1) {
        _addedMarksheet = FinalMarksheet(
          finalTestId: currentTestId,
          finalQuesNumber: exerciseQuestions[questionIndex].finalQuesNumber,
          finalUserAnswer: _textController.text,
        );

        Provider.of<FinaltestMarksheet>(context, listen: false)
            .addNewMarksheet(_addedMarksheet);

        for (var i = 0; i < finalAnswersList.length; i++) {
          if (finalAnswersList[i].finalAnswers!.toLowerCase() ==
              _textController.text.toLowerCase()) {
            totalMark = totalMark + 1;
          }
        }

        questionIndex++;
        setState(() {
          _isBusy = true;
        });
      } else {
        _addedMarksheet = FinalMarksheet(
          finalTestId: currentTestId,
          finalQuesNumber: exerciseQuestions[questionIndex].finalQuesNumber,
          finalUserAnswer: _textController.text,
        );
        Provider.of<FinaltestMarksheet>(context, listen: false)
            .addNewMarksheet(_addedMarksheet);
        for (var i = 0; i < finalAnswersList.length; i++) {
          if (finalAnswersList[i].finalAnswers!.toLowerCase() ==
              _textController.text.toLowerCase()) {
            totalMark = totalMark + 1;
          }
        }
        totalMark = ((totalMark / questionCount) * 100);
        Provider.of<FinalTestChecks>(context, listen: false)
            .updateTest(currentTestId, totalMark.round());

        if (totalMark >= 80) {
          showToastWidget(
              ToastWidget(
                title: 'Final Test Passed',
                description: 'Basic Course Section Completed',
              ),
              duration: Duration(seconds: 10));
        }
        Navigator.of(context).pop();
      }
      _textController.clear();
      resetTimer();
    });
  }

  resetTimer() {
    selectedOption = "0";
    animationController?.dispose();
    animationController = AnimationController(
        vsync: this, duration: Duration(seconds: 120)); // timer count setting
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
    Size size = MediaQuery.of(context).size;
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
                      style: TextStyle(fontSize: size.width * .045),
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
