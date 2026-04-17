import 'dart:math';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:edit_distance/edit_distance.dart';
import '../model/audioquestion.dart';
import '../provider/audioquestions.dart';
import '../widget/audio_player.dart';
import '../model/audioanswer.dart';
import '../provider/audioanswers.dart';
import '../provider/audiotests.dart';
import '../model/audiotest.dart';
import '../provider/audiomarksheets.dart';
import '../model/audiomarksheet.dart';
import '../model/audiolock.dart';
import '../provider/audios.dart';
import '../provider/audiolocks.dart';
import '../screen/audio_cngatsscreen.dart';

class AudioTaketestScreen extends StatefulWidget {
  static const routename = '/audio-taketests';

  @override
  _AudioTaketestScreenState createState() => _AudioTaketestScreenState();
}

class _AudioTaketestScreenState extends State<AudioTaketestScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  bool _isstart = false;
  bool _isInit = true;
  var _loaded = false;
  String selectedOption = "0";
  List<AudioQuestion> audioQuestions = [];
  AppLifecycleState? _notification;
  AnimationController? animationController;
  List<AudioAnswer> loadedAnswer = [];
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  String? check;
  Levenshtein d = new Levenshtein();
  var val;
  double? error;
  int? percent;
  bool listenaudio = false;
  var _addTest;
  var currentTestId;
  var _marksheet;
  bool _isBusy = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!mounted) return;
    setState(() {
      _notification = state;
      if (_notification == AppLifecycleState.paused) {
        if (!mounted) return;
        setState(() {
          resetTimer();
          _textController.clear();
          final randomQuestions =
              Provider.of<AudioQuestions>(context, listen: false).randomQues();
          audioQuestions = randomQuestions;
        });
      }
    });
  }

  void _submitAnswer() {
    final data = ModalRoute.of(context)!.settings.arguments as Map;
    final userId = data['userId'];
    final audNum = data['audNum'];
    final nullTest = data['nullTest'];
    final audioData = Provider.of<Audios>(context, listen: false).audios;
    final audioModuleLimit = audioData.length;

    print(val = d.distance(check!.trim().toLowerCase(),
        _textController.text.trim().toLowerCase()));
    print(check);
    error = ((check!.length - val) / check!.length) * 100;
    if (error! <= 0.0) {
      print('error= 0%');
    } else {
      print('error = $error');
    }
    percent = error!.round();
    print('Accuracy percentage = $percent');

    final unlockCount =
        Provider.of<AudioLocks>(context, listen: false).length(userId);

    if (unlockCount != audioModuleLimit) {
      final latestUnlockedAudioMod = Provider.of<Audios>(context, listen: false)
          .nextAudioId((unlockCount - 1));
      final nextUnlockMod =
          Provider.of<Audios>(context, listen: false).nextAudioId(unlockCount);
      var _isUnlocked = Provider.of<AudioLocks>(context, listen: false)
          .checkUnlocked(nextUnlockMod);
      if (percent! >= 70) {
        if (!_isUnlocked) {
          if (audNum == latestUnlockedAudioMod) {
            var _unlocks = AudioLock(
              userId: userId,
              audNum: nextUnlockMod,
              audLockOpen: 0,
              audUnlockedTime: DateTime.now(),
            );
            Provider.of<AudioLocks>(context, listen: false)
                .unLockNextAudio(_unlocks);
          }
        }
      }
    }
    _marksheet = AudioMarksheet(
      audTestId: currentTestId,
      userId: userId,
      audNum: audNum,
      audQuesNum: audioQuestions[0].audQuesNum,
      audAnswered: _textController.text,
    );

    Provider.of<AudioMarksheets>(context, listen: false)
        .addNewMarksheet(_marksheet)
        .then((_) {
      Provider.of<AudioTests>(context, listen: false)
          .updateTest(currentTestId, percent!);
    }).then((_) {
      // if (!mounted) return;
      setState(() {
        _isBusy = false;
      });
      // resetTimer();
      // _textController.clear();
      Navigator.of(context)
          .pushReplacementNamed(AudioCongrats.routename, arguments: {
        'userId': userId,
        'audNum': audNum,
        'percent': percent,
      });
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    resetTimer();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final data = ModalRoute.of(context)!.settings.arguments as Map;
      final userId = data['userId'];
      final audNum = data['audNum'];

      Provider.of<AudioQuestions>(context, listen: false)
          .fetchQuestions(audNum)
          .then((_) {
        final randomQuestions =
            Provider.of<AudioQuestions>(context, listen: false).randomQues();
        if (!mounted) return;
        setState(() {
          audioQuestions = randomQuestions;
        });
        _addTest = AudioTest(
          userId: userId,
          audQuesNum: audioQuestions[0].audQuesNum,
          audNum: audNum,
        );
      }).then((_) {
        Provider.of<AudioAnswers>(context, listen: false)
            .fetchAnswer(audioQuestions[0].audQuesNum!)
            .then((answer) => loadedAnswer = answer);
      }).then((_) {
        Provider.of<AudioTests>(context, listen: false)
            .addTest(_addTest)
            .then((id) {
          currentTestId = id;
          print(currentTestId.toString());
          if (!mounted) return;
          setState(() {
            _loaded = true;
          });
          _isInit = false;
        });
      });
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    animationController?.dispose();
    super.dispose();
  }

  String get timerString {
    Duration duration =
        animationController!.duration! * animationController!.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: SafeArea(
        child: Scaffold(
          body: Center(
            child: Container(
              padding: EdgeInsets.all(10),
              color: Color(0xFF205072),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: EdgeInsets.all(20),
                  color: Colors.white,
                  child: Center(
                      child: _isstart
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Flexible(
                                  flex: 3,
                                  fit: FlexFit.tight,
                                  child: Center(
                                    child: Container(
                                      height: 80,
                                      width: 80,
                                      child: timeRemaining(),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 3,
                                  fit: FlexFit.tight,
                                  child: AudioPlayerUrl(
                                    audUrl: audioQuestions[0].audUrl,
                                  ),
                                ),
                                Spacer(),
                                Flexible(
                                  flex: 2,
                                  fit: FlexFit.tight,
                                  child: Center(
                                    child: TextFormField(
                                      key: _formKey,
                                      textAlign: TextAlign.center,
                                      textInputAction: TextInputAction.none,
                                      autocorrect: false,
                                      enableSuggestions: false,
                                      autofocus: true,
                                      maxLines: 5,
                                      //focusNode: _answerFocusNode,
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      controller: _textController,
                                      decoration: InputDecoration(
                                        labelText: "Audio Answer",
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
                                      // onFieldSubmitted: (value) {
                                      //   SystemChannels.textInput
                                      //       .invokeMethod('TextInput.hide');
                                      //   FocusScope.of(context)
                                      //       .requestFocus(_answerFocusNode);
                                      // },
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 3,
                                  fit: FlexFit.tight,
                                  child: Center(
                                    child: _isBusy
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
                                              // if (!mounted) return;
                                              setState(() {
                                                _isBusy = true;
                                              });
                                              _submitAnswer();
                                            },
                                          ),
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: Center(
                                    child: Text(
                                      _loaded
                                          ? 'Question Track'
                                          : 'Selecting Question',
                                      style: GoogleFonts.solway(
                                        textStyle: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                // Spacer(),
                                Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: Card(
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: _loaded
                                        ? AudioPlayerUrl(
                                            audUrl: audioQuestions[0].audUrl,
                                          )
                                        : SpinKitThreeBounce(
                                            color: Color(0xFF56c590),
                                          ),
                                  ),
                                ),
                                Flexible(
                                  flex: 3,
                                  fit: FlexFit.tight,
                                  child: Center(
                                    child: ElevatedButton(
                                      // elevation: 5,
                                      // shape: RoundedRectangleBorder(
                                      //   borderRadius:
                                      //       BorderRadius.circular(10.0),
                                      // ),
                                      // color: Color(0xFF205072),
                                      onPressed: () {
                                        check = loadedAnswer[0].audTextAnswer;
                                        print(loadedAnswer[0]
                                            .audTextAnswer
                                            .toString());
                                        if (!mounted) return;
                                        setState(() {
                                          _isstart = true;
                                          resetTimer();
                                        });
                                      },
                                      child: Text(
                                        'Start Audio Test',
                                        style: GoogleFonts.solway(
                                          textStyle: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  resetTimer() {
    selectedOption = "0";
    animationController?.dispose();
    animationController = AnimationController(
        vsync: this, duration: Duration(seconds: 180)); // timer count setting
    animationController!.reverse(
        from: animationController!.value == 0.0
            ? 1.0
            : animationController!.value);
    animationController!.addStatusListener((AnimationStatus status) {
      print(status);
      if (status == AnimationStatus.dismissed) _submitAnswer();
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
                      color: Color(0xFF56c590)),
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
