import 'package:flutter/services.dart';
import 'package:ndialog/ndialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/config/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'base_provider.dart';

class WidgetHelper {
  static final screenloading = Center(
    child: SpinKitCircle(
      color: primaryColor,
    ),
  );
  static final buttonloading = Center(
    child: SpinKitThreeBounce(
      color: accentcolor,
    ),
  );

  static Widget getProgressBar(ViewState viewState) {
    if (viewState == ViewState.Busy) {
      return Container(
        color: Colors.white.withAlpha(204),
        child: Center(child: screenloading),
      );
    } else {
      return Container();
    }
  }

  static Future<bool?> showToast(String msg,
      {Toast length = Toast.LENGTH_SHORT}) {
    return Fluttertoast.showToast(
      msg: msg,
      toastLength: length,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: primaryColor,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  static showError() {
    return DialogBackground(
      barrierColor: Colors.grey.withOpacity(1),
      blur: 0,
      dialog: AlertDialog(
        title: Row(
          children: [
            SizedBox(
              width: 40,
            ),
            Text(
              "No Internet",
              textAlign: TextAlign.center,
            ),
            SizedBox(
              width: 10,
            ),
            Icon(Icons.wifi_off_rounded)
          ],
        ),
        content: Text("You are not conneted to the Internet."),
        actions: <Widget>[
          TextButton(
            child: Text("Retry"),
            onPressed: () {
              //Navigator.of(context).pop();
              // Navigator.of(context).pushReplacementNamed(DemoPage.routeName);

              SystemChannels.platform.invokeMethod('Systemnavigator.pop');
            },
          ),
        ],
      ),
    );
  }

  static setPrefrenceBool(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  static Future<bool> getPrefrenceBool(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? true;
  }
}
