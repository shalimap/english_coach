import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Models/trial_option.dart';
import 'dart:convert';

class TrialOption with ChangeNotifier {
  List<Trialoptions> _trialoptions = [];

  List<Trialoptions> get trialoptions => [..._trialoptions];

  Future<List<Trialoptions>> fetchOptions(quesnum) async {
    var parameter = {'trialNum': quesnum.toString()};
    var uri = Uri.https('www.api.englishcoach.app',
        '/api/bin/trialtest/getoptions.php', parameter);
    Map<String, String> headers = {"Content-Type": "application/json"};

    try {
      var response = await http.get(
        uri, /* headers: headers */
      );
      if (response.statusCode == 200) {
        List extractedData = json.decode(response.body);

        List<Trialoptions> trialOptions = [];

        for (var i = 0; i < extractedData.length; i++) {
          var options = Trialoptions.fromJson(extractedData[i]);

          trialOptions.add(options);
        }
        trialOptions.sort((a, b) => a.trialMcqNum!.compareTo(b.trialMcqNum!));

        _trialoptions = trialOptions;
        notifyListeners();
      }
    } catch (error) {
      print('ERROR : ' + error.toString());
      throw (error);
    }
    return _trialoptions;
  }
}
