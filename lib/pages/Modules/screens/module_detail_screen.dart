import 'package:badges/badges.dart' as badges;
import 'package:englishcoach/config/color.dart';
import 'package:englishcoach/pages/Modules/providers/videos.dart';
import 'package:englishcoach/pages/Modules/screens/youtube_videoscreen.dart';
import 'package:englishcoach/pages/pictogram/Providers/pictogramcompleted.dart';
import 'package:englishcoach/pages/pictogram/Screens/Pictogramtestscreen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter/rendering.dart';

import '../../trial/screens/video_screen_web.dart';
import '../providers/modules.dart';
import '../providers/examples.dart';
import '../providers/structures.dart';
import '../providers/module_unlock.dart';
import '../screens/excercises_overview_screen.dart';
import '../screens/finaltest-reportscreen.dart';

class ModuleDetailScreen extends StatefulWidget {
  static const routeName = '/module-detail';

  @override
  _ModuleDetailScreenState createState() => _ModuleDetailScreenState();
}

class _ModuleDetailScreenState extends State<ModuleDetailScreen>
    with TickerProviderStateMixin<ModuleDetailScreen> {
  var _isInit = true;
  var topicTest = true;

  AnimationController? _hideFabAnimation;

  @override
  initState() {
    super.initState();
    _hideFabAnimation =
        AnimationController(vsync: this, duration: kThemeAnimationDuration);
  }

  @override
  void dispose() {
    _hideFabAnimation!.dispose();
    super.dispose();
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification.depth == 0) {
      if (notification is UserScrollNotification) {
        final UserScrollNotification userScroll = notification;
        switch (userScroll.direction) {
          case ScrollDirection.forward:
            if (userScroll.metrics.maxScrollExtent !=
                userScroll.metrics.minScrollExtent) {
              _hideFabAnimation!.reverse();
            }
            break;
          case ScrollDirection.reverse:
            if (userScroll.metrics.maxScrollExtent !=
                userScroll.metrics.minScrollExtent) {
              _hideFabAnimation!.forward();
            }
            break;
          case ScrollDirection.idle:
            break;
        }
      }
    }
    return false;
  }

  var videoUrl;
  // = "https://api.almacurious.com/test/waves.mp4";

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final moduleData = ModalRoute.of(context)!.settings.arguments as Map;
      final moduleId = moduleData['modNum'];
      final userId = moduleData['userId'];
      final topic = moduleData['topic'];
      Provider.of<Examples>(context).fetchExamples(moduleId);
      Provider.of<Structures>(context).fetchStructures(moduleId);
      Provider.of<ModuleVideos>(context, listen: false)
          .fetchVideos(moduleId)
          .then((_) {
        if (!topic) {
          var data = Provider.of<ModuleVideos>(context, listen: false)
              .findVideo(moduleId);
          // print(data.videoUrl);

          videoUrl = data.videoUrl;
        }
      });

      //Provider.of<ModuleUnlock>(context, listen: false).getunlocks(userId);

      getlengthdetails();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  getlengthdetails() async {
    final moduleData = ModalRoute.of(context)!.settings.arguments as Map;

    final userId = moduleData['userId'];
    final moduleId = moduleData['modNum'];

    var rsp = await Provider.of<PictogramCompleted>(context, listen: false)
        .getlength(moduleId, userId);
    // var rsplength = rsp == null ? 0 : rsp.length;

    if (!mounted) return;
    setState(() {
      rsp.length >= 5 ? pictlength = false : pictlength = true;
    });
  }

  var pictlength = true;

  var passed = 0;
  var tym = 0;

  var unlocked;
  var nextUnlockMod;

  TextStyle style = TextStyle(
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    final moduleData = ModalRoute.of(context)!.settings.arguments as Map;
    final moduleId = moduleData['modNum'];
    final userId = moduleData['userId'];
    final unlockCount = moduleData['unlockCount'];
    final moduleList = moduleData['moduleList'];
    final moduleLength = moduleData['moduleLength'];

    final loadedModule = Provider.of<Modules>(
      context,
      listen: false,
    ).findById(moduleId);
    final loadedExamples =
        Provider.of<Examples>(context).findExamples(moduleId);
    final loadedStructures =
        Provider.of<Structures>(context).findStructures(moduleId);

    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.chevron_left,
              size: 40,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          elevation: 0.0,
          title: Text(
            "English Coach",
            style: GoogleFonts.solway(
                textStyle: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
          ),
          centerTitle: true,
        ),
        body: StreamBuilder(
            stream: Stream.fromFuture(
                Provider.of<ModuleUnlock>(context, listen: false)
                    .fetchLocks(userId)),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final latestUnlockMod =
                    Provider.of<Modules>(context, listen: false)
                        .nextModId(unlockCount - 1, moduleList);

                if (unlockCount != moduleLength) {
                  final _nextUnlockMod =
                      Provider.of<Modules>(context, listen: false)
                          .nextModId(unlockCount, moduleList);
                  nextUnlockMod = _nextUnlockMod;
                  // print('lock===' + nextUnlockMod.toString());
                } else {
                  nextUnlockMod = null;

                  // print('lock+++' + nextUnlockMod.toString());
                }

                if (moduleId != latestUnlockMod) {
                  // var _isUnlocked = Provider.of<TrialModuleUnlock>(context, listen: false)
                  //     .checkUnlocked(latestUnlockMod);
                  var _isUnlocked = true;
                  unlocked = _isUnlocked;
                } else {
                  try {
                    final lockdetails =
                        Provider.of<ModuleUnlock>(context, listen: false)
                            .findbymlockopen(nextUnlockMod);
                    print(lockdetails.mLockOpenNow);
                    if (lockdetails.mLockOpenNow == 0 ||
                        lockdetails.mLockOpenNow == 1) {
                      unlocked = true;
                    }
                  } catch (e) {
                    unlocked = false;
                  }

                  // var _isUnlocked = Provider.of<ModuleUnlock>(context, listen: false)
                  //     .checkUnlocked(nextUnlockMod);
                }
                if (nextUnlockMod == null && moduleId == latestUnlockMod) {
                  var _isUnlocked = true;
                  unlocked = _isUnlocked;
                }

                return SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      loadedModule.modName!.trim() != "TOPIC TEST" ||
                              loadedModule.modName!.trim() != "FINAL TEST"
                          ? Container(
                              padding: const EdgeInsets.only(
                                top: 40,
                                left: 20,
                                right: 20,
                                bottom: 10,
                              ),
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    loadedModule.modName!,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 50,
                                  ),
                                  Text(
                                    loadedModule.modDescription!,
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                  loadedModule.modName!.trim() !=
                                              "TOPIC TEST" ||
                                          loadedModule.modName!.trim() !=
                                              "FINAL TEST"
                                      ? SizedBox(
                                          height: 50,
                                        )
                                      : Container(),
                                  loadedModule.modSpecialnote != ""
                                      ? Text(
                                          'ആപ്ത വാക്യം',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        )
                                      : Text(''),
                                  loadedModule.modName!.trim() !=
                                              "TOPIC TEST" ||
                                          loadedModule.modName!.trim() !=
                                              "FINAL TEST"
                                      ? SizedBox(
                                          height: 15,
                                        )
                                      : Container(),
                                  Text(
                                    loadedModule.modSpecialnote!,
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 50,
                                  ),
                                  loadedStructures.length != 0
                                      ? Center(
                                          child: Text(
                                            "Structures",
                                            style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        )
                                      : SizedBox(
                                          height: 0,
                                        ),
                                  SizedBox(
                                    height: 25,
                                  ),
                                  ListView.builder(
                                    primary: false,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: loadedStructures.length,
                                    itemBuilder: (context, index) {
                                      return Center(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 15, horizontal: 0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Icon(
                                                  Icons.bookmark,
                                                  color: Color(0xFF205072),
                                                ),
                                                flex: 1,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  '${loadedStructures[index].structStructure}',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                flex: 9,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  loadedModule.modName!.trim() !=
                                              "TOPIC TEST" ||
                                          loadedModule.modName!.trim() !=
                                              "FINAL TEST"
                                      ? SizedBox(
                                          height: 10,
                                        )
                                      : Container(),
                                  loadedExamples.length != 0
                                      ? Center(
                                          child: Text(
                                            "Examples",
                                            style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        )
                                      : SizedBox(
                                          height: 0,
                                        ),
                                  SizedBox(
                                    height: 25,
                                  ),
                                  ListView.builder(
                                    primary: false,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: loadedExamples.length,
                                    itemBuilder: (context, index) {
                                      return Center(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 15, horizontal: 0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Icon(
                                                  Icons.bookmark,
                                                  color: Color(0xFF205072),
                                                ),
                                                flex: 1,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  '${loadedExamples[index].exExample}',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                flex: 9,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(
                                    height: 50,
                                  ),
                                ],
                              ),
                            )
                          : Center(
                              child: Container(
                                child: Text(
                                  'Topic Test Rules',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                      loadedModule.modName!.trim() != "TOPIC TEST" ||
                              loadedModule.modName!.trim() != "FINAL TEST"
                          ? SizedBox(
                              height: 0,
                            )
                          : Container(),
                      loadedModule.modName!.trim() == "TOPIC TEST" ||
                              loadedModule.modName!.trim() == "FINAL TEST"
                          ? Text('')
                          : Padding(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  unlocked
                                      ? InkWell(
                                          // onTap: () {},
                                          onTap: () => kIsWeb
                                              ? Navigator.of(context).pushNamed(
                                                  VideoPageWeb.routeName,
                                                  arguments: {
                                                      'userId': userId,
                                                      'modId': moduleId,
                                                      'modName':
                                                          loadedModule.modName,
                                                      'video': videoUrl,
                                                    })
                                              : Navigator.of(context).pushNamed(
                                                  YoutubeVideoScreen.routeName,
                                                  arguments: {
                                                      'userId': userId,
                                                      'modId': moduleId,
                                                      'modName':
                                                          loadedModule.modName,
                                                      'video': videoUrl,
                                                    }),
                                          child: Column(
                                            children: [
                                              CircleAvatar(
                                                backgroundColor: accentcolor,
                                                radius: 40,
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      Colors.grey[100],
                                                  radius: 38,
                                                  child: Icon(
                                                    Icons.videocam,
                                                    color: accentcolor,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 12,
                                              ),
                                              Text(
                                                'Video',
                                                style: style,
                                              ),
                                            ],
                                          ),
                                        )
                                      : Builder(
                                          builder: (ctx) => InkWell(
                                            onTap: () {
                                              ScaffoldMessenger.of(ctx)
                                                  .hideCurrentSnackBar();
                                              ScaffoldMessenger.of(ctx)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                'Pass excercise to watch Video',
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.solway(
                                                    color: accentcolor,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )));
                                            },
                                            child: badges.Badge(
                                              position:
                                                  badges.BadgePosition.topEnd(
                                                      top: -5, end: 0),
                                              badgeContent: Icon(
                                                Icons.lock_outlined,
                                                size: 14,
                                                color: Colors.white70,
                                              ),
                                              badgeStyle: badges.BadgeStyle(
                                                badgeColor: Color(0xFF205072),
                                              ),
                                              child: Column(
                                                children: [
                                                  CircleAvatar(
                                                    backgroundColor:
                                                        Colors.grey[300],
                                                    radius: 40,
                                                    child: CircleAvatar(
                                                      backgroundColor:
                                                          Colors.grey[100],
                                                      radius: 38,
                                                      child: Icon(
                                                        Icons.videocam,
                                                        color: Colors.grey[300],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 12,
                                                  ),
                                                  Text(
                                                    'Video',
                                                    style: style,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                  SizedBox(
                                    width: 25,
                                  ),
                                  unlocked == true && pictlength == true
                                      ? InkWell(
                                          onTap: () {
                                            Navigator.of(context)
                                                .pushReplacementNamed(
                                                    PictogramTestScreen
                                                        .routename,
                                                    arguments: {
                                                  'userid': userId,
                                                  'modid': moduleId,
                                                  'key': 1,
                                                });
                                          },
                                          child: Column(
                                            children: [
                                              CircleAvatar(
                                                backgroundColor: accentcolor,
                                                radius: 40,
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      Colors.grey[100],
                                                  radius: 38,
                                                  child: Icon(
                                                    Icons.image,
                                                    color: accentcolor,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 12,
                                              ),
                                              Text(
                                                'Vocabulary',
                                                style: style,
                                              ),
                                            ],
                                          ),
                                        )
                                      : Builder(
                                          builder: (ctx) => InkWell(
                                            onTap: () {
                                              ScaffoldMessenger.of(ctx)
                                                  .hideCurrentSnackBar();
                                              pictlength == true
                                                  ? ScaffoldMessenger.of(ctx)
                                                      .showSnackBar(SnackBar(
                                                          content: Text(
                                                      'Pass excercise for Vocabulary',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: GoogleFonts.solway(
                                                          color: accentcolor,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )))
                                                  : ScaffoldMessenger.of(ctx)
                                                      .showSnackBar(SnackBar(
                                                          content: Text(
                                                      'You have completed this session',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: GoogleFonts.solway(
                                                          color: accentcolor,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )));
                                            },
                                            child: badges.Badge(
                                              position:
                                                  badges.BadgePosition.topEnd(
                                                      top: -5, end: 0),
                                              badgeContent: Icon(
                                                Icons.lock_outlined,
                                                size: 14,
                                                color: Colors.white70,
                                              ),
                                              badgeStyle: badges.BadgeStyle(
                                                badgeColor: Color(0xFF205072),
                                              ),
                                              child: Column(
                                                children: [
                                                  CircleAvatar(
                                                    backgroundColor:
                                                        Colors.grey[300],
                                                    radius: 40,
                                                    child: CircleAvatar(
                                                      backgroundColor:
                                                          Colors.grey[100],
                                                      radius: 38,
                                                      child: Icon(
                                                        Icons.image,
                                                        color: Colors.grey[300],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 12,
                                                  ),
                                                  Text(
                                                    'Vocabulary',
                                                    style: style,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                      SizedBox(
                        height: 100,
                      ),
                    ],
                  ),
                );
              }
              return Center(
                child: SpinKitCircle(
                  color: Color(0xFF205072),
                ),
              );
            }),
        floatingActionButton: ScaleTransition(
          scale: _hideFabAnimation!,
          child: FloatingActionButton.extended(
            backgroundColor: accentcolor,
            label: Text(
              "Excercise",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.white,
              ),
            ),
            elevation: 5,
            tooltip: "Tests",
            onPressed: loadedModule.modName!.trim() == "TOPIC TEST" ||
                    loadedModule.modName!.trim() == "FINAL TEST"
                ? loadedModule.modName!.trim() == "FINAL TEST"
                    ? () {
                        // showToast('Final Test', position: ToastPosition.bottom);
                        Navigator.of(context)
                            .pushNamed(TestReportScreen.routename, arguments: {
                          'mod': moduleId,
                          'topic': topicTest,
                          'userId': userId
                        });
                      }
                    : () {
                        //showToast('Topic Test', position: ToastPosition.bottom);
                        Navigator.of(context).pushNamed(
                            ExcercisesoverviewScreen.routeName,
                            arguments: {
                              'mod': moduleId,
                              'topic': topicTest,
                              'userId': userId
                            });
                      }
                : () {
                    // showToast('Module Test', position: ToastPosition.bottom);
                    topicTest = false;
                    Navigator.of(context).pushNamed(
                        ExcercisesoverviewScreen.routeName,
                        arguments: {
                          'mod': moduleId,
                          'topic': topicTest,
                          'userId': userId
                        });
                  },
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
