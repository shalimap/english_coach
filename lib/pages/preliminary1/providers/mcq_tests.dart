import 'package:flutter/material.dart';
import '../Models/mcq_test.dart';

import 'package:http/http.dart' as http;

class McqTest with ChangeNotifier {
  List<Mcqtests> _mcqtest = [];

  List<Mcqtests> get mcqtest => [..._mcqtest];

  Future<int> addTest(Mcqtests tests) async {
    var parameters = {
      'userId': tests.userId.toString(),
    };
    var uri = Uri.parse(
      'https://api.englishcoach.app/api/exp/preliminary_1/insertmcqtest.php',
    );
    var testId;
    try {
      await http.post(uri, body: parameters).then((response) {
        final newTest = Mcqtests(
          userId: tests.userId,
          mcqPoints: 0,
          transPoints: 0,
          status: 0,
        );
        testId = int.parse(response.body);
        _mcqtest.add(newTest);
        notifyListeners();
      });
    } catch (error) {
      print(error);
    }
    return testId;
  }
}
