import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Models/getpictogramanswers.dart';

class PictogramAnswerList with ChangeNotifier {
  List<Pictogramanswers> _pictanslist = [];

  List<Pictogramanswers> get pictanslist => [..._pictanslist];

  Future<List<Pictogramanswers>> fetchanswer(pictId) async {
    var parameters = {'pictId': pictId.toString()};
    var uri = Uri.https('www.api.englishcoach.app',
        '/api/bin/pictogram/getpictogramanswers.php', parameters);
    Map<String, String> headers = {"Content-Type": "application/json"};

    try {
      var response = await http.get(
        uri, /* headers: headers */
      );
      if (response.statusCode == 200) {
        List extractedData = json.decode(response.body);
        List<Pictogramanswers> pictanswers = [];

        for (var i = 0; i < extractedData.length; i++) {
          var answer = Pictogramanswers.fromJson(extractedData[i]);
          pictanswers.add(answer);
        }

        _pictanslist = pictanswers;
        notifyListeners();
      }
    } catch (error) {
      throw error;
    }

    return _pictanslist;
  }
}
