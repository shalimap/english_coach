import 'dart:convert';

import 'package:englishcoach/api/api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Models/mcq_option.dart';

class McqOption with ChangeNotifier {
  List<Mcqoptions> _mcqoptions = [];

  List<Mcqoptions> get mcqoptions => [..._mcqoptions];

  Future<List<Mcqoptions>> fetchOptions(quesnum) async {
    var parameter = {'mcqQuesNum': quesnum.toString()};

    var uri = Uri.parse(Api.baseUrl +
        'exp/preliminary_1/getoptions.php?mcqQuesNum=${quesnum.toString()}');
    //
    /*   var uri = Uri.https('www.api.englishcoach.app',
        '/api/exp/preliminary_1/getoptions.php', parameter); 
         Map<String, String> headers = {"Content-Type": "application/json"};*/

    try {
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        List extractedData = json.decode(response.body);

        List<Mcqoptions> mcqOptions = [];

        for (var i = 0; i < extractedData.length; i++) {
          var options = Mcqoptions.fromJson(extractedData[i]);

          mcqOptions.add(options);
        }
        mcqOptions
            .sort((a, b) => a.prelimMcquesNum!.compareTo(b.prelimMcquesNum!));

        _mcqoptions = mcqOptions;
        notifyListeners();
      }
    } catch (error) {
      print('ERRORO : ' + error.toString());
      throw (error);
    }
    return _mcqoptions;
  }
}
