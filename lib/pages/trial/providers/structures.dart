import 'package:englishcoach/api/api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import '../models/structure.dart';

class TrialStructures with ChangeNotifier {
  List<Structure> _structures = [];

  List<Structure> get examples {
    return [..._structures];
  }

  List<Structure> findStructures(int modId) {
    return _structures.where((example) => example.modNum == modId).toList();
  }

  Future<void> fetchStructures(int id) async {
    var parameters = {'modId': id.toString()};

    var uri = Uri.parse(
        Api.baseUrl + 'dev/modules/structure.php?modId=${id.toString()}');
    // var uri = Uri.https('www.api.englishcoach.app',
    //     '/api/dev/modules/structure.php', parameters);
    // Map<String, String> headers = {"Content-Type": "application/json"};
    try {
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        List extractedData = json.decode(response.body);
        List<Structure> loadedStructures = [];
        for (var i = 0; i < extractedData.length; i++) {
          var structure = Structure.fromJson(extractedData[i]);
          loadedStructures.add(structure);
        }
        loadedStructures.sort((a, b) => a.structNum!.compareTo(b.structNum!));
        _structures = loadedStructures;
        notifyListeners();
      }
    } catch (error) {
      print('ERROR : ' + error.toString());
      throw (error);
    }
  }
}
