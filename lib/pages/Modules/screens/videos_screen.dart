import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

class ModuleVideoPage extends StatefulWidget {
  static const routeName = '/modulevideo';

  @override
  _ModuleVideoPageState createState() => _ModuleVideoPageState();
}

class _ModuleVideoPageState extends State<ModuleVideoPage> {
  TargetPlatform? _platform;
  VideoPlayerController? _videoPlayerController1;
  VideoPlayerController? _videoPlayerController2;
  ChewieController? _chewieController;

  // void initState() {
  //   super.initState();
  //   final moduleData = ModalRoute.of(context).settings.arguments as Map;
  //   final moduleId = moduleData['modId'];
  //   final videourl = moduleData['video'];
  //   // final userId = moduleData['userId'];
  //   final moduleName = moduleData['modName'];

  //   _videoPlayerController1 =
  //       VideoPlayerController.network(videourl.toString());
  //   _videoPlayerController2 = VideoPlayerController.network(
  //       'https://www.sample-videos.com/video123/mp4/480/asdasdas.mp4');
  //   _chewieController = ChewieController(
  //     videoPlayerController: _videoPlayerController1,
  //     aspectRatio: 3 / 2,
  //     autoPlay: true,
  //     looping: true,
  //     // Try playing around with some of these other options:

  //     // showControls: false,
  //     // materialProgressColors: ChewieProgressColors(
  //     //   playedColor: Colors.red,
  //     //   handleColor: Colors.blue,
  //     //   backgroundColor: Colors.grey,
  //     //   bufferedColor: Colors.lightGreen,
  //     // ),
  //     // placeholder: Container(
  //     //   color: Colors.grey,
  //     // ),
  //     // autoInitialize: true,
  //   );
  // }
  @override
  void didChangeDependencies() {
    final moduleData = ModalRoute.of(context)!.settings.arguments as Map;
    final moduleId = moduleData['modId'];
    final videourl = moduleData['video'];
    // final userId = moduleData['userId'];
    final moduleName = moduleData['modName'];

    _videoPlayerController1 =
        VideoPlayerController.network(videourl.toString());
    _videoPlayerController2 = VideoPlayerController.network(
        'https://www.sample-videos.com/video123/mp4/480/asdasdas.mp4');
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1!,
      aspectRatio: 3 / 2,
      autoPlay: true,
      looping: true,
      // Try playing around with some of these other options:

      // showControls: false,
      // materialProgressColors: ChewieProgressColors(
      //   playedColor: Colors.red,
      //   handleColor: Colors.blue,
      //   backgroundColor: Colors.grey,
      //   bufferedColor: Colors.lightGreen,
      // ),
      // placeholder: Container(
      //   color: Colors.grey,
      // ),
      autoInitialize: true,
    );
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _videoPlayerController1!.dispose();
    _videoPlayerController2!.dispose();
    _chewieController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final moduleData = ModalRoute.of(context)!.settings.arguments as Map;
    // final moduleId = moduleData['modId'];
    // final videourl = moduleData['video'];
    // final userId = moduleData['userId'];
    final moduleName = moduleData['modName'];
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
      body: Padding(
        padding: EdgeInsets.only(left: 10.0, right: 10.0),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Chewie(
                  controller: _chewieController!,
                ),
              ),
            ),
            // FlatButton(
            //   onPressed: () {
            //     _chewieController.enterFullScreen();
            //   },
            //   child: Text('Fullscreen'),
            // ),
            // Row(
            //   children: [
            //     Expanded(
            //       child: FlatButton(
            //         onPressed: () {
            //           setState(() {
            //             _chewieController.dispose();
            //             _videoPlayerController2.pause();
            //             _videoPlayerController2.seekTo(Duration(seconds: 0));
            //             _chewieController = ChewieController(
            //               videoPlayerController: _videoPlayerController1,
            //               aspectRatio: 3 / 2,
            //               autoPlay: true,
            //               looping: true,
            //             );
            //           });
            //         },
            //         child: Padding(
            //           child: Text("Video 1"),
            //           padding: EdgeInsets.symmetric(vertical: 16.0),
            //         ),
            //       ),
            //     ),
            //     Expanded(
            //       child: FlatButton(
            //         onPressed: () {
            //           setState(() {
            //             _chewieController.dispose();
            //             _videoPlayerController1.pause();
            //             _videoPlayerController1.seekTo(Duration(seconds: 0));
            //             _chewieController = ChewieController(
            //               videoPlayerController: _videoPlayerController2,
            //               aspectRatio: 3 / 2,
            //               autoPlay: true,
            //               looping: true,
            //             );
            //           });
            //         },
            //         child: Padding(
            //           padding: EdgeInsets.symmetric(vertical: 16.0),
            //           child: Text("Error Video"),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            // Row(
            //   children: [
            //     Expanded(
            //       child: FlatButton(
            //         onPressed: () {
            //           setState(() {
            //             _platform = TargetPlatform.android;
            //           });
            //         },
            //         child: Padding(
            //           child: Text("Android controls"),
            //           padding: EdgeInsets.symmetric(vertical: 16.0),
            //         ),
            //       ),
            //     ),
            //     Expanded(
            //       child: FlatButton(
            //         onPressed: () {
            //           setState(() {
            //             _platform = TargetPlatform.iOS;
            //           });
            //         },
            //         child: Padding(
            //           padding: EdgeInsets.symmetric(vertical: 16.0),
            //           child: Text("iOS controls"),
            //         ),
            //       ),
            //     ),
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}
