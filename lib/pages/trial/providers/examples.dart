import 'package:englishcoach/api/api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import '../models/example.dart';

class TrialExamples with ChangeNotifier {
  List<Example> _examples = [];

  List<Example> get examples {
    return [..._examples];
  }

  List<Example> findExamples(int modId) {
    return _examples.where((example) => example.modNum == modId).toList();
  }

  Future<void> fetchExamples(int id) async {
    // var parameters = {'modId': id.toString()};
    var uri = Uri.parse(
        Api.baseUrl + 'dev/modules/examples.php?modId=${id.toString()}');
    // var uri = Uri.https('www.api.englishcoach.app',
    //     '/api/dev/modules/examples.php', parameters);
    // Map<String, String> headers = {"Content-Type": "application/json"};
    try {
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        List extractedData = json.decode(response.body);
        List<Example> loadedModules = [];
        for (var i = 0; i < extractedData.length; i++) {
          var module = Example.fromJson(extractedData[i]);
          loadedModules.add(module);
        }
        loadedModules.sort((a, b) => a.exNum!.compareTo(b.exNum!));
        _examples = loadedModules;
        notifyListeners();
      }
    } catch (error) {
      print('ERROR : ' + error.toString());
      throw (error);
    }
  }
}
