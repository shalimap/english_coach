import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Models/getpictogram.dart';

class PictogramList with ChangeNotifier {
  List<Pictogram> _pictogramlist = [];

  List<Pictogram> get pictogramlist => [..._pictogramlist];

  Future<List<Pictogram>> fetchpictogram() async {
    // var uri = Uri.https(
    //   'www.api.englishcoach.app',
    //   '/api/bin/pictogram/getpictogram.php',
    // );
    var uri = Uri.parse(
        'https://api.englishcoach.app/api/bin/pictogram/getpictogram.php');
    // Map<String, String> headers = {"Content-Type": "application/json"};

    try {
      var response = await http.get(
        uri,
      );
      if (response.statusCode == 200) {
        List extractedData = json.decode(response.body);
        List<Pictogram> pictogram = [];

        for (var i = 0; i < extractedData.length; i++) {
          var question = Pictogram.fromJson(extractedData[i]);
          pictogram.add(question);
        }
        pictogram.sort((a, b) => a.picId!.compareTo(b.picId!));
        _pictogramlist = pictogram;
        notifyListeners();
      }
    } catch (error) {
      print('ERROR : ' + error.toString());
      throw (error);
    }

    return _pictogramlist;
  }

  List<Pictogram> random() {
    var shuffled = _pictogramlist.toList()..shuffle();
    return shuffled;
  }

  int _pictogramindex = 0;

  int get pictogramindex => _pictogramindex;

  set pictogramindex(int val) {
    _pictogramindex = val;
    notifyListeners();
  }

  increment() {
    pictogramindex++;
  }

  // var _loadedPictogram = true;

  // bool get loadedPictogram => _loadedPictogram;
  // set loadedPictogram(bool val) {
  //   _loadedPictogram = val;
  //   notifyListeners();
  // }
}
