import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import '../model/section.dart';

class Sections with ChangeNotifier {
  List<Section> _sections = [];

  List<Section> get sections {
    return [..._sections];
  }

  set sections(List<Section> val) {
    _sections = val;
    notifyListeners();
  }

  Section findById(int id) {
    return _sections.firstWhere((sec) => sec.secId == id);
  }

  nextAudioId(int count) {
    return (_sections.skip(count).first.secId);
  }

  Future<List<Section>> fetchSections() async {
    var uri =
        Uri.https('www.api.englishcoach.app', '/api/dev/audio/sections.php');
    Map<String, String> headers = {"Content-Type": "application/json"};
    try {
      var response = await http.get(
        uri, /* headers: headers */
      );
      if (response.statusCode == 200) {
        List extractedData = json.decode(response.body);
        List<Section> loadedSections = [];
        for (var i = 0; i < extractedData.length; i++) {
          var section = Section.fromJson(extractedData[i]);
          loadedSections.add(section);
        }
        loadedSections.sort((a, b) => a.secId!.compareTo(b.secId!));
        _sections = loadedSections;
        notifyListeners();
      }
    } catch (error) {
      print('ERROR : ' + error.toString());
      throw (error);
    }
    return _sections;
  }
}
