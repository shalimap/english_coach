import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import '../model/audiomarksheet.dart';

class AudioMarksheets with ChangeNotifier {
  List<AudioMarksheet> _audioMarksheets = [];

  List<AudioMarksheet> get audioMarksheets {
    return [..._audioMarksheets];
  }

  Future<List<AudioMarksheet>> fetchMarksheet(int testId) async {
    var parameters = {'audTestId': testId.toString()};
    var uri = Uri.https('www.api.englishcoach.app',
        '/api/dev/audio/getaudiomarksheet.php', parameters);
    Map<String, String> headers = {"Content-Type": "application/json"};
    try {
      var response = await http.get(
        uri, /* headers: headers */
      );
      if (response.statusCode == 200) {
        List extractedData = json.decode(response.body);
        List<AudioMarksheet> loadedMarksheet = [];
        for (var i = 0; i < extractedData.length; i++) {
          var marksheet = AudioMarksheet.fromJson(extractedData[i]);
          loadedMarksheet.add(marksheet);
        }
        _audioMarksheets = loadedMarksheet;
        notifyListeners();
      }
    } catch (error) {
      print('ERROR : ' + error.toString());
      // throw (error);
    }
    return _audioMarksheets;
  }

  AudioMarksheet findById(int id) {
    return _audioMarksheets.firstWhere((report) => report.audTestId == id);
  }

  List<AudioMarksheet> findByTestId(int id) {
    return _audioMarksheets.where((report) => report.audTestId == id).toList();
  }

  Future<int> addNewMarksheet(AudioMarksheet marksheet) async {
    var markId;
    var parameters = {
      'audTestId': marksheet.audTestId.toString(),
      'userId': marksheet.userId.toString(),
      'audNum': marksheet.audNum.toString(),
      'audQuesNum': marksheet.audQuesNum.toString(),
      'audAnswer': marksheet.audAnswered,
    };
    var uri = Uri.https('www.api.englishcoach.app',
        '/api/dev/audio/insertaudiomarksheet.php', parameters);
    try {
      await http.post(uri).then((response) {
        final newMarksheet = AudioMarksheet(
          audMarkId: int.parse(response.body),
          audTestId: marksheet.audTestId,
          userId: marksheet.userId,
          audNum: marksheet.audNum,
          audQuesNum: marksheet.audQuesNum,
          audAnswered: marksheet.audAnswered,
        );
        markId = int.parse(response.body);
        _audioMarksheets.add(newMarksheet);
        notifyListeners();
      });
    } catch (error) {
      throw (error);
    }
    return markId;
  }
}
