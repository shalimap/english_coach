import 'package:englishcoach/common_widgets/disabledtextfield.dart';
import 'package:englishcoach/common_widgets/rounded_button.dart';
import 'package:englishcoach/config/color.dart';
import 'package:englishcoach/pages/profile/provider/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:date_format/date_format.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

class EditProfile extends StatefulWidget {
  static const routeName = '/editprofile';

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  int? _value;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettingsIOs = IOSInitializationSettings();
    var initSetttings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOs);

    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: onSelectNotification);
    // tz.initializeTimeZones();
    _configureLocalTimeZone();
  }

  void onSelectNotification(String? payload) {
    if (payload != null) {
      print('ok: $payload');
    }
  }

  @override
  void didChangeDependencies() {
    final profileData = ModalRoute.of(context)!.settings.arguments as Map;
    _editnum.text = profileData['phone'];
    _editemail.text = profileData['email'];
    _editname.text = profileData['username'];
    _value = profileData['img'] ?? 0;
    final stime = profileData['stime'];
    final formattedTime = TimeOfDay.fromDateTime(stime);
    selectedTime =
        TimeOfDay(hour: formattedTime.hour, minute: formattedTime.minute);

    _timeController.text = formatDate(stime, [hh, ':', nn, " ", am]).toString();

    studytime = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, selectedTime!.hour, selectedTime!.minute);

    check();
    super.didChangeDependencies();
  }

  void _avatarDialog(BuildContext context) {
    //_value = ModalRoute.of(context).settings.arguments;
    Size size = MediaQuery.of(context).size;
    var alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      title: Center(child: Text('Select an Avatar')),
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            height: size.height * 0.40,
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      InkWell(
                        onTap: () => setState(() => _value = 0),
                        child: SvgPicture.asset(
                          "assets/avatars/YBoy-01.svg",
                          width: _value == 0
                              ? size.width * 0.23
                              : size.width * 0.18,
                        ),
                      ),
                      InkWell(
                        onTap: () => setState(() => _value = 1),
                        child: SvgPicture.asset(
                          "assets/avatars/YGirl-01.svg",
                          width: _value == 1
                              ? size.width * 0.23
                              : size.width * 0.18,
                        ),
                      ),
                      InkWell(
                        onTap: () => setState(() => _value = 2),
                        child: SvgPicture.asset(
                          "assets/avatars/YMan-01.svg",
                          width: _value == 2
                              ? size.width * 0.23
                              : size.width * 0.18,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      InkWell(
                        onTap: () => setState(() => _value = 3),
                        child: SvgPicture.asset(
                          "assets/avatars/YWomen-01.svg",
                          width: _value == 3
                              ? size.width * 0.23
                              : size.width * 0.18,
                        ),
                      ),
                      InkWell(
                        onTap: () => setState(() => _value = 4),
                        child: SvgPicture.asset(
                          "assets/avatars/Men1.svg",
                          width: _value == 4
                              ? size.width * 0.23
                              : size.width * 0.18,
                        ),
                      ),
                      InkWell(
                        onTap: () => setState(() => _value = 5),
                        child: SvgPicture.asset(
                          "assets/avatars/Women-01.svg",
                          width: _value == 5
                              ? size.width * 0.23
                              : size.width * 0.18,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentcolor,
                      ),
                      onPressed: () {
                        check();
                        Navigator.of(context).pop();
                        setState(() {
                          _ischange = true;
                        });
                      },
                      child: Text(
                        'Submit',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  SvgPicture? imgList;
  check() {
    //_value = ModalRoute.of(context).settings.arguments;
    Size size = MediaQuery.of(context).size;
    setState(() {
      if (_value == 0) {
        imgList = SvgPicture.asset(
          "assets/avatars/YBoy-01.svg",
          width: size.width * 0.35,
        );
      } else if (_value == 1) {
        imgList = SvgPicture.asset(
          "assets/avatars/YGirl-01.svg",
          width: size.width * 0.35,
        );
      } else if (_value == 2) {
        imgList = SvgPicture.asset(
          "assets/avatars/YMan-01.svg",
          width: size.width * 0.35,
        );
      } else if (_value == 3) {
        imgList = SvgPicture.asset(
          "assets/avatars/YWomen-01.svg",
          width: size.width * 0.35,
        );
      } else if (_value == 4) {
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
      // else {
      //   imgList = SvgPicture.asset(
      //     "assets/avatars/Select-01.svg",
      //     width: size.width * 0.30,
      //   );
      // }
    });
  }

  final _editnum = TextEditingController();
  final _editemail = TextEditingController();
  final _editname = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final profileData = ModalRoute.of(context)!.settings.arguments as Map;
    final userId = int.parse(profileData['userId']);
    final name = profileData['username'];

    final curScaleFactor = MediaQuery.of(context).textScaleFactor;
    Size size = MediaQuery.of(context).size;
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
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
          ' Profile',
          style: GoogleFonts.solway(
              textStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                child: SizedBox(
                  height: 125,
                  width: 125,
                  child: Stack(
                    clipBehavior: Clip.none,
                    fit: StackFit.expand,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: imgList,
                      ),
                      Positioned(
                        bottom: 0,
                        right: -12,
                        child: SizedBox(
                          height: 46,
                          width: 46,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              backgroundColor: primaryColor,
                              // Color(0xFFF5F6F9),
                              shape: RoundedRectangleBorder(
                                // side: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                            onPressed: () {
                              _avatarDialog(context);
                            },
                            child: SvgPicture.asset(
                              "assets/icons/Camera Icon.svg",
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  _avatarDialog(context);
                },
              ),
              SizedBox(
                height: size.height * 0.03,
              ),

              // Text(
              //   'Profile Information',
              //   style: TextStyle(
              //     fontSize: 18 * curScaleFactor,
              //     fontWeight: FontWeight.bold,
              //   ),
              //   textAlign: TextAlign.start,
              // ),

              // SizedBox(
              //   height: size.height * 0.03,
              // ),

              DisabledInputField(
                  controller: _editname,
                  hintText: _editname.text,
                  icon: Icons.person),
              DisabledInputField(
                  controller: _editnum,
                  hintText: _editnum.text,
                  icon: Icons.phone),

              DisabledInputField(
                controller: _editemail,
                hintText: _editemail.text,
                icon: Icons.email,
              ),
              // TextButton(
              //   onPressed: () {
              //     _avatarDialog(context);
              //   },
              //   child: Text('Tap to change Profile picture'),
              // ),

              SizedBox(
                height: size.height * 0.03,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Change your studytime : ',
                      style: TextStyle(
                        fontSize: 13 * curScaleFactor,
                        fontWeight: FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Flexible(
                      child: InkWell(
                        onTap: () {
                          _selectTime(context);
                          setState(() {
                            _ischange = true;
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 10),
                          width: _width! / 2.5,
                          height: _height! / 12,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(50)),
                          child: TextFormField(
                            style: TextStyle(fontSize: 15),
                            textAlign: TextAlign.center,
                            onSaved: (String? val) {
                              _setTime = val!;
                            },
                            enabled: false,
                            keyboardType: TextInputType.text,
                            controller: _timeController,
                            decoration: InputDecoration(
                                disabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide.none),
                                // labelText: 'Time',
                                contentPadding: EdgeInsets.all(5)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: size.height * 0.1,
              ),
              !_updated
                  ? RoundedButton(
                      color: _ischange ? accentcolor : Colors.grey,
                      text: 'Save',
                      press: !_ischange
                          ? () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('There are no changes',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.solway())));
                            }
                          : () async {
                              print('study time:' + studytime.toString());
                              print('img value:' + _value.toString());
                              print('selectedTime:' + selectedTime.toString());
                              setState(() {
                                _updated = true;
                              });
                              try {
                                Provider.of<ProfileProvider>(context,
                                        listen: false)
                                    .updateProfile(userId, _value!, studytime)
                                    .then((_) {
                                  print('success');
                                  setState(() {
                                    _updated = false;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text('Profile updated',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.solway())));
                                });
                                await _scheduleDailyTenAMNotification();
                              } catch (e) {
                                print(e);
                                setState(() {
                                  _updated = false;
                                });
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text('There was an error',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.solway())));
                              }
                            },
                    )
                  : Center(
                      child: SpinKitThreeBounce(
                        color: Color(0xFF56c590),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }

  var _updated = false;
  var _ischange = false;

  double? _height;
  double? _width;
  TextEditingController _timeController = TextEditingController();
  String? _setTime;
  @override
  // void initState() {
  //   _timeController.text = formatDate(
  //       DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute),
  //       [hh, ':', nn, " ", am]).toString();
  //   super.initState();
  // }

  var studytime;
  // = DateTime(DateTime.now().year, DateTime.now().month,
  //     DateTime.now().day, TimeOfDay.now().hour, TimeOfDay.now().minute);

  TimeOfDay? selectedTime;
  //  = TimeOfDay(hour: 00, minute: 00);
  String? _hour, _minute, _time;

  Future<Null> _selectTime(BuildContext context) async {
    final now = new DateTime.now();
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime!,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime!.hour.toString();
        _minute = selectedTime!.minute.toString();
        _time = _hour! + ' : ' + _minute!;
        _timeController.text = _time!;
        _timeController.text = formatDate(
            DateTime(2019, 08, 1, selectedTime!.hour, selectedTime!.minute),
            [hh, ':', nn, " ", am]).toString();
        studytime = DateTime(now.year, now.month, now.day, selectedTime!.hour,
            selectedTime!.minute);
      });
  }

  Future<void> _scheduleDailyTenAMNotification() async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'Time Up',
        'Hey! Its time to study a new chapter!',
        _nextInstanceOfTenAM(),
        const NotificationDetails(
          android: AndroidNotificationDetails('daily notification channel id',
              'daily notification channel name',
              channelDescription: 'daily notification description'),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
    print('time :' + selectedTime!.hour.toString());
    print('time :' + selectedTime!.minute.toString());
    print('okkkkk');
  }

  tz.TZDateTime _nextInstanceOfTenAM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month,
        now.day, selectedTime!.hour, selectedTime!.minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String currentTimeZone =
        await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));
  }
}
