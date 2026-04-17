import 'package:englishcoach/common_providers/users.dart';
import 'package:englishcoach/common_widgets/disabledtextfield.dart';
import 'package:englishcoach/common_widgets/profiletextfieldcontainer.dart';
import 'package:englishcoach/common_widgets/rounded_button.dart';
import 'package:englishcoach/common_widgets/text_field_container.dart';
import 'package:englishcoach/config/color.dart';
import 'package:englishcoach/config/widgetHelper.dart';
import 'package:englishcoach/pages/preliminary1/screens/mcqlandingpage.dart';
import 'package:englishcoach/pages/profile/provider/profile_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../../config/responsive.dart';

enum choices { m, f }

choices _selected = choices.m;

class ProfilePage extends StatefulWidget {
  static const routename = '/profile-screen';
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  String _selectDateString = 'Date Of Birth';
  String _selectTimeString = 'Pick your study time';
  final _editnum = TextEditingController();
  final _editemail = TextEditingController();
  final _editkey = GlobalKey<FormState>();
  GlobalKey _propic = GlobalKey();
  DateTime _selectedDate = DateTime.now().subtract(Duration(days: 1095));
  int _value = 0;

  @override
  void initState() {
    _populateDropdown();
    _qualDropdown();

    super.initState();
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettingsIOs = IOSInitializationSettings();
    var initSetttings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOs);

    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: onSelectNotification);
    _configureLocalTimeZone();
  }

  var _isInit = true;
  var _isLoading = false;
  @override
  void didChangeDependencies() {
    final userData = Provider.of<Userprovider>(context, listen: false).user;
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<ProfileProvider>(context, listen: false)
          .fetchStates()
          .then(
            (_) => Provider.of<ProfileProvider>(context, listen: false)
                .fetchDistricts(),
          )
          .then((_) =>
              Provider.of<ProfileProvider>(context, listen: false).getData())
          .then((_) => setState(() {
                _isLoading = false;
              }));
      _isInit = false;
      check();
    }

    if (userData != null) {
      _editnum.text = userData.userMob ?? '';
      _editemail.text = userData.userEmail ?? '';
    }

    // print(response);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    SharedPreferences preferences;
    final userData = Provider.of<Userprovider>(context, listen: false);
    final provinceData = Provider.of<ProfileProvider>(context);
    final qualData = Provider.of<ProfileProvider>(context, listen: false);
    Size size = MediaQuery.of(context).size;
    final curScaleFactor = MediaQuery.of(context).textScaleFactor;
    showShowcase() async {
      preferences = await SharedPreferences.getInstance();
      bool? showcasevisible = preferences.getBool('excerciseshowcase');

      if (showcasevisible == null) {
        preferences.setBool('excerciseshowcase', false);
        return true;
      }
      return false;
    }

    showShowcase().then((status) {
      if (status) {
        ShowCaseWidget.of(context).startShowCase([_propic]);
      }
    });
    return SafeArea(
      child: WillPopScope(
        onWillPop: () => Future.value(false),
        child: Scaffold(
          body: Form(
            key: _editkey,
            child: _isLoading
                ? WidgetHelper.screenloading
                : _mainbody(
                    size, curScaleFactor, userData, qualData, provinceData),
          ),
        ),
      ),
    );
  }

  _mainbody(Size size, double curScaleFactor, Userprovider userData,
      ProfileProvider qualData, ProfileProvider provinceData) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(size.width * 0.06),
      child: Padding(
        padding: Responsive.isDesktop(context)
            ? EdgeInsets.symmetric(horizontal: size.width * 0.2)
            : const EdgeInsets.all(0.0),
        child: Column(
          children: [
            _getTitle(curScaleFactor),
            SizedBox(height: size.height * 0.03),
            _getProfic(),
            _getName(curScaleFactor, userData),
            _getphone(),
            _getmail(),
            _selectGender(size),
            _selectQualifications(curScaleFactor, size, qualData),
            _dateField(size),
            // _setTimeField(size),
            _stateField(size, provinceData, curScaleFactor),
            _districtField(curScaleFactor, size),
            SizedBox(height: size.height * 0.03),
            _submitButton(qualData, userData),
          ],
        ),
      ),
    );
  }

  _getTitle(double curScaleFactor) {
    return Text(
      'My Account',
      style: TextStyle(
        fontSize: 18 * curScaleFactor,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }

  _getProfic() {
    return Showcase(
      key: _propic,
      description: 'Tap to change your profile picture',
      child: InkWell(
        onTap: () {
          _avatarDialog(context);
        },
        child: _propicwithcamicon(),
      ),
    );
  }

  _propicwithcamicon() {
    return SizedBox(
      height: 125,
      width: 125,
      child: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.expand,
        children: <Widget>[
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
                  shape: RoundedRectangleBorder(
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
    );
  }

  _getName(double curScaleFactor, Userprovider userData) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        userData.user!.userName ?? '',
        style: TextStyle(
            fontSize: 18 * curScaleFactor, fontWeight: FontWeight.bold),
      ),
    );
  }

  _getphone() {
    return DisabledInputField(
      controller: _editnum,
      hintText: _editnum.text,
      icon: Icons.phone,
    );
  }

  _getmail() {
    return DisabledInputField(
      controller: _editemail,
      hintText: _editemail.text,
      icon: Icons.email,
    );
  }

  _selectGender(Size size) {
    return Padding(
      padding: EdgeInsets.only(left: size.width * 0.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Icon(Icons.wc, color: accentcolor),
          Radio<choices>(
            value: choices.m,
            groupValue: _selected,
            onChanged: setselectedChoice,
          ),
          GestureDetector(
            onTap: () => setselectedChoice,
            child: Text('Male'),
          ),
          SizedBox(
            width: size.width * 0.02,
          ),
          Radio<choices>(
            value: choices.f,
            groupValue: _selected,
            onChanged: setselectedChoice,
          ),
          GestureDetector(
            onTap: () => setselectedChoice,
            child: Text('Female'),
          ),
        ],
      ),
    );
  }

  _selectQualifications(
      double curScaleFactor, Size size, ProfileProvider qualData) {
    return ProfileFieldContainer(
      child: Row(
        children: <Widget>[
          Icon(
            Icons.queue,
            color: accentcolor,
          ),
          SizedBox(
            width: Responsive.isDesktop(context)
                ? size.width * 0.02
                : size.width * 0.05,
          ),
          Expanded(
            child: new DropdownButton(
              isExpanded: true,
              items: qualData.qualifications.map((item) {
                return new DropdownMenuItem(
                  child: new Text(item.qualName!),
                  value: item.qualId.toString(),
                );
              }).toList(),
              onChanged: (String? newVal) {
                setState(() {
                  _qual = newVal;
                });

                // print(testingList.toString());
              },
              value: _qual,
              hint: Text('select your qualification',
                  style: TextStyle(fontSize: 15 * curScaleFactor)),
            ),
          ),
        ],
      ),
    );
  }

  _dateField(Size size) {
    return InkWell(
      child: ProfileFieldContainer(
        child: TextFieldContainer(
          child: Row(
            children: <Widget>[
              Icon(
                Icons.cake,
                color: accentcolor,
              ),
              SizedBox(
                width: size.width * 0.05,
              ),
              Text(_selectDateString),
            ],
          ),
        ),
      ),
      onTap: () {
        _selectDate(context);
      },
    );
  }

  _setTimeField(Size size) {
    return GestureDetector(
      child: ProfileFieldContainer(
        child: TextFieldContainer(
          child: Row(
            children: <Widget>[
              Icon(
                Icons.timer,
                color: accentcolor,
              ),
              SizedBox(
                width: size.width * 0.05,
              ),
              Text(_selectTimeString),
            ],
          ),
        ),
      ),
      onTap: () {
        selectedTime(context);
      },
    );
  }

  _stateField(Size size, ProfileProvider provinceData, double curScaleFactor) {
    return ProfileFieldContainer(
      child: Row(
        children: <Widget>[
          Icon(
            Icons.add_location,
            color: accentcolor,
          ),
          SizedBox(
            width: Responsive.isDesktop(context)
                ? size.width * 0.02
                : size.width * 0.05,
          ),
          Expanded(
            child: new DropdownButton(
              isExpanded: true,
              // icon: const Icon(Icons.add_location),
              items: provinceData.states.map((item) {
                return new DropdownMenuItem(
                  child: new Text(item.stateName!),
                  value: item.stateId.toString(),
                );
              }).toList(),
              onChanged: (String? newVal) {
                setState(() {
                  _district = null;
                  _state = newVal;
                  tempList = provinceData.districts
                      .where((x) => x.stateId.toString() == (_state.toString()))
                      .toList();
                });

                // print(testingList.toString());
              },
              value: _state,

              hint: Text(
                'select your state',
                style: TextStyle(fontSize: 15 * curScaleFactor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _districtField(double curScaleFactor, Size size) {
    return ProfileFieldContainer(
      child: Row(
        children: <Widget>[
          Icon(
            Icons.gps_fixed,
            color: accentcolor,
          ),
          SizedBox(
            width: Responsive.isDesktop(context)
                ? size.width * 0.02
                : size.width * 0.05,
          ),
          Expanded(
            child: new DropdownButton(
              isExpanded: true,
              //icon: const Icon(Icons.gps_fixed),
              items: tempList.map((item) {
                return new DropdownMenuItem(
                  child: new Text(item.distName),
                  value: item.distId.toString(),
                );
              }).toList(),
              onChanged: (String? newVal) {
                setState(() {
                  _district = newVal;
                });
              },
              value: _district,
              hint: Text('select your district',
                  style: TextStyle(fontSize: 15 * curScaleFactor)),
            ),
          ),
        ],
      ),
    );
  }

  _submitButton(ProfileProvider profile, Userprovider userData) {
    return Padding(
      padding: Responsive.isDesktop(context)
          ? EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.15)
          : const EdgeInsets.all(0.0),
      child: RoundedButton(
        color: accentcolor,
        text: 'Submit',
        press: () async {
          try {
            profile.addProfile(
                int.parse(userData.user!.userId!),
                _value,
                studytime,
                int.parse(_qual!),
                _selected.index.toString(),
                DateTime.parse(_selectDateString),
                int.parse(_state!),
                int.parse(_district!));
            Navigator.of(context).popAndPushNamed(McqLandingPage.routename,
                arguments: userData.user!.userId!);
            await _scheduleDailyTenAMNotification();
          } catch (error) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Please complete your profile')));
          }
        },
      ),
    );
  }

//Qualifications Dropdown
  List qualList = [];
  String? _qual;
  _qualDropdown() {
    final qualData = Provider.of<ProfileProvider>(context, listen: false);
    setState(() {
      qualList = qualData.qualifications;
    });
  }

  //districts & states

  List statesList = [];
  List districtList = [];
  List tempList = [];
  String? _state;
  String? _district;

  _populateDropdown() {
    final provinceData = Provider.of<ProfileProvider>(context, listen: false);
    setState(() {
      statesList = provinceData.states;
      districtList = provinceData.districts;
    });
  }

//Local notifications
  void onSelectNotification(String? payload) {
    if (payload != null) {
      print('ok: $payload');
    }
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String currentTimeZone =
        await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));
  }

//gender
  setselectedChoice(choices? value) {
    setState(() {
      _selected = value!;
    });
  }

  //select date

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime.now().subtract(Duration(days: 29180)),
        lastDate: DateTime.now().subtract(Duration(days: 1095)));
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
        _selectDateString = "${_selectedDate.toLocal()}".split(' ')[0];
      });
  }

  //select Time
  TimeOfDay _time = TimeOfDay.now();
  TimeOfDay? _picked;
  Future<Null> selectedTime(BuildContext context) async {
    _picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (_picked != null && _picked.toString() != _selectTimeString) {
      setState(() {
        _time = _picked!;
        _selectTimeString = "${_time.hour} : ${_time.minute} : 00";

        print(_time);
        print(_selectTimeString);
      });
      ondateTimeChanged();
    }
  }

  var studytime = DateTime(DateTime.now().year, DateTime.now().month,
      DateTime.now().day, DateTime.now().hour, DateTime.now().minute);
  void ondateTimeChanged() {
    setState(() {
      final now = new DateTime.now();
      studytime =
          DateTime(now.year, now.month, now.day, _time.hour, _time.minute);
    });
  }

  //set Local notifications

  Future<void> _scheduleDailyTenAMNotification() async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'Time Up',
        'Hey! Its time to study a new chapter!',
        _nextInstanceOfTenAM(),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'daily notification channel id',
            'daily notification channel name',
            channelDescription: 'daily notification description',
          ),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
    print('time :' + _time.hour.toString());
    print('time :' + _time.minute.toString());
    print('okkkkk');
  }

  tz.TZDateTime _nextInstanceOfTenAM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, _time.hour, _time.minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  void _avatarDialog(BuildContext context) {
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
                              ? kIsWeb
                                  ? size.width * 0.10
                                  : size.width * 0.23
                              : kIsWeb
                                  ? size.width * 0.08
                                  : size.width * 0.18,
                        ),
                      ),
                      InkWell(
                        onTap: () => setState(() => _value = 1),
                        child: SvgPicture.asset(
                          "assets/avatars/YGirl-01.svg",
                          width: _value == 1
                              ? kIsWeb
                                  ? size.width * 0.10
                                  : size.width * 0.23
                              : kIsWeb
                                  ? size.width * 0.08
                                  : size.width * 0.18,
                        ),
                      ),
                      InkWell(
                        onTap: () => setState(() => _value = 2),
                        child: SvgPicture.asset(
                          "assets/avatars/YMan-01.svg",
                          width: _value == 2
                              ? kIsWeb
                                  ? size.width * 0.10
                                  : size.width * 0.23
                              : kIsWeb
                                  ? size.width * 0.08
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
                              ? kIsWeb
                                  ? size.width * 0.10
                                  : size.width * 0.23
                              : kIsWeb
                                  ? size.width * 0.08
                                  : size.width * 0.18,
                        ),
                      ),
                      InkWell(
                        onTap: () => setState(() => _value = 4),
                        child: SvgPicture.asset(
                          "assets/avatars/Men1.svg",
                          width: _value == 4
                              ? kIsWeb
                                  ? size.width * 0.10
                                  : size.width * 0.23
                              : kIsWeb
                                  ? size.width * 0.08
                                  : size.width * 0.18,
                        ),
                      ),
                      InkWell(
                        onTap: () => setState(() => _value = 5),
                        child: SvgPicture.asset(
                          "assets/avatars/Women-01.svg",
                          width: _value == 5
                              ? kIsWeb
                                  ? size.width * 0.10
                                  : size.width * 0.23
                              : kIsWeb
                                  ? size.width * 0.08
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
}
