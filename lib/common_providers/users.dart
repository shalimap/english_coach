import 'dart:convert';

import 'package:englishcoach/config/base_provider.dart';
import 'package:englishcoach/config/widgetHelper.dart';

import 'package:englishcoach/pages/otp/screen/verificationpage.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../common_models/user.dart';
import '../api/api.dart';

class Userprovider extends BaseProvider {
  User? _user;
  User? get user => _user;

  Future isMobileNumExists(String mobileNum) async {
    var uri = Uri.parse(Api.ismobileExists + Uri.encodeComponent(mobileNum));
    try {
      setBusy();
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final extractedData = json.decode(response.body);
        setIdle();
        return extractedData;
      }
    } catch (e) {
      setIdle();
      print('Error when checking ismobileExists error: ' + e.toString());
    }
  }

  Future addUser(User user, context) async {
    var uri = Uri.parse(Api.signupUrl);
    var arguments = {
      "userName": user.userName,
      "userEmail": user.userEmail,
      "userMob": user.userMob,
      "userPswd": user.userPswd
    };
    try {
      setBusy();
      final response = await http.post(uri, body: arguments);
      if (response.statusCode == 200) {
        final newuser = User(
          userName: user.userName,
          userEmail: user.userEmail,
          userMob: user.userMob,
          userPswd: user.userPswd,
        );
        _user = newuser;
        notifyListeners();
        print('user added');
        Navigator.of(context).pushReplacementNamed(
          PhoneVerification.routename,
          arguments: {
            'key': 1,
          },
        );
        setIdle();
      } else {
        WidgetHelper.showToast('An error occured');
      }
    } catch (e) {
      print(e);
    }
  }

  Future editPermission() async {
    var uri = Uri.parse(Api.editpermission);
    String phonenum = await getPhonenumber();
    try {
      await http.post(uri, body: {"userMob": phonenum});
    } catch (e) {
      print(e);
    }
  }

  getUserwithphonenum(String mobileNum) async {
    var uri = Uri.parse(Api.ismobileExists + Uri.encodeComponent(mobileNum));
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        List<dynamic> extractedData = json.decode(response.body);
        var data = extractedData.map((e) => User.fromJson(e)).toList();
        _user = data[0];
        notifyListeners();
        if (_user != null) {
          saveUserdetails(
              userId: _user!.userId ?? '',
              userName: _user!.userName ?? '',
              userEmail: _user!.userEmail ?? '',
              userMob: _user!.userMob ?? '');
        }
      }
    } catch (e) {
      _user = null;
      notifyListeners();
      print('Error occured when fetching user with mobile :' + e.toString());
    }
  }

  login(String userName, String pswd) async {
    var uri = Uri.parse(Api.loginUrl);
    var arguments = {
      "userMob": userName,
      "userPswd": pswd,
    };
    try {
      setBusy();
      final response = await http.post(uri, body: arguments);
      if (response.statusCode == 200) {
        List<dynamic> extractedData = json.decode(response.body);
        var data = extractedData.map((e) => User.fromJson(e)).toList();
        _user = data[0];
        print(data[0].userMob);
        notifyListeners();
        if (_user != null) {
          saveUserdetails(
              userId: _user!.userId ?? '',
              userName: _user!.userName ?? '',
              userEmail: _user!.userEmail ?? '',
              userMob: _user!.userMob ?? '');
        }

        setIdle();
      }
    } catch (e) {
      _user = null;
      notifyListeners();
      clearUser();

      print('login error :' + e.toString());
      setIdle();
    }
  }

  void setPhonenumber(String value) async {
    final _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.setString('phone', value);
  }

  Future<String> getPhonenumber() async {
    final _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences.getString('phone') ?? '';
  }

  void setnumwithoutcountrycode(String value) async {
    final _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.setString('withoutcode', value);
  }

  Future<String> getnumwithoutcountrycode() async {
    final _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences.getString('withoutcode') ?? '';
  }

  saveUserdetails({userId, userName, userEmail, userMob}) async {
    final _sharedPreferences = await SharedPreferences.getInstance();
    final userData = json.encode({
      'userid': userId,
      'username': userName,
      'useremail': userEmail,
      'usermob': userMob,
    });
    _sharedPreferences.setString('userData', userData);
    print('user saved successfully');
  }

  clearUser() async {
    final _sharedPreferences = await SharedPreferences.getInstance();
    await _sharedPreferences.remove('userData');
    print('user removed successfully');
  }

  Future getStatus(userid) async {
    var uri =
        Uri.parse('https://api.englishcoach.app/api/bin/profile/getstatus.php');
    final response = await http.post(uri, body: {
      "userId": userid,
    });
    var convertedDatatoJson = json.decode(response.body);
    return convertedDatatoJson;
  }

  Future getLevel(userid) async {
    var uri = Uri.parse(
      'https://api.englishcoach.app/api/bin/login/getlevel.php',
    );
    final response = await http.post(uri, body: {
      "userId": userid,
    });
    var convertedDatatoJson = json.decode(response.body);

    return convertedDatatoJson;
  }

  Future getpaymentStatus(userid) async {
    var uri = Uri.parse(
        'https://api.englishcoach.app/api/bin/login/getpaymentstatus.php');
    final response = await http.post(uri, body: {
      "userId": userid,
    });
    var convertedDatatoJson = json.decode(response.body);
    return convertedDatatoJson;
  }

  Future reset(String mobile, String password) async {
    try {
      var url =
          Uri.parse('https://api.englishcoach.app/api/bin/Signup/reset.php');
      await http.post(url, body: {
        "userMob": mobile,
        "Password": password,
      });
    } catch (error) {
      print(error);
    }
  }
}
