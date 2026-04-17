import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioPlayerUrl extends StatefulWidget {
  final String? audUrl;
  AudioPlayerUrl({this.audUrl});
  @override
  _AudioPlayerUrlState createState() => _AudioPlayerUrlState();
}

class _AudioPlayerUrlState extends State<AudioPlayerUrl> {
  AudioPlayer audioPlayer = AudioPlayer();
  PlayerState audioPlayerState = PlayerState.paused;
  int timeProgress = 0;
  int audioDuration = 0;

  Widget slider() {
    return Container(
      width: 300.0,
      child: Slider.adaptive(
          activeColor: Color(0xFF205072),
          value: timeProgress.toDouble(),
          max: audioDuration.toDouble(),
          onChanged: (value) {
            seekToSec(value.toInt());
          }),
    );
  }

  @override
  void initState() {
    super.initState();

    audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (!mounted) return;
      setState(() {
        audioPlayerState = state;
      });
    });

    audioPlayer.setSource(UrlSource(widget
        .audUrl!)); // Triggers the onDurationChanged listener and sets the max duration string
    audioPlayer.onDurationChanged.listen((Duration duration) {
      if (!mounted) return;
      setState(() {
        audioDuration = duration.inSeconds;
      });
    });
    audioPlayer.onDurationChanged.listen((Duration position) async {
      if (!mounted) return;
      setState(() {
        timeProgress = position.inSeconds;
      });
    });
  }

  @override
  void dispose() {
    audioPlayer.release();
    audioPlayer.dispose();
    super.dispose();
  }

  playMusic() async {
    // Add the parameter "isLocal: true" if you want to access a local file
    await audioPlayer.play(UrlSource(widget.audUrl!));
  }

  pauseMusic() async {
    await audioPlayer.pause();
  }

  void seekToSec(int sec) {
    Duration newPos = Duration(seconds: sec);
    audioPlayer
        .seek(newPos); // Jumps to the given position within the audio file
  }

  String getTimeString(int seconds) {
    String minuteString =
        '${(seconds / 60).floor() < 10 ? 0 : ''}${(seconds / 60).floor()}';
    String secondString = '${seconds % 60 < 10 ? 0 : ''}${seconds % 60}';
    return '$minuteString:$secondString'; // Returns a string with the format mm:ss
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            iconSize: 50,
            onPressed: () {
              audioPlayerState == PlayerState.playing
                  ? pauseMusic()
                  : playMusic();
            },
            icon: Icon(audioPlayerState == PlayerState.playing
                ? Icons.pause_rounded
                : Icons.play_arrow_rounded),
            color: Color(0xFF205072),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(getTimeString(timeProgress)),
              SizedBox(width: 20),
              Container(width: 200, child: slider()),
              SizedBox(width: 20),
              Text(getTimeString(audioDuration))
            ],
          )
        ],
      ),
    );
  }
}
