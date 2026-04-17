import 'package:englishcoach/common_widgets/disabledtextfield.dart';
import 'package:englishcoach/common_widgets/rounded_button.dart';
import 'package:englishcoach/config/color.dart';
import 'package:englishcoach/pages/Modules/screens/menu_dashboard_page.dart';
import 'package:englishcoach/pages/profile/provider/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:intl/intl.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

class SelectStudyTime extends StatefulWidget {
  static const routeName = '/updateStudytime';

  @override
  _SelectStudyTimeState createState() => _SelectStudyTimeState();
}

class _SelectStudyTimeState extends State<SelectStudyTime> {
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
    DateTime stime = DateTime.now();

    final formattedTime = TimeOfDay.fromDateTime(stime);
    selectedTime =
        TimeOfDay(hour: formattedTime.hour, minute: formattedTime.minute);

    _timeController.text = formatDate(stime, [hh, ':', nn, " ", am]).toString();

    studytime = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, selectedTime!.hour, selectedTime!.minute);

    super.didChangeDependencies();
  }

  _mainLogo(Size size) {
    return Image.asset(
      "assets/icons/Icon.png",
      height: size.height * 0.25,
    );
  }

  @override
  Widget build(BuildContext context) {
    final userID = ModalRoute.of(context)!.settings.arguments;
    int userId = int.parse(userID.toString());

    final curScaleFactor = MediaQuery.of(context).textScaleFactor;
    Size size = MediaQuery.of(context).size;
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   elevation: 0.0,
      //   centerTitle: true,
      // ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: size.height * 0.13,
              ),
              _mainLogo(size),
              SizedBox(
                height: size.height * 0.03,
              ),
              Text(
                'Choose your Studytime',
                style: TextStyle(
                  fontSize: 18 * curScaleFactor,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              InkWell(
                onTap: () {
                  _selectTime(context);
                  setState(() {
                    _ischange = true;
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(top: 10),
                  width: _width! / 2,
                  height: _height! / 10,
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
                        disabledBorder:
                            UnderlineInputBorder(borderSide: BorderSide.none),
                        // labelText: 'Time',
                        contentPadding: EdgeInsets.all(5)),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.1,
              ),
              !_updated
                  ? RoundedButton(
                      color: accentcolor,
                      text: 'Next',
                      press: () async {
                        print('study time:' + studytime.toString());

                        print('selectedTime:' + selectedTime.toString());
                        setState(() {
                          _updated = true;
                        });
                        try {
                          Provider.of<ProfileProvider>(context, listen: false)
                              .setstudyTime(userId, studytime)
                              .then((_) {
                            print('success');
                            setState(() {
                              _updated = false;
                            });

                            Navigator.of(context).pushNamedAndRemoveUntil(
                                MenuDashboardPage.routeName, (route) => false,
                                arguments: userId);
                          });
                          await _scheduleDailyTenAMNotification();
                        } catch (e) {
                          print(e);
                          setState(() {
                            _updated = false;
                          });
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
