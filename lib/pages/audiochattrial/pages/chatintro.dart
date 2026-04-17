import 'package:englishcoach/config/color.dart';
import 'package:englishcoach/config/responsive.dart';
import 'package:englishcoach/pages/audiochattrial/pages/chatroom.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatIntroPage extends StatefulWidget {
  static const routeName = 'chat-intro';
  const ChatIntroPage({Key? key}) : super(key: key);

  @override
  _ChatIntroPageState createState() => _ChatIntroPageState();
}

class _ChatIntroPageState extends State<ChatIntroPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
            'Audio Chat Room',
            style: GoogleFonts.solway(
                textStyle: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(
                  'assets/images/messages.png',
                  height: Responsive.isDesktop(context) ||
                          Responsive.isTablet(context)
                      ? size.height * 0.8
                      : null,
                ),
                ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pushNamed(ChatRoomPage.routeName,
                          arguments: {"name": name, "userid": userId});
                    },
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: primaryColor),
                    icon: const Icon(Icons.mic_none),
                    label: const Text('Enter Chat Room'))
              ],
            ),
          ),
        ));
  }
}
