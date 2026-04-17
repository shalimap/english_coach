import 'package:englishcoach/api/api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import '../model/popuplist.dart';

class PopUpLists with ChangeNotifier {
  List<PopUpList> _popuplists = [];

  List<PopUpList> get popuplists {
    return [..._popuplists];
  }

  Future<List<PopUpList>> fetchPopupList() async {
    // var uri = Uri.https(
    //     'www.api.englishcoach.app', '/api/dev/daily-popup/getpopuplist.php');
    var uri = Uri.parse(Api.baseUrl + 'dev/daily-popup/getpopuplist.php');
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        List extractedData = json.decode(response.body);
        List<PopUpList> loadedPopupList = [];
        for (var i = 0; i < extractedData.length; i++) {
          var popUp = PopUpList.fromJson(extractedData[i]);
          loadedPopupList.add(popUp);
        }
        loadedPopupList.sort((a, b) => a.popupId!.compareTo(b.popupId!));
        _popuplists = loadedPopupList;
        print('pop-list');
        notifyListeners();
      }
    } catch (error) {
      print('ERROR : ' + error.toString());
      throw (error);
    }
    return _popuplists;
  }

  List<PopUpList> randomPopup(int popupId) {
    return _popuplists.where((pop) => pop.popupId != popupId).toList()
      ..shuffle();
  }

  List<PopUpList> findPopupById(int popupId) {
    return _popuplists.where((pop) => pop.popupId == popupId).toList();
  }

  int initialPopupId() {
    return _popuplists.first.popupId!;
  }
}
