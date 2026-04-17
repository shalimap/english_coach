import 'package:englishcoach/pages/Modules/screens/cngatsscreen.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../config/responsive.dart';
import '../models/module_question.dart';
import '../models/module_answer.dart';
import '../models/unlock.dart';
import '../models/marksheet.dart';
import '../models/tests.dart';
import '../providers/module_questions.dart';
import '../providers/module_marksheet.dart';
import '../providers/module_tests.dart';
import '../providers/module_unlock.dart';
import '../providers/modules.dart';
import '../providers/module_answers.dart';

class ModuleTest extends StatefulWidget {
  ModuleTest({Key? key}) : super(key: key);
  static const routeName = '/module-test';

  @override
  _ModuleTestState createState() => _ModuleTestState();
}

class _ModuleTestState extends State<ModuleTest>
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
              Provider.of<ModuleQuestions>(context, listen: false).randomQues();
          moduleQuestions = randomQuestions;
        });
      }
    });
  }

  static final _orderformKey = GlobalKey<FormFieldState<String>>();
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  final topic = true;
  var _isInit = true;
  var _isBusy = true;
  var _isLoading = false;
  var questionIndex = 0;
  double totalMark = 0;
  var questionCount = 10;
  var totalQuestionCount = 10;
  var questionCounter = 1;
  var currentTestId;
  final _answerFocusNode = FocusNode();
  List<ModuleQuestion> moduleQuestions = [];
  List<ModuleAnswer> moduleAnswersList = [];
  var _loadedQuestion = true;
  var _addedMarksheet = Marksheet(
    mMarkId: null,
    mTestId: null,
    exeNum: null,
    mMarkAnswer: '',
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
    final data = ModalRoute.of(context)!.settings.arguments as Map;
    final moduleId = data['mod'];
    final topicData =
        Provider.of<Modules>(context, listen: false).findTopicNum(moduleId);
    final tNum = topicData.tNum;
    final userId = data['userId'];
    var _addTest = Tests(userId: userId, modNum: moduleId);
    if (_isInit) {
      if (!mounted) return;
      setState(() {
        _isLoading = true;
      });
      Provider.of<ModuleQuestions>(context, listen: false)
          .fetchQuestions(tNum!, moduleId)
          .then((_) => Provider.of<ModuleTests>(context, listen: false)
              .addTest(_addTest))
          .then((id) {
        if (!mounted) return;
        setState(() {
          currentTestId = id;
          _isLoading = false;
          resetTimer();
        });
        if (_loadedQuestion) {
          final randomQuestions =
              Provider.of<ModuleQuestions>(context, listen: false).randomQues();
          moduleQuestions = randomQuestions;
          _loadedQuestion = false;
        }
      }).then((_) => Provider.of<ModuleUnlock>(context, listen: false)
              .fetchLocks(userId));
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
    final data = ModalRoute.of(context)!.settings.arguments as Map;
    final moduleId = data['mod'];
    final totalQuestions = Provider.of<ModuleQuestions>(context, listen: false)
        .totalModQuestions(moduleId);
    // final questioncount = totalQuestions.length = 10;
    // questionCount = questioncount;

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
                                    moduleQuestions[questionIndex]
                                        .modQueQuestion!,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 2,
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
    final data = ModalRoute.of(context)!.settings.arguments as Map;
    final moduleId = data['mod'];
    final topic = data['topic'];
    // final topicData =
    //     Provider.of<Modules>(context, listen: false).findTopicNum(moduleId);
    // final tNum = topicData.tNum;
    final userId = data['userId'];

    final moduleData = Provider.of<Modules>(context, listen: false).chapters;
    final moduleLimit = moduleData.length;

    final totalQuestions = Provider.of<ModuleQuestions>(context, listen: false)
        .totalModQuestions(moduleId);
    // var questioncount = totalQuestions.length = 10;
    // questionCount = questioncount;

    Provider.of<ModuleAnswers>(context, listen: false)
        .fetchAnswer(moduleQuestions[questionIndex].modQueNum!)
        .then((ans) {
      moduleAnswersList = ans;
    }).then((_) {
      if (!mounted) return;
      setState(() {
        final isValid = _formKey.currentState!.validate();
        if (!isValid) {
          return;
        }

        _addedMarksheet = Marksheet(
          mTestId: currentTestId,
          exeNum: moduleQuestions[questionIndex].modQueNum,
          mMarkAnswer: _textController.text,
        );

        Provider.of<ModuleMarkSheet>(context, listen: false)
            .addNewMarksheet(_addedMarksheet);

        if (questionIndex < questionCount - 1) {
          for (var i = 0; i < moduleAnswersList.length; i++) {
            print(moduleAnswersList[i].modAnsAnswer);
            if (_addedMarksheet.mMarkAnswer!.trim() ==
                moduleAnswersList[i].modAnsAnswer!.trim()) {
              totalMark = totalMark + 1;
            }
          }
          questionIndex++;
          questionCounter++;
          setState(() {
            _isBusy = true;
          });
        } else {
          for (var i = 0; i < moduleAnswersList.length; i++) {
            print(moduleAnswersList[i].modAnsAnswer);
            if (_addedMarksheet.mMarkAnswer!.trim() ==
                moduleAnswersList[i].modAnsAnswer!.trim()) {
              totalMark = totalMark + 1;
            }
          }

          totalMark = ((totalMark / questionCount) * 100);
          Provider.of<ModuleTests>(context, listen: false)
              .updateTest(currentTestId, totalMark.round());

          // final unlockCount =
          //     Provider.of<ModuleUnlock>(context, listen: false).countLength;
          final unlockCount =
              Provider.of<ModuleUnlock>(context, listen: false).length(userId);

          if (unlockCount != moduleLimit) {
            final latestUnlockedMod =
                Provider.of<Modules>(context, listen: false)
                    .nextModuleId((unlockCount - 1));
            final nextUnlockMod = Provider.of<Modules>(context, listen: false)
                .nextModuleId(unlockCount);
            var _isUnlocked = Provider.of<ModuleUnlock>(context, listen: false)
                .checkUnlocked(nextUnlockMod);
            final moduleData =
                ModalRoute.of(context)!.settings.arguments as Map;
            if (totalMark >= 80) {
              if (!_isUnlocked) {
                if (moduleData['mod'] == latestUnlockedMod) {
                  var _unlocks = Unlock(
                    userId: userId,
                    modNum: nextUnlockMod,
                    mLockOpenNow: 0,
                    mLockUnlockedTime: DateTime.now(),
                  );
                  Provider.of<ModuleUnlock>(context, listen: false)
                      .unLockNextModule(_unlocks);
                  final modName = Provider.of<Modules>(context, listen: false)
                      .findById(nextUnlockMod);

                  //   showToastWidget(
                  //       ToastWidget(
                  //         title: 'Module Unlocked',
                  //         description: modName.modName,
                  //       ),
                  //       duration: Duration(seconds: 10));
                }
              }
            }
          }
          Navigator.of(context)
              .pushReplacementNamed(Congrats.routename, arguments: {
            'mod': moduleId,
            'userId': userId,
            'topic': topic,
            'total': totalMark.round(),
          });
          // Navigator.of(context).pop();
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
                  style: Responsive.isDesktop(context) ||
                          Responsive.isTablet(context)
                      ? null
                      : TextStyle(fontSize: size.width * .045),
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
