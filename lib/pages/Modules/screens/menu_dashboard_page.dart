import 'package:englishcoach/common_widgets/nointernetpopup.dart';
import 'package:englishcoach/config/color.dart';
import 'package:englishcoach/pages/audio/screen/sections_dashboard.dart';
import 'package:englishcoach/pages/audiochattrial/pages/chatintro.dart';
import 'package:englishcoach/pages/login/screen/login.dart';
import 'package:englishcoach/pages/profile/provider/profile_provider.dart';
import 'package:englishcoach/pages/profile/screen/edit_profile.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../audio/screen/audio_dashboard.dart';

import 'package:showcaseview/showcaseview.dart';

import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kommunicate_flutter/kommunicate_flutter.dart';
import 'dart:convert';

import '../widgets/modules_grid.dart';

import '../../dailypopup/provider/popuplists.dart';
import '../../dailypopup/provider/dailypopups.dart';

import '../../dailypopup/model/dailypopup.dart';
import '../../dailypopup/model/popuplist.dart';

import 'package:flutter_offline/flutter_offline.dart';

class MenuDashboardPage extends StatefulWidget {
  static const routeName = '/dashboard';

  @override
  _MenuDashboardPageState createState() => _MenuDashboardPageState();
}

class _MenuDashboardPageState extends State<MenuDashboardPage>
    with SingleTickerProviderStateMixin {
  bool isCollapsed = true;
  double? screenWidth, screenHeight;
  final Duration duration = const Duration(milliseconds: 300);
  AnimationController? _controller;
  Animation<double>? _scaleAnimation;
  Animation<double>? _menuScaleAnimation;
  Animation<Offset>? _slideAnimation;
  String? uniqueChatId;
  bool chatLoading = false;

  var _isInit = true;
  var _nullPops = false;
  var popup = DailyPopUp(
    popupId: null,
    userId: null,
    dateTime: null,
    count: null,
  );
  var firstPopupId;
  List<DailyPopUp>? currentPopupData;
  var currentPopupId;
  List<PopUpList>? showPopup;
  var difference;

  void _showPopup(BuildContext context, url) {
    showDialog(
      barrierColor: Colors.black.withOpacity(.8),
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              Flex(
                direction: Axis.horizontal,
                children: [
                  Expanded(
                    child: ClipRRect(
                      child: Image.network(url),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: -100,
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.close_rounded,
                    ),
                    color: Colors.grey,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  alignment: Alignment.center,
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: duration);
    _scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(_controller!);
    _menuScaleAnimation =
        Tween<double>(begin: 0.5, end: 1).animate(_controller!);
    _slideAnimation = Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
        .animate(_controller!);
  }

  @override
  void didChangeDependencies() {
    setState(() {
      _isloaded = true;
    });
    getprofile().then((_) {
      setState(() {
        _isloaded = false;
      });
    });
    getuserdetails();

    final userID = ModalRoute.of(context)!.settings.arguments;
    int userId = int.parse(userID.toString());
    if (_isInit) {
      _nullPops = false;
      Provider.of<PopUpLists>(context, listen: false).fetchPopupList().then(
        (_) {
          Provider.of<DailyPopUps>(context, listen: false)
              .fetchDailyPopUps(userId)
              .then(
            (popupData) {
              if (popupData.isEmpty) {
                _nullPops = true;
                var initialId = Provider.of<PopUpLists>(context, listen: false)
                    .initialPopupId();
                firstPopupId = initialId;
              }
              if (popupData.isNotEmpty) {
                currentPopupData = popupData;
                currentPopupId = popupData[0].popupId;
                print('current-id');
              }
            },
          ).then(
            (_) {
              if (_nullPops) {
                print('Null Pops');
                popup = DailyPopUp(
                  popupId: firstPopupId,
                  userId: userId,
                  dateTime: DateTime.now(),
                  count: 1,
                );
                Provider.of<DailyPopUps>(context, listen: false)
                    .addPopup(popup);
                showPopup = Provider.of<PopUpLists>(context, listen: false)
                    .findPopupById(firstPopupId);
                _showPopup(context, showPopup![0].popupUrl);
                print('Show-first-popup');
              } else {
                print('Pops Exists');
                print('current-id-call');
                showPopup = Provider.of<PopUpLists>(context, listen: false)
                    .randomPopup(currentPopupId);
                var previousTime = currentPopupData![0].dateTime;
                var limit = previousTime!.add(Duration(hours: 24));
                var diff = DateTime.now().difference(limit);
                difference = diff;
                print('Popup Difference : ' + diff.toString());
                diff >= Duration(seconds: 1)
                    ? _showPopup(context, showPopup![0].popupUrl)
                    : print('No Popup');
                if (diff >= Duration(seconds: 1)) {
                  Provider.of<DailyPopUps>(context, listen: false)
                      .updatePopupData(
                    userId,
                    showPopup![0].popupId!,
                    currentPopupData![0].count! + 1,
                    DateTime.now(),
                  );
                  print('popup-updated');
                }
              }
            },
          );
        },
      );
    }

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  var stime;
  var imgvalue;
  var username;
  var userphone;
  var usermail;
  var _isloaded = false;

  Future getprofile() async {
    final userID = ModalRoute.of(context)!.settings.arguments;
    var rsp = await Provider.of<ProfileProvider>(context).getprofileimg(userID);
    imgvalue = int.parse(rsp[0]['selected_img']);
    stime = DateTime.parse(rsp[0]['study_time']);
    print('sssstime ' + stime.toString());
  }

  getuserdetails() async {
    final userID = ModalRoute.of(context)!.settings.arguments;
    var rsp = await Provider.of<ProfileProvider>(context).getusername(userID);
    username = rsp[0]['user_name'];
    userphone = rsp[0]['user_mob'];
    usermail = rsp[0]['user_email'];
  }

  SvgPicture? imgList;
  check() {
    Size size = MediaQuery.of(context).size;
    setState(() {
      if (imgvalue == 0) {
        imgList = SvgPicture.asset(
          "assets/avatars/YBoy-01.svg",
          width: size.width * 0.35,
        );
      } else if (imgvalue == 1) {
        imgList = SvgPicture.asset(
          "assets/avatars/YGirl-01.svg",
          width: size.width * 0.35,
        );
      } else if (imgvalue == 2) {
        imgList = SvgPicture.asset(
          "assets/avatars/YMan-01.svg",
          width: size.width * 0.35,
        );
      } else if (imgvalue == 3) {
        imgList = SvgPicture.asset(
          "assets/avatars/YWomen-01.svg",
          width: size.width * 0.35,
        );
      } else if (imgvalue == 4) {
        imgList = SvgPicture.asset(
          "assets/avatars/Men1.svg",
          width: size.width * 0.35,
        );
      } else {
        imgList = SvgPicture.asset(
          "assets/avatars/Women-01.svg",
          width: size.width * 0.35,
        );
      }
    });
  }

  void _showDialogs(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                Container(
                  height: 250,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Confirmation',
                        style: GoogleFonts.solway(
                          textStyle: TextStyle(fontWeight: FontWeight.bold),
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Are you sure you want to logout ?',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.solway(
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                              onPressed: () async {
                                KommunicateFlutterPlugin.isLoggedIn()
                                    .then((value) {
                                  if (value) {
                                    print("User is already logged in");
                                  } else {
                                    print("User is not logged in");
                                  }
                                });
                                final prefs =
                                    await SharedPreferences.getInstance();
                                prefs.clear();
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    LoginPage.routename, (route) => false);
                                KommunicateFlutterPlugin.logout();
                              },
                              child: Text(
                                'Ok',
                                style: GoogleFonts.solway(
                                  fontSize: 14,
                                  color: accentcolor,
                                ),
                              )),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Cancel',
                                style: GoogleFonts.solway(
                                    fontSize: 14, color: accentcolor),
                              )),
                        ],
                      )
                    ],
                  ),
                ),
                Positioned(
                    top: -60,
                    child: CircleAvatar(
                      backgroundColor: Color(0xFF205072),
                      radius: 50,
                      child: Image.asset('assets/icons/Icon.png'),
                    ))
              ],
            ),
          );
        });
  }

  GlobalKey _one = GlobalKey();
  GlobalKey _two = GlobalKey();

  _registerFirebase() async {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    // final KommunicateFlutterPlugin Kommunicate = KommunicateFlutterPlugin.updateUserDetail(kmUser)
    await _firebaseMessaging.requestPermission();
    //_firebaseMessaging.subscribeToTopic('tables$siteId');
    var token = await _firebaseMessaging.getToken();
    print("Token:$token");
  }

  @override
  Widget build(BuildContext context) {
    SharedPreferences preferences;
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;

    showShowcase() async {
      preferences = await SharedPreferences.getInstance();
      bool? showcasevisible = preferences.getBool('showcase');

      if (showcasevisible == null) {
        preferences.setBool('showcase', false);
        return true;
      }
      return false;
    }

    showShowcase().then((status) {
      if (status) {
        ShowCaseWidget.of(context).startShowCase([_one, _two]);
      }
    });

    return Scaffold(
      backgroundColor: Color(0xFF205072),
      body: OfflineBuilder(
        connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget child,
        ) {
          final bool connected = connectivity != ConnectivityResult.none;
          return connected
              ? Stack(
                  children: <Widget>[
                    menu(context),
                    dashboard(context),
                  ],
                )
              : NoInternet();
        },
        child: Text(''),
      ),
    );
  }

  Widget menu(context) {
    final userID = ModalRoute.of(context)!.settings.arguments;
    uniqueChatId = (username.toString().trim() + userID.toString())
        .replaceAll(new RegExp(r"\s+"), "");
    print(uniqueChatId);
    return SlideTransition(
      position: _slideAnimation!,
      child: ScaleTransition(
        scale: _menuScaleAnimation!,
        child: Padding(
          padding: const EdgeInsets.only(left: 26.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 50,
                    child: _isloaded
                        ? Center(
                            child: SpinKitCircle(
                              color: primaryColor,
                            ),
                          )
                        : imgList,
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text("Hello, ${username ?? 'User'}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                SizedBox(height: 50),
                Row(
                  children: [
                    InkWell(
                      child: Text("Profile",
                          style: TextStyle(color: Colors.grey, fontSize: 15)),
                      onTap: () => showToast('Unlocked after Topic Test 3'),
                    ),
                    SizedBox(width: 10),
                    Icon(
                      Icons.lock,
                      color: Colors.grey,
                      size: 15,
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    InkWell(
                      child: Text("Voice Chat",
                          style: TextStyle(color: Colors.white, fontSize: 15)),
                      onTap: () {
                        Navigator.of(context).pushNamed(ChatIntroPage.routeName,
                            arguments: {"name": username, "userid": userID});
                      },
                    ),
                    SizedBox(width: 10),
                    Icon(
                      Icons.mic,
                      color: Colors.white,
                      size: 15,
                    )
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    InkWell(
                      child: Text("Vocabulary",
                          style: TextStyle(color: Colors.grey, fontSize: 15)),
                      onTap: () => showToast('Unlocked after Topic Test 3'),
                    ),
                    SizedBox(width: 10),
                    Icon(
                      Icons.lock,
                      color: Colors.grey,
                      size: 15,
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    InkWell(
                      child: Text("Videos",
                          style: TextStyle(color: Colors.grey, fontSize: 15)),
                      onTap: () => showToast('Unlocked after Topic Test 3'),
                    ),
                    SizedBox(width: 10),
                    Icon(
                      Icons.lock,
                      color: Colors.grey,
                      size: 15,
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    InkWell(
                      child: Text(
                        chatLoading ? "Connecting" : "My Tutor",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      onTap: () async {
                        setState(() {
                          chatLoading = true;
                        });
                        try {
                          KommunicateFlutterPlugin.isLoggedIn().then((value) {
                            if (value) {
                              print("User is already logged in");
                            } else {
                              print("User is not logged in");
                            }
                          });
                          dynamic user = {
                            'userId': uniqueChatId,
                            //Replace it with the userId of the logged in user
                            'password':
                                'accessdenied' //Put password here if user has password, ignore otherwise
                          };
                          dynamic conversationObject = {
                            'appId':
                                '3b7371e6fb6f2d0c25122d70ca5c6fb81', // The [APP_ID](https://dashboard.kommunicate.io/settings/install) obtained from kommunicate dashboard.
                            'kmUser': jsonEncode(user)
                          };
                          dynamic result =
                              await KommunicateFlutterPlugin.buildConversation(
                                  conversationObject);
                          print("Conversation builder success : " +
                              result.toString());
                          setState(() {
                            chatLoading = false;
                          });
                          KommunicateFlutterPlugin.login(user).then((result) {
                            print("Login successful : " + result.toString());
                          }).catchError((error) {
                            print("Login failed : " + error.toString());
                          });
                        } on Exception catch (e) {
                          print("Conversation builder error occurred : " +
                              e.toString());
                          setState(() {
                            chatLoading = false;
                          });
                        }
                      },
                    ),
                    SizedBox(width: 10),
                    Icon(
                      chatLoading ? Icons.support_agent_rounded : Icons.chat,
                      color: Colors.white,
                      size: chatLoading ? 20 : 15,
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    InkWell(
                      child: Text("Messages",
                          style: TextStyle(color: Colors.grey, fontSize: 15)),
                      onTap: () => showToast('Unlocked after Topic Test 3'),
                    ),
                    SizedBox(width: 10),
                    Icon(
                      Icons.lock,
                      color: Colors.grey,
                      size: 15,
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    InkWell(
                      child: Text("Quick Notes",
                          style: TextStyle(color: Colors.grey, fontSize: 15)),
                      onTap: () => showToast('Unlocked after Topic Test 3'),
                    ),
                    SizedBox(width: 10),
                    Icon(
                      Icons.lock,
                      color: Colors.grey,
                      size: 15,
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    InkWell(
                      child: Text("Learning History",
                          style: TextStyle(color: Colors.grey, fontSize: 15)),
                      onTap: () => showToast('Unlocked after Final Test'),
                    ),
                    SizedBox(width: 10),
                    Icon(
                      Icons.lock,
                      color: Colors.grey,
                      size: 15,
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    InkWell(
                      child: Text("Payment History",
                          style: TextStyle(color: Colors.grey, fontSize: 15)),
                      onTap: () => showToast('Unlocked after Final Test'),
                    ),
                    SizedBox(width: 10),
                    Icon(
                      Icons.lock,
                      color: Colors.grey,
                      size: 15,
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    InkWell(
                      child: Text("Settings",
                          style: TextStyle(color: Colors.grey, fontSize: 15)),
                      onTap: () => showToast('Unlocked after Final Test'),
                    ),
                    SizedBox(width: 10),
                    Icon(
                      Icons.lock,
                      color: Colors.grey,
                      size: 15,
                    ),
                  ],
                ),
                SizedBox(height: 10),
                InkWell(
                  child: Row(
                    children: [
                      Text(
                        "Logout",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      SizedBox(width: 10),
                      Icon(
                        Icons.power_settings_new,
                        color: Colors.white,
                        size: 15,
                      ),
                    ],
                  ),
                  onTap: () {
                    _showDialogs(context);
                  },
                ),
                SizedBox(height: 10),
                userID == '10032'
                    ? Row(
                        children: [
                          InkWell(
                            child: Text("Audio",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20)),
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                AudioDashboard.routeName,
                                arguments: userID,
                              );
                            },
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.audiotrack_rounded,
                            color: Colors.white,
                            size: 15,
                          ),
                        ],
                      )
                    : Container(),
                SizedBox(height: 10),
                userID == '10032'
                    ? Row(
                        children: [
                          InkWell(
                            child: Text("Sections",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20)),
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                SectionsDashboard.routeName,
                                arguments: userID,
                              );
                            },
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.apps_rounded,
                            color: Colors.white,
                            size: 15,
                          ),
                        ],
                      )
                    : Container(),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget dashboard(context) {
    return AnimatedPositioned(
      duration: duration,
      top: 0,
      bottom: 0,
      left: isCollapsed ? 0 : 0.6 * screenWidth!,
      right: isCollapsed ? 0 : -0.2 * screenWidth!,
      child: ScaleTransition(
        scale: _scaleAnimation!,
        child: Material(
          animationDuration: duration,
          elevation: 8,
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 48),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Showcase(
                      description: 'Tap to view Menu',
                      key: _one,
                      child: InkWell(
                        child: Icon(Icons.menu, color: Colors.black),
                        onTap: () {
                          setState(() {
                            check();
                            if (isCollapsed)
                              _controller!.forward();
                            else
                              _controller!.reverse();

                            isCollapsed = !isCollapsed;
                          });
                        },
                      ),
                    ),
                    Text("English Coach",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    Showcase(
                      key: _two,
                      description: 'Tap to Logout ',
                      child: GestureDetector(
                        child:
                            Icon(Icons.power_settings_new, color: Colors.black),
                        onTap: () {
                          _showDialogs(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Flexible(
                child: ModulesGrid(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
