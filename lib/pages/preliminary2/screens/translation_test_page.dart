import 'package:englishcoach/pages/preliminary2/screens/prelims_scorecard.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../config/responsive.dart';
import '../models/question.dart';
import '../models/answer.dart';
import '../models/marksheet.dart';
import '../providers/questions.dart';
import '../providers/marksheets.dart';
import '../providers/tests.dart';
import '../providers/answers.dart';

class TranslationTest extends StatefulWidget {
  TranslationTest({Key? key}) : super(key: key);
  static const routeName = '/translation-test';

  @override
  _TranslationTestState createState() => _TranslationTestState();
}

class _TranslationTestState extends State<TranslationTest>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  String selectedOption = "0";

  AppLifecycleState? _notification;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _notification = state;
      if (_notification == AppLifecycleState.paused) {
        setState(() {
          resetTimer();
          _textController.clear();
          final randomQuestions =
              Provider.of<PrelimTransQuestions>(context, listen: false)
                  .randomQues();
          transQuestions = randomQuestions;
        });
      }
    });
  }

  static final _orderformKey = GlobalKey<FormFieldState<String>>();
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  var _isInit = true;
  var _isBusy = true;
  var _isLoading = false;
  var questionIndex = 0;
  double totalMark = 0;
  var questionCount = 10;
  var totalQuestionCount = 10;
  var questionCounter = 1;
  final _answerFocusNode = FocusNode();
  List<PrelimTransQuestion> transQuestions = [];
  List<PrelimTransAnswer> transAnswersList = [];
  var _loadedQuestion = true;
  var _addedMarksheet = PrelimTransMarksheet(
    prelimTransAnsId: null,
    testId: null,
    userId: null,
    prelimTransQuesNum: null,
    prelimTransAnswered: null,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _answerFocusNode.dispose();
    WidgetsBinding.instance.removeObserver(this);
    animationController?.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      if (!mounted) return;
      setState(() {
        _isLoading = true;
      });
      Provider.of<PrelimTransQuestions>(context, listen: false)
          .fetchQuestions()
          .then((_) {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
          resetTimer();
        });
        if (_loadedQuestion) {
          final randomQuestions =
              Provider.of<PrelimTransQuestions>(context, listen: false)
                  .randomQues();
          transQuestions = randomQuestions;
          _loadedQuestion = false;
        }
      });
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  AnimationController? animationController;

  String get timerString {
    Duration duration =
        animationController!.duration! * animationController!.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  var valid = true;

  @override
  Widget build(BuildContext context) {
    final totalQuestions =
        Provider.of<PrelimTransQuestions>(context, listen: false)
            .transQuestions;
    // final questioncount = totalQuestions.length = 10;
    questionCount = 10;

    Size size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        body: _isLoading
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
                                    height: 55,
                                    width: 55,
                                    child: timeRemaining(),
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child: Center(
                                  child: Text(
                                    (questionCounter).toString() +
                                        ' of ' +
                                        (totalQuestionCount).toString(),
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
                                    transQuestions[questionIndex]
                                        .prelimTransQuestion!,
                                    style: TextStyle(
                                      fontSize: Responsive.isDesktop(context) ||
                                              Responsive.isTablet(context)
                                          ? 16
                                          : size.width * .035,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 3,
                                fit: FlexFit.tight,
                                child: Center(
                                  child: TextFormField(
                                    key: _orderformKey,
                                    textAlign: TextAlign.center,
                                    textInputAction: TextInputAction.none,
                                    autocorrect: false,
                                    enableSuggestions: false,
                                    autofocus: true,
                                    focusNode: _answerFocusNode,
                                    keyboardType: TextInputType.visiblePassword,
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
              ),
      ),
    );
  }

  void _saveForm() {
    final routeArgs = ModalRoute.of(context)!.settings.arguments as Map;
    final userid = routeArgs['userid'];
    final testid = routeArgs['testid'];
    final mcqpoints = routeArgs['mcqpoints'];

    final totalQuestions =
        Provider.of<PrelimTransQuestions>(context, listen: false)
            .transQuestions;
    var questioncount = totalQuestions.length = 10;
    questionCount = questioncount;

    Provider.of<PrelimTransAnswers>(context, listen: false)
        .fetchAnswer(transQuestions[questionIndex].prelimTransQuesNum!)
        .then((ans) {
      transAnswersList = ans;
    }).then((_) {
      if (!mounted) return;
      setState(() {
        final isValid = _formKey.currentState!.validate();
        if (!isValid) {
          return;
        }

        _addedMarksheet = PrelimTransMarksheet(
          testId: testid,
          userId: userid,
          prelimTransQuesNum: transQuestions[questionIndex].prelimTransQuesNum,
          prelimTransAnswered: _textController.text,
        );

        Provider.of<PrelimTransMarksheets>(context, listen: false)
            .addNewMarksheet(_addedMarksheet);

        if (questionIndex < questionCount - 1) {
          for (var i = 0; i < transAnswersList.length; i++) {
            print(transAnswersList[i].prelimTransAnswer);
            if (_addedMarksheet.prelimTransAnswered!.trim() ==
                transAnswersList[i].prelimTransAnswer!.trim()) {
              totalMark = totalMark + 1;
            }
          }
          questionIndex++;
          questionCounter++;
          setState(() {
            _isBusy = true;
          });
        } else {
          for (var i = 0; i < transAnswersList.length; i++) {
            print(transAnswersList[i].prelimTransAnswer);
            if (_addedMarksheet.prelimTransAnswered!.trim() ==
                transAnswersList[i].prelimTransAnswer!.trim()) {
              totalMark = totalMark + 1;
            }
          }

          totalMark = ((totalMark / questionCount) * 100);
          print(totalMark.toString());
          Provider.of<PrelimTransTests>(context, listen: false)
              .updateTest(testid, mcqpoints, totalMark.round());
          Provider.of<PrelimTransTests>(context, listen: false)
              .setUserLevel(userid, mcqpoints, totalMark.round());

          Navigator.of(context).pushReplacementNamed(ScoreCard.routeName,
              arguments: {
                'testid': testid,
                'userid': userid,
                'mcq': mcqpoints,
                'trans': totalMark.round()
              });
        }
        _textController.clear();
        resetTimer();
      });
    });
    _formKey.currentState!.save();
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
      child: Stack(
        children: <Widget>[
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
              },
            ),
          )
        ],
      ),
    );
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
