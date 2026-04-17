import 'package:englishcoach/pages/Modules/screens/firebase_video.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CarousalScreen extends StatefulWidget {
  static const routeName = '/carousal';
  @override
  _CarousalScreenState createState() => _CarousalScreenState();
}

class _CarousalScreenState extends State<CarousalScreen> {
  var rotationturn = 0;
  Axis axis = Axis.vertical;
  String firebaseVideoUrl =
      'https://firebasestorage.googleapis.com/v0/b/englishcoach-2020.appspot.com/o/module-videos%2Fintro%2FIntroduction%20%20English%20coach%20App_1080p.mp4?alt=media&token=6ae14b92-210d-4f94-97a9-89b958967675';
  // YoutubePlayerController? _controller;
  // @override
  // void didChangeDependencies() {
  //   runYoutubePlayer();
  //   super.didChangeDependencies();
  // }

  // void runYoutubePlayer() {
  //   final videourl = 'https://youtu.be/bxP1kXCKc2s';
  //   _controller = YoutubePlayerController(
  //       initialVideoId: YoutubePlayer.convertUrlToId(videourl)!,
  //       flags: YoutubePlayerFlags(
  //         autoPlay: true,
  //         isLive: false,
  //         enableCaption: false,
  //       ));
  // }

  // @override
  // void deactivate() {
  //   _controller!.pause();
  //   super.deactivate();
  // }

  // @override
  // void dispose() {
  //   _controller!.dispose();
  //   super.dispose();
  // }

  getAxis(value) {
    setState(() {
      axis = value;
    });
  }

  getQuarterTurn(value) {
    setState(() {
      rotationturn = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "English Coach",
          style: GoogleFonts.solway(
              textStyle: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            size: 40,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0.0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: axis,
        child: RotatedBox(
          quarterTurns: rotationturn,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //player,
              FirebaseVideoWidget(
                videoUrl: firebaseVideoUrl,
                getAxis: getAxis,
                getRotation: getQuarterTurn,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
