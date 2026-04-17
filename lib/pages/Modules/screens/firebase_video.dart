import 'package:englishcoach/config/color.dart';
import 'package:englishcoach/config/responsive.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:video_player/video_player.dart';
import 'dart:math' as math;

class FirebaseVideoWidget extends StatefulWidget {
  final String videoUrl;
  Function getAxis;
  Function getRotation;
  FirebaseVideoWidget(
      {required this.videoUrl,
      required this.getAxis,
      required this.getRotation});
  @override
  _FirebaseVideoWidgetState createState() => _FirebaseVideoWidgetState();
}

class _FirebaseVideoWidgetState extends State<FirebaseVideoWidget> {
  late VideoPlayerController controller;
  late Future<void> futureController;
  bool rotation = false;
  @override
  void initState() {
    controller = VideoPlayerController.network(widget.videoUrl);
    futureController = controller.initialize();
    controller.play();
    controller.setLooping(true);
    controller.setVolume(50.0);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Responsive.isDesktop(context)
          ? const EdgeInsets.all(100.0)
          : const EdgeInsets.all(0.0),
      child: Column(
        children: <Widget>[
          Center(
            child: FutureBuilder(
              future: futureController,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return AspectRatio(
                      aspectRatio: controller.value.aspectRatio,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 5),
                        child: VideoPlayer(controller),
                      ));
                } else {
                  return Center(
                      child: SpinKitThreeBounce(
                    color: Color(0xFF56c590),
                  ));
                }
              },
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          //   child: ElevatedButton(
          //     child: Container(
          //         width: double.infinity,
          //         height: 50,
          //         child: Icon(controller.value.isPlaying
          //             ? Icons.pause
          //             : Icons.play_arrow)),
          //     onPressed: () {
          //       setState(() {
          //         if (controller.value.isPlaying) {
          //           controller.pause();
          //         } else {
          //           controller.play();
          //         }
          //       });
          //     },
          //   ),
          // )
          SizedBox(
            height: MediaQuery.of(context).size.height * .1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Center(
                  child: InkWell(
                onTap: () async {
                  Duration? currenPosition = await controller.position;
                  print('$currenPosition ${currenPosition.runtimeType}');
                  var nextPositionIncrement = Duration(seconds: 5);
                  var nextPosition = currenPosition! - nextPositionIncrement;
                  print('$nextPosition ${nextPosition.runtimeType}');
                  controller.seekTo(nextPosition);
                },
                child: Card(
                  color: primaryColor,
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(math.pi),
                      child: Icon(
                        Icons.double_arrow_rounded,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )),
              Center(
                  child: InkWell(
                onTap: kIsWeb
                    ? () {}
                    : () {
                        setState(() {
                          if (rotation) {
                            widget.getAxis(Axis.vertical);
                            widget.getRotation(0);
                            rotation = false;
                          } else {
                            widget.getAxis(Axis.horizontal);
                            widget.getRotation(1);
                            rotation = true;
                          }
                        });
                      },
                child: Card(
                  color: primaryColor,
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Icon(
                      Icons.aspect_ratio,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
              )),
              Center(
                  child: InkWell(
                onTap: () {
                  setState(() {
                    if (controller.value.isPlaying) {
                      controller.pause();
                    } else {
                      controller.play();
                    }
                  });
                },
                child: Card(
                  color: primaryColor,
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Icon(
                      controller.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
              )),
              Center(
                  child: InkWell(
                onTap: () async {
                  Duration? currenPosition = await controller.position;
                  print('$currenPosition ${currenPosition.runtimeType}');
                  var nextPositionIncrement = Duration(seconds: 5);
                  var nextPosition = currenPosition! + nextPositionIncrement;
                  print('$nextPosition ${nextPosition.runtimeType}');
                  controller.seekTo(nextPosition);
                },
                child: Card(
                  color: primaryColor,
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Icon(
                      Icons.double_arrow_rounded,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
              )),
            ],
          ),
        ],
      ),
    );
  }
}
