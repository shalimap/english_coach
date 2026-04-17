import 'package:englishcoach/config/color.dart';
import 'package:englishcoach/pages/audiochattrial/pages/chatroomtrial.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatRoomIntroPage extends StatefulWidget {
  static const routeName = 'chatroom-intro';
  const ChatRoomIntroPage({Key? key}) : super(key: key);

  @override
  _ChatRoomIntroPageState createState() => _ChatRoomIntroPageState();
}

class _ChatRoomIntroPageState extends State<ChatRoomIntroPage> {
  @override
  Widget build(BuildContext context) {
    final username = ModalRoute.of(context)!.settings.arguments;
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
            'Audio Chat Room',
            style: GoogleFonts.solway(
                textStyle: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset('assets/images/messages.png'),
            ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pushNamed(ChatRoomTrialPage.routeName,
                      arguments: username);
                },
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: primaryColor),
                icon: const Icon(Icons.mic_none),
                label: const Text('Enter Chat Room'))
          ],
        ));
  }
}
