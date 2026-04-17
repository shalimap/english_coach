import 'package:englishcoach/common_widgets/nointernetpopup.dart';
import 'package:englishcoach/config/color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../widgets/module_test_list.dart';
import '../screens/module_test_screen.dart';
import '../screens/topic_test_screen.dart';
import '../providers/module_tests.dart';
import '../providers/modules.dart';
import '../providers/topictest_tests.dart';
import 'package:lottie/lottie.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_offline/flutter_offline.dart';

class ExcercisesoverviewScreen extends StatefulWidget {
  static const routeName = '/excercises-overview-screen';

  @override
  _ExcercisesoverviewScreenState createState() =>
      _ExcercisesoverviewScreenState();
}

class _ExcercisesoverviewScreenState extends State<ExcercisesoverviewScreen> {
  var nullTests = false;
  var intro = false;

  //GlobalKey _exer = GlobalKey();

  var connected;
  bool checkConnectivity() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        setState(() {
          connected = true;
        });
      } else {
        setState(() {
          connected = false;
        });
      }
    });
    return connected ?? true;
  }

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments as Map;
    final moduleId = data['mod'];
    final topic = data['topic'];
    final userId = data['userId'];
    final currentModuleData =
        Provider.of<Modules>(context, listen: false).findTopicNum(moduleId);
    final tNum = currentModuleData.tNum;
    final moduleData = Provider.of<Modules>(context);
    final introMod = moduleData.chapters.first.modNum;
    if (moduleId == introMod) {
      intro = true;
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            size: 40,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0.0,
        title: topic
            ? Text(
                'Topic Test Reports',
                style: GoogleFonts.solway(fontWeight: FontWeight.bold),
              )
            : Text(
                'Module Test Reports',
                style: GoogleFonts.solway(fontWeight: FontWeight.bold),
              ),
        centerTitle: true,
      ),
      body: OfflineBuilder(
        connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget child,
        ) {
          final bool connected = connectivity != ConnectivityResult.none;
          return connected
              ? StreamBuilder(
                  stream: Stream.fromFuture(topic
                      ? Provider.of<TopicTests>(context, listen: false)
                          .fetchTests(moduleId, userId)
                      : Provider.of<ModuleTests>(context, listen: false)
                          .fetchTests(moduleId, userId)),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      ///List test = snapshot.data;
                      // if (test.length == 0) {
                      //   nullTests = true;
                      // }
                      return snapshot.data!.length == 0
                          ? Center(
                              child: intro
                                  ? Text(
                                      'No Test Available. Move on to next module !')
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Lottie.asset(
                                          'assets/images/781-no-notifications.json',
                                        ),
                                        Text(
                                          'Time to take a test !',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                            )
                          : topic
                              ? Consumer<TopicTests>(
                                  builder: (context, value, child) => Container(
                                    margin: EdgeInsets.only(bottom: 70),
                                    child: ModuleTestList(
                                        moduleId, topic, tNum!, userId),
                                  ),
                                )
                              : Consumer<ModuleTests>(
                                  builder: (context, value, child) => Container(
                                    margin: EdgeInsets.only(bottom: 70),
                                    child: ModuleTestList(
                                        moduleId, topic, tNum!, userId),
                                  ),
                                );
                    }
                    return Center(
                      child: SpinKitCircle(
                        color: Color(0xFF205072),
                      ),
                    );
                  })
              : NoInternet();
        },
        child: Text(''),
      ),
      floatingActionButton: intro
          ? null
          : checkConnectivity()
              ? FloatingActionButton.extended(
                  backgroundColor: accentcolor,
                  elevation: 5,
                  tooltip: "New Test",
                  onPressed: topic
                      ? () {
                          Navigator.of(context).pushNamed(TopicsTest.routeName,
                              arguments: {
                                'mod': moduleId,
                                'topic': topic,
                                'userId': userId
                              });
                        }
                      : () {
                          Navigator.of(context).pushNamed(
                              ModuleTestScreen.routeName,
                              arguments: {
                                'mod': moduleId,
                                'topic': topic,
                                'userId': userId
                              });
                        },

                  label: Text(
                    "Start Test",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  // child:   Icon(
                  //   Icons.add,
                  //   color: Colors.white,
                  // ),
                )
              : Text(''),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
