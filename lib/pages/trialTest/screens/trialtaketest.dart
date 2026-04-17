import 'dart:math';

import 'package:englishcoach/config/color.dart';
import 'package:englishcoach/pages/trial/providers/modules.dart';
import 'package:englishcoach/pages/trial/utils/toast_widget.dart';
import 'package:englishcoach/pages/trialTest/Models/trial_marksheet.dart';
import 'package:englishcoach/pages/trialTest/Models/trial_option.dart';
import 'package:englishcoach/pages/trialTest/Models/trial_question.dart';
import 'package:englishcoach/pages/trialTest/Models/trial_test.dart';
import 'package:englishcoach/pages/trialTest/Models/unlock.dart';
import 'package:englishcoach/pages/trialTest/providers/module_unlock.dart';
import 'package:englishcoach/pages/trialTest/providers/trial_answered.dart';
import 'package:englishcoach/pages/trialTest/providers/trial_options.dart';
import 'package:englishcoach/pages/trialTest/providers/trial_questions.dart';
import 'package:englishcoach/pages/trialTest/providers/trial_tests.dart';
import 'package:englishcoach/pages/trialTest/screens/congratsscreen.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/material.dart';

import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class TrialTaketest extends StatefulWidget {
  static const routename = '/trialtaketest';
  @override
  _TrialTaketestState createState() => _TrialTaketestState();
}

class _TrialTaketestState extends State<TrialTaketest>
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
        _isloading = true;
        final randomQuestions =
            Provider.of<TrialQuestion>(context, listen: false).randomQues();
        exerciseQuestions = randomQuestions;
        _loadedQuestion = false;
        Provider.of<TrialOption>(context, listen: false)
            .fetchOptions(exerciseQuestions[questionIndex].trailMcqNum)
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

  List<Trialoptions> mcqoptionsList = [];
  var _addedMarksheet = Trialmarksheet(
    testId: null,
    trailMcqNum: null,
    trialAns: null,
    // prelimMcquesNum: null,
    // prelimAns: null,
  );

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
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
    final routeArgs = ModalRoute.of(context)!.settings.arguments as Map;
    final userId = routeArgs['userId'];
    final modId = routeArgs['modId'];
    var _addTest = Trialtests(
      modId: modId,
      userId: userId,
    );
    if (_isInit) {
      setState(() {
        _isloading = true;
      });
      Provider.of<TrialQuestion>(context, listen: false)
          .fetchQuestions(modId)
          .then((_) {
            if (_loadedQuestion) {
              final randomQuestions =
                  Provider.of<TrialQuestion>(context, listen: false)
                      .randomQues();
              exerciseQuestions = randomQuestions;
              _loadedQuestion = false;
            }
          })
          .then((_) {
            Provider.of<TrialOption>(context, listen: false)
                .fetchOptions(exerciseQuestions[questionIndex].trailMcqNum)
                .then((option) {
                  mcqoptionsList = option;
                })
                .then((_) => Provider.of<TrialTest>(context, listen: false)
                    .addTest(_addTest))
                .then((id) {
                  setState(() {
                    currentTestId = id;
                    print(currentTestId);
                    _isloading = false;
                    resetTimer();
                  });
                });
          })
          .then((_) => Provider.of<TrialModuleUnlock>(context, listen: false)
              .fetchLocks(userId))
          .then((_) => Provider.of<TrialModules>(context, listen: false)
              .fetchTrialModules());
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  List<Trialquestions> exerciseQuestions = [];
  var _loadedQuestion = true;

  // _showpassDialog() {
  //   showDialog(
  //       barrierDismissible: true,
  //       context: context,
  //       builder: (_) => AlertDialog(
  //             title: Text("Congratulations"),
  //             content: Text("Hey! I'm Coflutter!"),
  //             actions: <Widget>[
  //               FlatButton(
  //                 child: Text('Close me!'),
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 },
  //               )
  //             ],
  //           ));
  // }

  final facebookAppevents = FacebookAppEvents();

  @override
  Widget build(BuildContext context) {
    //final getuserid = ModalRoute.of(context).settings.arguments;
    final questionData =
        Provider.of<TrialQuestion>(context, listen: false).trialquestions;

    var questionCount = questionData.length = 5;

    for (var i = 0; i < mcqoptionsList.length; i++) {
      print(mcqoptionsList[i].trialMcqAnswer);
    }

    return WillPopScope(
      onWillPop: () async {
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
      },
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
                                    .trailMcqQuestion!,
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
                            // choiceButton(3),
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
          selectedOption = mcqoptionsList[pos].trialMcqId.toString();
        });
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 12 / 140,
        width: double.infinity,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(
              width: 2,
              color: selectedOption == mcqoptionsList[pos].trialMcqId.toString()
                  ? Colors.green
                  : Colors.black38),
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: Row(
          children: [
            SizedBox(width: 10),
            selectedOption == mcqoptionsList[pos].trialMcqId.toString()
                ? Icon(
                    Icons.check_circle,
                    color: accentcolor,
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

  void _saveForm() async {
    final routeArgs = ModalRoute.of(context)!.settings.arguments as Map;
    final userId = routeArgs['userId'];
    final modId = routeArgs['modId'];
    _isloading = true;

    final moduleData =
        Provider.of<TrialModules>(context, listen: false).chapters;
    final moduleLimit = moduleData.length;

    final questionData =
        Provider.of<TrialQuestion>(context, listen: false).trialquestions;

    var questionCount = questionData.length = 5;

    Provider.of<TrialOption>(context, listen: false)
        .fetchOptions(exerciseQuestions[questionIndex + 1].trailMcqNum)
        .then((option) {
      mcqoptionsList = option;
    }).then((_) {
      setState(() {
        print(selectedOption);

        if (questionIndex != null) if (questionIndex < questionCount - 1) {
          _addedMarksheet = Trialmarksheet(
            userId: userId,
            testId: currentTestId,
            trailMcqNum: exerciseQuestions[questionIndex].trailMcqNum,
            trialAns: int.parse(selectedOption),
            // prelimMcquesNum: exerciseQuestions[questionIndex].prelimMcquesNum,
            // prelimAns: int.parse(selectedOption),
          );

          Provider.of<TrialAnswered>(context, listen: false)
              .addNewMarksheet(_addedMarksheet);
          print('before:' + totalMark.toString());

          if (selectedOption ==
              exerciseQuestions[questionIndex].trialMcqId.toString()) {
            totalMark = totalMark + 1;
            print('after:' + totalMark.toString());
          }

          questionIndex++;
        } else {
          _addedMarksheet = Trialmarksheet(
            userId: userId,
            testId: currentTestId,
            trailMcqNum: exerciseQuestions[questionIndex].trailMcqNum,
            trialAns: int.parse(selectedOption),
            // prelimMcquesNum: exerciseQuestions[questionIndex].prelimMcquesNum,
            // prelimAns: int.parse(selectedOption),
          );

          Provider.of<TrialAnswered>(context, listen: false)
              .addNewMarksheet(_addedMarksheet);

          if (selectedOption ==
              exerciseQuestions[questionIndex].trialMcqId.toString()) {
            totalMark = totalMark + 1;
            print('last:' + totalMark.toString());
          }

          totalMark = ((totalMark / questionCount) * 100);
          Provider.of<TrialTest>(context, listen: false)
              .updateTest(currentTestId, totalMark.round());
          // Navigator.of(context)
          //     .pushReplacementNamed(TransLandingPage.routeName, arguments: {
          //   'userid': int.parse(userId),
          //   'testid': currentTestId,
          //   'totalmark': totalMark.round(),
          // });

          final unlockCount =
              Provider.of<TrialModuleUnlock>(context, listen: false)
                  .countLength;

          if (unlockCount != moduleLimit) {
            final latestUnlockedMod =
                Provider.of<TrialModules>(context, listen: false)
                    .nextModuleId((unlockCount - 1));
            final nextUnlockMod =
                Provider.of<TrialModules>(context, listen: false)
                    .nextModuleId(unlockCount);
            var _isUnlocked =
                Provider.of<TrialModuleUnlock>(context, listen: false)
                    .checkUnlocked(nextUnlockMod);
            final routeArgs = ModalRoute.of(context)!.settings.arguments as Map;
            if (totalMark >= 60) {
              if (!_isUnlocked) {
                if (routeArgs['modId'] == latestUnlockedMod) {
                  print('Inside');
                  var _unlocks = Unlock(
                    userId: userId,
                    modNum: nextUnlockMod,
                    mLockOpenNow: 1,
                    mLockUnlockedTime: DateTime.now(),
                  );
                  Provider.of<TrialModuleUnlock>(context, listen: false)
                      .unLockNextModule(_unlocks);
                  final modName =
                      Provider.of<TrialModules>(context, listen: false)
                          .findById(nextUnlockMod);

                  // showToastWidget(
                  //   ToastWidget(
                  //     title: 'Module Unlocked',
                  //     description: modName.modName,
                  //   ),
                  // );
                  //     duration: Duration(seconds: 10));

                  // Fluttertoast.showToast(
                  //   msg: " Video Content is Unlocked for ${modName.modName}",
                  //   toastLength: Toast.LENGTH_LONG,
                  //   gravity: ToastGravity.TOP,
                  //   timeInSecForIos: 10,
                  //   backgroundColor: accentcolor,
                  //   textColor: Colors.white,
                  //   fontSize: 16.0,
                  // );

                  facebookAppevents.logEvent(
                      name: "Trial Content ${modName.modName} Completed",
                      parameters: {
                        "userid": userId,
                        "modid": latestUnlockedMod,
                      });
                }
                print('Outside');
              }
            }
          } else {
            facebookAppevents.logEvent(name: "Trial Completed", parameters: {
              "userid": userId,
              "subname": "Trail modules fully completed"
            });
          }

          Navigator.of(context)
              .pushReplacementNamed(CongratsScreen.routename, arguments: {
            'userId': userId,
            'mod': modId,
            'total': totalMark.round(),
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
                      style: Theme.of(context).textTheme.headlineLarge,
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
