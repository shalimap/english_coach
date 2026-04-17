import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class CloudRecordListView extends StatefulWidget {
  final List<Reference> references;
  final String username;
  final String firebaseUrl;
  const CloudRecordListView({
    Key? key,
    required this.references,
    required this.username,
    required this.firebaseUrl,
  }) : super(key: key);

  @override
  _CloudRecordListViewState createState() => _CloudRecordListViewState();
}

class _CloudRecordListViewState extends State<CloudRecordListView> {
  bool? isPlaying;
  late AudioPlayer audioPlayer;
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    isPlaying = false;
    audioPlayer = AudioPlayer();
    selectedIndex = -1;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      // itemCount: widget.firebaseUrl.length,
      itemCount: 1,
      reverse: true,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          elevation: 3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * .5,
            right: 15,
            top: 15,
            bottom: 15,
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.redAccent[700],
                    borderRadius: BorderRadius.circular(100),
                  ),
                  height: 40,
                  width: 40,
                  child: Center(
                      child: Text(
                    widget.username[0],
                    style: const TextStyle(color: Colors.white),
                  )),
                ),
                InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    height: 30,
                    width: 30,
                    child: Center(
                      child: Icon(
                        selectedIndex != index
                            ? Icons.play_arrow_rounded
                            : Icons.pause_circle,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  onTap: () => _onListTileButtonPressed(index),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _onListTileButtonPressed(int index) async {
    setState(() {
      selectedIndex = index;
    });
    if (widget.firebaseUrl.isEmpty) {
      audioPlayer.play(UrlSource(
        await widget.references.elementAt(index).getDownloadURL(),
      ));
    } else {
      audioPlayer.play(UrlSource(
        widget.firebaseUrl,
      ));
    }
    // audioPlayer.play(await widget.references.elementAt(index).getDownloadURL(),
    //     isLocal: false);
    //audioPlayer.play(widget.firebaseUrl, isLocal: false);
    audioPlayer.onPlayerComplete.listen((duration) {
      setState(() {
        selectedIndex = -1;
      });
    });
  }
}
