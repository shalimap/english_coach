import 'package:englishcoach/config/color.dart';
import 'package:englishcoach/pages/Modules/screens/firebase_video.dart';
import 'package:englishcoach/pages/payment/screens/PaymentPage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';

class OverviewVideoScreen extends StatefulWidget {
  static const routeName = '/overview-video';
  @override
  _OverviewVideoScreenState createState() => _OverviewVideoScreenState();
}

class _OverviewVideoScreenState extends State<OverviewVideoScreen> {
  var rotationturn = 0;
  Axis axis = Axis.vertical;
  String firebaseVideoUrl =
      'https://firebasestorage.googleapis.com/v0/b/englishcoach-2020.appspot.com/o/module-videos%2Fintro%2FCourse%20Overview%20%20English%20Coach_1080p.mp4?alt=media&token=caeabba8-a997-46c7-8882-24a06a517739';

//  YoutubePlayerController? _controller;
  //Key key = Key('Image');
  // @override
  // void didChangeDependencies() {
  //   runYoutubePlayer();
  //   super.didChangeDependencies();
  // }

  // void runYoutubePlayer() {
  //   final videourl = 'https://youtu.be/TZKrXjEHI94';
  //   _controller = YoutubePlayerController(
  //       initialVideoId: YoutubePlayer.convertUrlToId(videourl)!,
  //       flags: YoutubePlayerFlags(
  //         autoPlay: true,
  //         isLive: false,
  //         enableCaption: false,
  //       ));
  // }

  // @override
  // void deactivate() {
  //   _controller!.pause();
  //   super.deactivate();
  // }

  // @override
  // void dispose() {
  //   _controller!.dispose();
  //   super.dispose();
  // }

  getAxis(value) {
    setState(() {
      axis = value;
    });
  }

  getQuarterTurn(value) {
    setState(() {
      rotationturn = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userid = ModalRoute.of(context)!.settings.arguments;
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
          'Course Details',
          style: GoogleFonts.solway(
              textStyle: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: axis,
        child: RotatedBox(
          quarterTurns: rotationturn,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //player,
              FirebaseVideoWidget(
                videoUrl: firebaseVideoUrl,
                getAxis: getAxis,
                getRotation: getQuarterTurn,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: accentcolor,
        onPressed: () => Dialogs.materialDialog(
          color: Colors.white,
          msg:
              'എല്ലാ ടെസ്റ്റുകളും പൂർത്തിയാക്കിയതിന് അഭിനന്ദനങ്ങൾ. 499 രൂപ ഫീസ് അടച്ച് താങ്കൾക്ക് ഈ ഇംഗ്ലീഷ് പഠനം ആരംഭിക്കാം',
          title: 'Course Fee',
          context: context,
          actions: [
            kIsWeb
                ? Container()
                : IconsButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushReplacementNamed(
                          PaymentPage.routename,
                          arguments: userid);
                    },
                    text: 'Payment',
                    iconData: Icons.payment_rounded,
                    color: primaryColor,
                    textStyle: TextStyle(color: Colors.white),
                    iconColor: Colors.white,
                  ),
          ],
        ),
        label: Text(
          "Buy Complete Course",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Colors.white,
          ),
        ),
        elevation: 5,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
