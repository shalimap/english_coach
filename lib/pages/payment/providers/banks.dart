import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import '../models/bank.dart';

class Banks with ChangeNotifier {
  List<Bank> _banks = [];

  List<Bank> get banks {
    return [..._banks];
  }

  Future<List<Bank>> fetchBanks() async {
    var uri =
        Uri.https('www.api.englishcoach.app', '/api/dev/payment/bank.php');
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        List extractedData = json.decode(response.body);
        List<Bank> loadedBanks = [];
        for (var i = 0; i < extractedData.length; i++) {
          var bank = Bank.fromJson(extractedData[i]);
          loadedBanks.add(bank);
        }
        loadedBanks.sort((a, b) => a.bankId!.compareTo(b.bankId!));
        _banks = loadedBanks;
        notifyListeners();
      }
    } catch (error) {
      print('ERROR : ' + error.toString());
      //throw (error);
    }
    return _banks;
  }
}
