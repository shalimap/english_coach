import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import '../models/module.dart';

class Modules with ChangeNotifier {
  List<Module> _chapters = [];

  List<Module> get chapters {
    return [..._chapters];
  }

  set chapters(List<Module> val) {
    _chapters = val;
    notifyListeners();
  }

  Module findById(int id) {
    return _chapters.firstWhere((mod) => mod.modNum == id);
  }

  nextModuleId(int count) {
    return (_chapters.skip(count).first.modNum);
  }

  nextModId(int count, List<Module> list) {
    return (list.skip(count).first.modNum);
  }

  Future<String?> fetchLevel(int id) async {
    String? level;

    var parameters = {'userId': id.toString()};
    var uri = Uri.https(
        'www.api.englishcoach.app', '/api/dev/level/getlevel.php', parameters);
    Map<String, String> headers = {"Content-Type": "application/json"};
    try {
      var response = await http.get(
        uri, /*  headers: headers */
      );
      if (response.statusCode == 200) {
        var levelData = json.decode(response.body);
        String userLevel = levelData[0]['sl_level'].toString();
        level = userLevel;
      }
    } catch (error) {
      print('ERROR : ' + error.toString());
      throw (error);
    }
    return level;
  }

  Future<List<Module>> fetchModules(String level) async {
    // var url = "http://www.api.englishcoach.app/api/dev/modules/modules" +
    //     level +
    //     ".php";
    var uri = Uri.https('www.api.englishcoach.app',
        '/api/dev/modules/modules' + '$level' + '.php');
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        List extractedData = json.decode(response.body);
        List<Module> loadedModules = [];
        for (var i = 0; i < extractedData.length; i++) {
          var module = Module.fromJson(extractedData[i]);
          loadedModules.add(module);
        }
        loadedModules.sort((a, b) => a.modOrder!.compareTo(b.modOrder!));
        _chapters = loadedModules;
        notifyListeners();
      }
    } catch (error) {
      print('ERROR : ' + error.toString());
      throw (error);
    }
    return _chapters;
  }

  Module findTopicNum(int modId) {
    return _chapters.firstWhere((mod) => mod.modNum == modId);
  }
}
