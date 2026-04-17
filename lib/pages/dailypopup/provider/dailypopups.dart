import 'package:englishcoach/api/api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import '../model/dailypopup.dart';

class DailyPopUps with ChangeNotifier {
  List<DailyPopUp> _dailypopups = [];

  List<DailyPopUp> get dailypopups {
    return [..._dailypopups];
  }

  Future<List<DailyPopUp>> fetchDailyPopUps(int userId) async {
    // var parameters = {'userId': userId.toString()};
    // var uri = Uri.https('www.api.englishcoach.app',
    //     '/api/dev/daily-popup/getpopupdata.php', parameters);
    // Map<String, String> headers = {"Content-Type": "application/json"};
    var uri = Uri.parse(Api.baseUrl +
        'dev/daily-popup/getpopupdata.php?userId=${userId.toString()}');
    try {
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        List extractedData = json.decode(response.body);
        List<DailyPopUp> dailyPopup = [];
        for (var i = 0; i < extractedData.length; i++) {
          var popup = DailyPopUp.fromJson(extractedData[i]);
          if (i == 0) dailyPopup.add(popup);
          if (i > 0) {
            if (dailyPopup[0].userId != popup.userId) dailyPopup.add(popup);
          }
        }
        dailyPopup.sort((a, b) => a.popupId!.compareTo(b.popupId!));
        _dailypopups = dailyPopup;
        notifyListeners();
      }
    } catch (error) {
      print('ERROR : ' + error.toString());
      throw (error);
    }
    return _dailypopups;
  }

  Future<void> addPopup(DailyPopUp popup) async {
    var parameters = {
      'popupId': popup.popupId.toString(),
      'userId': popup.userId.toString(),
      'dateTime': popup.dateTime!.toIso8601String(),
      'count': popup.count.toString(),
    };
    var uri = Uri.parse(
        'https://api.englishcoach.app/api/dev/daily-popup/insertpopupdata.php');
    try {
      await http.post(uri, body: parameters);
    } catch (error) {
      throw (error);
    }
  }

  Future<void> updatePopupData(
      int userId, int popupId, int count, DateTime dateTime) async {
    var parameters = {
      'userId': userId.toString(),
      'popupId': popupId.toString(),
      'count': count.toString(),
      'dateTime': dateTime.toIso8601String(),
    };
    var uri = Uri.parse(
        'https://api.englishcoach.app/api/dev/daily-popup/updatepopupdata.php');
    try {
      await http.post(uri, body: parameters);
    } catch (error) {
      throw (error);
    }
  }
}
