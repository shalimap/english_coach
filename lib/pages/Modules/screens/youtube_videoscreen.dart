import 'package:englishcoach/pages/Modules/screens/firebase_video.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class YoutubeVideoScreen extends StatefulWidget {
  static const routeName = '/youtubemodulevideo';
  YoutubeVideoScreen({Key? key}) : super(key: key);

  @override
  _YoutubeVideoScreenState createState() => _YoutubeVideoScreenState();
}

class _YoutubeVideoScreenState extends State<YoutubeVideoScreen> {
  //YoutubePlayerController? _controller;
  var rotationturn = 0;
  Axis axis = Axis.vertical;
  // String firebaseVideoUrl =
  //     'https://firebasestorage.googleapis.com/v0/b/englishcoach-2020.appspot.com/o/module-videos%2Ftrial%2Fnoun_pronoun.mp4?alt=media&token=2b7cba83-3ac2-4600-834c-1a1c32acc20c';
  // // @override
  // void didChangeDependencies() {
  //   final moduleData = ModalRoute.of(context)!.settings.arguments as Map;
  //   // final moduleId = moduleData['modId'];
  //   // final videourl = moduleData['video'];

  //   // final moduleName = moduleData['modName'];
  //   //  runYoutubePlayer();
  //   super.didChangeDependencies();
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

  // void runYoutubePlayer() {
  //   final moduleData = ModalRoute.of(context)!.settings.arguments as Map;

  //   final videourl = moduleData['video'];
  //   print(videourl);
  //   // _controller = YoutubePlayerController(
  //   //     initialVideoId: YoutubePlayer.convertUrlToId(videourl)!,
  //   //     flags: YoutubePlayerFlags(
  //   //       autoPlay: true,
  //   //       isLive: false,
  //   //       enableCaption: false,
  //   //     ));
  // }

  // @override
  // void initState() {
  //   runYoutubePlayer();
  //   super.initState();
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

  @override
  Widget build(BuildContext context) {
    final moduleData = ModalRoute.of(context)!.settings.arguments as Map;
    final moduleName = moduleData['modName'];
    final videoUrl = moduleData['video'];
    //print('URL - $videoUrl');
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.chevron_left,
              size: 40,
            ),
            onPressed: () => Navigator.of(context).pop()),
        elevation: 0.0,
        title: Text(
          moduleName,
          style: GoogleFonts.solway(
              textStyle: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
        ),
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
                videoUrl: videoUrl,
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
