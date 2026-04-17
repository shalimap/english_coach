import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatRoomTrialPage extends StatefulWidget {
  static const routeName = '/chatroom-trial';
  const ChatRoomTrialPage({Key? key}) : super(key: key);

  @override
  _ChatRoomTrialPageState createState() => _ChatRoomTrialPageState();
}

class _ChatRoomTrialPageState extends State<ChatRoomTrialPage> {
  void _showDialog(context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Chat Room'),
                SizedBox(
                  width: 10,
                ),
                Icon(Icons.lock)
              ],
            )),
            content: const Text(
              'മറ്റുള്ളവരുമായി  ലൈവായി ഇംഗ്ലീഷിൽ സംസാരിക്കുന്നതിനുള്ള ഓഡിയോ ചാറ്റ് റൂമിൽ മെമ്പർ ആകുവാൻ താങ്കളുടെ ആദ്യത്തെ സെക്ഷൻ ടെസ്റ്റ് പാസ്സാകുക',
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
    final username = ModalRoute.of(context)!.settings.arguments as String;
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
          '$username\'s Chat Room',
          style: GoogleFonts.solway(
              textStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          // decoration: BoxDecoration(
          //   image: DecorationImage(
          //       image: const AssetImage('assets/chat_background.jpg'),
          //       fit: BoxFit.cover,
          //       colorFilter: ColorFilter.mode(
          //           Colors.black.withOpacity(0.3), BlendMode.darken)),
          // ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                      '5 Members Online',
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
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  child: const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                      'Topic - English Language',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ),
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                margin: EdgeInsets.only(
                  left: 15,
                  right: MediaQuery.of(context).size.width * .5,
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
                          color: Colors.pink,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        height: 40,
                        width: 40,
                        child: const Center(
                            child: Text(
                          'A',
                          style: TextStyle(color: Colors.white),
                        )),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        height: 30,
                        width: 30,
                        child: const Center(
                            child: Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                        )),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                margin: EdgeInsets.only(
                  left: 15,
                  right: MediaQuery.of(context).size.width * .5,
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
                          color: Colors.deepOrange,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        height: 40,
                        width: 40,
                        child: const Center(
                            child: Text(
                          'N',
                          style: TextStyle(color: Colors.white),
                        )),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        height: 30,
                        width: 30,
                        child: const Center(
                            child: Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                        )),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                margin: EdgeInsets.only(
                  left: 15,
                  right: MediaQuery.of(context).size.width * .5,
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
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        height: 40,
                        width: 40,
                        child: const Center(
                            child: Text(
                          'H',
                          style: TextStyle(color: Colors.white),
                        )),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        height: 30,
                        width: 30,
                        child: const Center(
                            child: Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                        )),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                margin: EdgeInsets.only(
                  left: 15,
                  right: MediaQuery.of(context).size.width * .5,
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
                          color: Colors.indigoAccent,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        height: 40,
                        width: 40,
                        child: const Center(
                            child: Text(
                          'V',
                          style: TextStyle(color: Colors.white),
                        )),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        height: 30,
                        width: 30,
                        child: const Center(
                            child: Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                        )),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
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
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        height: 40,
                        width: 40,
                        child: Center(
                            child: Text(
                          username[0],
                          style: const TextStyle(color: Colors.white),
                        )),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        height: 30,
                        width: 30,
                        child: const Center(
                            child: Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                        )),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
              InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.red,
                      ),
                      height: 60,
                      width: 60,
                      child: const Icon(
                        Icons.logout,
                        color: Colors.white,
                        size: 30,
                      ))),
              InkWell(
                  onTap: () => _showDialog(context),
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.deepOrange,
                      ),
                      height: 60,
                      width: 60,
                      child: const Icon(
                        Icons.mic_none_outlined,
                        color: Colors.white,
                        size: 30,
                      ))),
            ],
          ),
        ),
      ),
    );
  }
}
