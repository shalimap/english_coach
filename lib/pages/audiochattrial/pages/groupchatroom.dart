import 'dart:math';
import 'package:englishcoach/config/color.dart';
import 'package:englishcoach/pages/audiochattrial/provider/audiochatrooms.dart';
import 'package:englishcoach/pages/audiochattrial/provider/audiochatusers.dart';
import 'package:englishcoach/pages/audiochattrial/widgets/cloudrecordlistview.dart';
import 'package:englishcoach/pages/audiochattrial/widgets/featurebuttons.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:englishcoach/pages/audiochattrial/model/audiocontent.dart';
import 'package:englishcoach/pages/audiochattrial/provider/audiocontents.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GroupChatRoomPage extends StatefulWidget {
  static const routeName = '/group-chatroom-page';
  const GroupChatRoomPage({Key? key}) : super(key: key);

  @override
  _GroupChatRoomPageState createState() => _GroupChatRoomPageState();
}

class _GroupChatRoomPageState extends State<GroupChatRoomPage> {
  List<Reference> references = [];
  List<AudioContent> _currentContent = [];
  AudioContent? selected;
  var _isInit = true;
  bool _chatroomExits = false;
  String currentChatRoomId = '';
  String currentAudioStatus = '0';
  String currentFirebaseUrl = '';
  bool trial = false;

  @override
  void initState() {
    super.initState();
    getData();
    _onUploadComplete();
  }

  void getData() {
    Provider.of<AudioChatUsers>(context, listen: false)
        .getAudioChatUsers()
        .then((_) {
      var chatRoomDetails =
          Provider.of<AudioChatUsers>(context, listen: false).audiochatuser;
      print(chatRoomDetails);
    });
  }

  // void getData() {
  //   Provider.of<AudioContents>(context, listen: false)
  //       .getAudioChatContents()
  //       .then((_) {
  //     var contents =
  //         Provider.of<AudioContents>(context, listen: false).audiocontent;
  //     final _random = Random();
  //     selected = contents[_random.nextInt(contents.length)];
  //     setState(() {});
  //   }).then((_) {
  //     final user = ModalRoute.of(context)!.settings.arguments as Map;
  //     final userId = user['userid'];
  //     Provider.of<AudioChatRooms>(context, listen: false)
  //         .searchForChatroom(userId)
  //         .then((chatroom) {
  //       if (chatroom.length > 0) {
  //         print('Chatroom Id - ${chatroom[0].chatRoomId}');
  //         currentChatRoomId = chatroom[0].chatRoomId;
  //         setState(() {
  //           currentAudioStatus = chatroom[0].audio;
  //           currentFirebaseUrl = chatroom[0].firebaseUrl;
  //           _chatroomExits = true;
  //           selected = Provider.of<AudioContents>(context, listen: false)
  //               .getAudioContentById(chatroom[0].chatContentId);
  //           print(selected!.subject);
  //         });
  //       } else {
  //         Provider.of<AudioChatRooms>(context, listen: false)
  //             .insertChatroom(selected!.audioContentId, userId)
  //             .then((chatroomid) {
  //           print('ID - $chatroomid');
  //           currentChatRoomId = chatroomid;
  //         });
  //       }
  //     });
  //   });
  // }

  @override
  void didChangeDependencies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    trial = prefs.getBool('trail') ?? false;
    if (_isInit) {
      getData();
    }
    setState(() {
      _isInit = false;
    });
    super.didChangeDependencies();
  }

  void _showDialog(context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Group Chat'),
                SizedBox(
                  width: 10,
                ),
                Icon(Icons.lock)
              ],
            )),
            content: const Text(
              'മറ്റുള്ളവരുമായി  ലൈവായി ഇംഗ്ലീഷിൽ സംസാരിക്കുന്നതിനുള്ള ഓഡിയോ ചാറ്റ് റൂമിൽ മെമ്പർ ആകുവാൻ താങ്കളുടെ രണ്ടാമത്തെ ടോപ്പിക്ക് ടെസ്റ്റ് പാസ്സാകുക',
              style: TextStyle(
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              // TextButton(
              //     onPressed: () {
              //       // _dismissDialog();
              //     },
              //     child: Text('Close')),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments as Map;
    final name = user['name'];
    final userId = user['userid'];
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.chevron_left,
            size: 40,
          ),
        ),
        centerTitle: true,
        title: Text(
          '$name\'s Group Chat Room',
          style: GoogleFonts.solway(
              textStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
        ),
      ),
      body: selected != null
          ? SingleChildScrollView(
              child: Container(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Text(
                                'Online',
                                style: TextStyle(
                                  fontSize: 10,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              height: 10,
                              width: 10,
                            )
                          ],
                        ),
                        Center(
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              child: Column(
                                children: [
                                  Text(
                                    '${selected?.subject}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    '${selected?.paragraph}',
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        references.isEmpty
                            ? SizedBox(
                                height: MediaQuery.of(context).size.height * .5,
                                child: Center(
                                  child: Text(
                                    'No audio uploaded yet !',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                            : CloudRecordListView(
                                references: references,
                                username: name,
                                firebaseUrl: currentFirebaseUrl,
                              )
                      ],
                    ),
                    trial
                        ? Positioned(
                            bottom: 15,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: CircleAvatar(
                                backgroundColor: primaryColor,
                                radius: 25,
                                child: IconButton(
                                  onPressed: () => _showDialog(context),
                                  icon: Row(
                                    children: [
                                      Icon(
                                        Icons.woman_rounded,
                                        color: Colors.white,
                                        size: 12,
                                      ),
                                      Text(
                                        '|',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Icon(
                                        Icons.man_rounded,
                                        color: Colors.white,
                                        size: 12,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container()
                  ],
                ),
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 10,
                  ),
                  Text('Searching Available Groups...'),
                ],
              ),
            ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        color: Colors.transparent,
        child: Container(
          height: MediaQuery.of(context).size.height * .15,
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              selected != null
                  ? FeatureButtonsView(
                      onUploadComplete: _onUploadComplete,
                      currentChatRoomId: currentChatRoomId,
                      currentAudioStatus: currentAudioStatus,
                      firebaseUrl: currentFirebaseUrl,
                      name: name,
                      userId: userId,
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onUploadComplete() async {
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    ListResult listResult =
        await firebaseStorage.ref().child('voice-chat-firebase').list();
    setState(() {
      references = listResult.items;
    });
  }
}
