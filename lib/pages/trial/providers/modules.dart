import 'package:englishcoach/api/api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import '../models/module.dart';

class TrialModules with ChangeNotifier {
  List<Module> _trialchapters = [];

  List<Module> get chapters {
    return [..._trialchapters];
  }

  // set chapters(List<Module> val) {
  //   _trialchapters = val;
  //   notifyListeners();
  // }

  Module findById(int id) {
    return _trialchapters.firstWhere((mod) => mod.modNum == id);
  }

  nextModuleId(int count) {
    return (_trialchapters.skip(count).first.modNum);
  }

  // nextModId(int count, List<Module> list) {
  //   print('checknull :' + (list.skip(count).first.modNum).toString());
  //   return (list.skip(count).first.modNum);
  // }
  int nextModId(int count, List<Module> list) {
    if (list.isEmpty || list.length <= count) {
      // Handle the case where the list is empty or doesn't have enough elements
      return -1; // or some default value or throw an exception
    }

    print('checknull :' + '${list[count].modNum.toString()}');
    return list[count].modNum!;
  }

  Future<String> fetchLevel(int id) async {
    String? level;

    var parameters = {'userId': id.toString()};
    // var uri = Uri.https(
    //     'www.api.englishcoach.app', '/api/dev/level/getlevel.php', parameters);
    // Map<String, String> headers = {"Content-Type": "application/json"};
    var uri = Uri.parse(
        Api.baseUrl + 'dev/level/getlevel.php?userId=${id.toString()}');
    try {
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        var levelData = json.decode(response.body);
        String userLevel = levelData[0]['sl_level'].toString();
        level = userLevel;
      }
    } catch (error) {
      print('ERROR : ' + error.toString());
      throw (error);
    }
    return level!;
  }

  Future<List<Module>> fetchTrialModules() async {
    var url =
        Uri.parse("https://api.englishcoach.app/api/dev/trial/modules.php");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List extractedData = json.decode(response.body);
        List<Module> loadedTrialModules = [];
        for (var i = 0; i < extractedData.length; i++) {
          var module = Module.fromJson(extractedData[i]);
          loadedTrialModules.add(module);
        }
        loadedTrialModules.sort((a, b) => a.modOrder!.compareTo(b.modOrder!));
        _trialchapters = loadedTrialModules;
        notifyListeners();
      }
    } catch (error) {
      print('ERROR : ' + error.toString());
      throw (error);
    }
    return _trialchapters;
  }

  Module findTopicNum(int modId) {
    return _trialchapters.firstWhere((mod) => mod.modNum == modId);
  }
}
