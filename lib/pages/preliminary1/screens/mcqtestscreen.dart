import 'dart:math';

import 'package:flutter/material.dart';

class McqTestScreen extends StatefulWidget {
  static const routename = '/mcqtestscreen';
  @override
  _McqTestScreenState createState() => _McqTestScreenState();
}

class _McqTestScreenState extends State<McqTestScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  AppLifecycleState? _notification;
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _notification = state;
      if (_notification == AppLifecycleState.paused) {
        resetTimer();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    resetTimer();
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height -
              AppBar().preferredSize.height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.05),
                child: Container(
                  height: MediaQuery.of(context).size.height * 13 / 140,
                  child: Row(
                    children: [
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          "Question  of 10", //question count or length
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 17),
                        ),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: timeRemaining(),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              Container(
                height: MediaQuery.of(context).size.height * 28 / 140,
                width: double.infinity,
                padding: EdgeInsets.all(10),
                // decoration: BoxDecoration(
                //   border: Border.all(width: 2, color: Colors.black38),
                //   borderRadius: BorderRadius.all(
                //     Radius.circular(15),
                //   ),
                // ),
                child: Text(
                    'question 1question 1 question 1 question 1 question 1question 1',
                    textAlign: TextAlign.justify),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('data'),
                  SizedBox(height: 12),
                  Text('data'),
                  SizedBox(height: 12),
                  Text('data'),
                  SizedBox(height: 12),
                  Text('data'),
                ],
              )
            ],
          ),
        ),
      ),
    );
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

  resetTimer() {
    animationController?.dispose();
    animationController = AnimationController(
        vsync: this, duration: Duration(seconds: 30)); // timer count setting
    animationController!.reverse(
        from: animationController!.value == 0.0
            ? 1.0
            : animationController!.value);
    animationController!.addStatusListener((AnimationStatus status) {
      print(status);
      if (status == AnimationStatus.dismissed) print('ok');
    });
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
