import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPage extends StatefulWidget {
  static const routeName = '/video';

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  YoutubePlayerController? _controller;
  @override
  void didChangeDependencies() {
    final moduleData = ModalRoute.of(context)!.settings.arguments as Map;
    // final moduleId = moduleData['modId'];
    // final videourl = moduleData['video'];

    // final moduleName = moduleData['modName'];
    runYoutubePlayer();
    super.didChangeDependencies();
  }

  void runYoutubePlayer() {
    final moduleData = ModalRoute.of(context)!.settings.arguments as Map;

    final videourl = moduleData['video'];
    _controller = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(videourl)!,
        flags: YoutubePlayerFlags(
          autoPlay: true,
          isLive: false,
          enableCaption: false,
        ));
  }

  // @override
  // void initState() {
  //   runYoutubePlayer();
  //   super.initState();
  // }

  @override
  void deactivate() {
    _controller!.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }
  // Old videofiles
  //TargetPlatform _platform;
  // VideoPlayerController _videoPlayerController1;
  // VideoPlayerController _videoPlayerController2;
  // ChewieController _chewieController;

  // // void initState() {
  // //   super.initState();
  // //   final moduleData = ModalRoute.of(context).settings.arguments as Map;
  // //   final moduleId = moduleData['modId'];
  // //   final videourl = moduleData['video'];
  // //   // final userId = moduleData['userId'];
  // //   final moduleName = moduleData['modName'];

  // //   _videoPlayerController1 =
  // //       VideoPlayerController.network(videourl.toString());
  // //   _videoPlayerController2 = VideoPlayerController.network(
  // //       'https://www.sample-videos.com/video123/mp4/480/asdasdas.mp4');
  // //   _chewieController = ChewieController(
  // //     videoPlayerController: _videoPlayerController1,
  // //     aspectRatio: 3 / 2,
  // //     autoPlay: true,
  // //     looping: true,
  // //     // Try playing around with some of these other options:

  // //     // showControls: false,
  // //     // materialProgressColors: ChewieProgressColors(
  // //     //   playedColor: Colors.red,
  // //     //   handleColor: Colors.blue,
  // //     //   backgroundColor: Colors.grey,
  // //     //   bufferedColor: Colors.lightGreen,
  // //     // ),
  // //     // placeholder: Container(
  // //     //   color: Colors.grey,
  // //     // ),
  // //     // autoInitialize: true,
  // //   );
  // // }
  // @override
  // void didChangeDependencies() {
  //   final moduleData = ModalRoute.of(context).settings.arguments as Map;
  //   // final moduleId = moduleData['modId'];
  //   final videourl = moduleData['video'];
  //   // final userId = moduleData['userId'];
  //   // final moduleName = moduleData['modName'];

  //   _videoPlayerController1 =
  //       VideoPlayerController.network(videourl.toString());
  //   _videoPlayerController2 = VideoPlayerController.network(
  //       'https://www.sample-videos.com/video123/mp4/480/asdasdas.mp4');
  //   _chewieController = ChewieController(
  //     videoPlayerController: _videoPlayerController1,
  //     aspectRatio: 3 / 2,
  //     autoPlay: true,
  //     looping: true,
  //   );
  //   super.didChangeDependencies();
  // }

  // @override
  // void dispose() {
  //   _videoPlayerController1.dispose();
  //   _videoPlayerController2.dispose();
  //   _chewieController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final moduleData = ModalRoute.of(context)!.settings.arguments as Map;
    // final moduleId = moduleData['modId'];
    final videourl = moduleData['video'];
    // final userId = moduleData['userId'];
    final moduleName = moduleData['modName'];
    return kIsWeb
        ? Scaffold(
            body: InAppWebView(
              initialUrlRequest: URLRequest(url: Uri.parse(videourl)),
            ),
          )
        : YoutubePlayerBuilder(
            player: YoutubePlayer(controller: _controller!),
            builder: (context, player) {
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
                body: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: player,
                        /*
                    Chewie(
                      controller: _chewieController,
                    ),*/
                      ),
                    ),
                  ],
                ),
              );
            });
  }
}
