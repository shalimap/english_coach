import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:englishcoach/config/color.dart';
import 'package:englishcoach/pages/audiochattrial/pages/chatroom.dart';
import 'package:englishcoach/pages/audiochattrial/provider/audiochatrooms.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder2/flutter_audio_recorder2.dart';
import 'package:oktoast/oktoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class FeatureButtonsView extends StatefulWidget {
  final Function onUploadComplete;
  final String currentChatRoomId;
  final String currentAudioStatus;
  final String firebaseUrl;
  final String name;
  final String userId;
  const FeatureButtonsView({
    Key? key,
    required this.onUploadComplete,
    required this.currentChatRoomId,
    required this.currentAudioStatus,
    required this.firebaseUrl,
    required this.name,
    required this.userId,
  }) : super(key: key);
  @override
  _FeatureButtonsViewState createState() => _FeatureButtonsViewState();
}

class _FeatureButtonsViewState extends State<FeatureButtonsView> {
  late bool _isPlaying;
  late bool _isUploading;
  late bool _isRecorded;
  late bool _isRecording;
  bool _fileUploaded = false;

  late AudioPlayer _audioPlayer;
  late String _filePath;

  late FlutterAudioRecorder2 _audioRecorder;

  @override
  void initState() {
    super.initState();
    _isPlaying = false;
    _isUploading = false;
    _isRecorded = false;
    _isRecording = false;
    _audioPlayer = AudioPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _isRecorded
          ? _isUploading
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                            width: 200, child: LinearProgressIndicator())),
                    // Text('Uploading to Firebase'),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.redAccent[700],
                      ),
                      height: 60,
                      width: 60,
                      child: IconButton(
                        icon: Icon(
                          Icons.replay,
                          size: 30,
                          color: Colors.white,
                        ),
                        onPressed: _onRecordAgainButtonPressed,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.redAccent[700],
                      ),
                      height: 60,
                      width: 60,
                      child: IconButton(
                        icon: Icon(
                          _isPlaying ? Icons.pause : Icons.play_arrow,
                          size: 30,
                          color: Colors.white,
                        ),
                        onPressed: _onPlayButtonPressed,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Visibility(
                      visible: _fileUploaded ? false : true,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: primaryColor,
                        ),
                        height: 60,
                        width: 60,
                        child: IconButton(
                          icon: Icon(
                            Icons.upload_file,
                            size: 30,
                            color: Colors.white,
                          ),
                          onPressed: () => _onFileUploadButtonPressed(
                              widget.name, widget.userId),
                        ),
                      ),
                    ),
                  ],
                )
          : Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.redAccent[700],
                  ),
                  height: 60,
                  width: 60,
                  child: IconButton(
                    icon: _isRecording
                        ? Icon(
                            Icons.pause,
                            size: 30,
                            color: Colors.white,
                          )
                        : Icon(
                            Icons.mic_none_outlined,
                            size: 30,
                            color: Colors.white,
                          ),
                    onPressed: widget.currentAudioStatus == '0'
                        ? _onRecordButtonPressed
                        : () => showToast('Audio Already Uploaded'),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.redAccent[700],
                  ),
                  height: 60,
                  width: 60,
                  child: IconButton(
                    icon: Icon(
                      Icons.exit_to_app,
                      size: 30,
                      color: Colors.white,
                    ),
                    onPressed: _onExitButtonPressed,
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> _onFileUploadButtonPressed(String name, String userId) async {
    showToast('Uploading Recording');
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    setState(() {
      _isUploading = true;
    });
    try {
      await firebaseStorage
          .ref('voice-chat-firebase')
          .child(
              _filePath.substring(_filePath.lastIndexOf('/'), _filePath.length))
          .putFile(File(_filePath));
      widget.onUploadComplete();
      String url = await firebaseStorage
          .ref('voice-chat-firebase')
          .child(
              _filePath.substring(_filePath.lastIndexOf('/'), _filePath.length))
          .getDownloadURL();
      Provider.of<AudioChatRooms>(context, listen: false)
          .updateAudioUrl(widget.currentChatRoomId, url);
      Provider.of<AudioChatRooms>(context, listen: false)
          .updateAudioStatus(widget.currentChatRoomId);
      Future.delayed(Duration(seconds: 1)).then((_) {
        Navigator.of(context).popAndPushNamed(ChatRoomPage.routeName,
            arguments: {"name": name, "userid": userId});
      });
    } catch (error) {
      print('Error occured while uploading to Firebase ${error.toString()}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error occured while uploading'),
        ),
      );
    } finally {
      setState(() {
        _isUploading = false;
        _fileUploaded = true;
      });
    }
  }

  void _onRecordAgainButtonPressed() {
    setState(() {
      _isRecorded = false;
    });
  }

  Future<void> _onRecordButtonPressed() async {
    if (_isRecording) {
      showToast('Recording Ended');
      _audioRecorder.stop();
      _isRecording = false;
      _isRecorded = true;
    } else {
      showToast('Recording Starting');
      _isRecorded = false;
      _isRecording = true;
      await _startRecording();
    }
    setState(() {});
  }

  Future<void> _onExitButtonPressed() async {
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    if (widget.firebaseUrl != '') {
      await firebaseStorage.refFromURL(widget.firebaseUrl).delete();
    }
    Provider.of<AudioChatRooms>(context, listen: false)
        .updateChatExit(widget.currentChatRoomId)
        .then((_) {
      showToast('Exiting Chatroom');
      Future.delayed(Duration(seconds: 2)).then((_) {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      });
    });
  }

  void _onPlayButtonPressed() {
    if (!_isPlaying) {
      _isPlaying = true;

      _audioPlayer.play(UrlSource(
        _filePath,
      ));
      _audioPlayer.onPlayerComplete.listen((duration) {
        setState(() {
          _isPlaying = false;
        });
      });
    } else {
      _audioPlayer.pause();
      _isPlaying = false;
    }
    setState(() {});
  }

  Future<void> _startRecording() async {
    final bool? hasRecordingPermission =
        await FlutterAudioRecorder2.hasPermissions;

    if (hasRecordingPermission ?? false) {
      Directory directory = await getApplicationDocumentsDirectory();
      String filepath = directory.path +
          '/' +
          DateTime.now().millisecondsSinceEpoch.toString() +
          '.aac';
      _audioRecorder =
          FlutterAudioRecorder2(filepath, audioFormat: AudioFormat.AAC);
      await _audioRecorder.initialized;
      _audioRecorder.start();
      _filePath = filepath;
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Center(child: Text('Please enable recording permission'))));
    }
  }
}
