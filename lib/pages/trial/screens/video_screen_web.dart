import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class VideoPageWeb extends StatefulWidget {
  static const routeName = '/video';

  @override
  _VideoPageWebState createState() => _VideoPageWebState();
}

class _VideoPageWebState extends State<VideoPageWeb> {
  YoutubePlayerController? _controller;
  @override
  void didChangeDependencies() {
    final moduleData = ModalRoute.of(context)!.settings.arguments as Map;

    runYoutubePlayer();
    super.didChangeDependencies();
  }

  void runYoutubePlayer() {
    final moduleData = ModalRoute.of(context)!.settings.arguments as Map;

    final videourl = moduleData['video'];
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayerController.convertUrlToId(videourl)!,
      params: YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
      ),
    );
  }

  @override
  void deactivate() {
    _controller!.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    // _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerIFrame(
      controller: _controller,
      aspectRatio: 16 / 9,
    );
  }
}
