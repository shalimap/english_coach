import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import '../model/audiotest.dart';

class AudioTests with ChangeNotifier {
  List<AudioTest> _audioTests = [];

  List<AudioTest> get audioTests {
    return [..._audioTests];
  }

  Future<List<AudioTest>> fetchTests(int userId, int audNum) async {
    var parameters = {'userid': userId.toString(), 'audnum': audNum.toString()};
    var uri = Uri.https(
        'www.api.englishcoach.app', '/api/dev/audio/gettest.php', parameters);
    Map<String, String> headers = {"Content-Type": "application/json"};
    try {
      var response = await http.get(
        uri, /* headers: headers */
      );
      if (response.statusCode == 200) {
        List extractedData = json.decode(response.body);
        List<AudioTest> audioTest = [];
        for (var i = 0; i < extractedData.length; i++) {
          var tests = AudioTest.fromJson(extractedData[i]);
          audioTest.add(tests);
        }
        audioTest.sort((a, b) => a.audTestId!.compareTo(b.audTestId!));
        _audioTests = audioTest;
        notifyListeners();
      }
    } catch (error) {
      print('ERROR : ' + error.toString());
      throw (error);
    }
    return _audioTests;
  }

  AudioTest findById(int id) {
    return _audioTests.firstWhere((aud) => aud.audNum == id);
  }

  List<AudioTest> findByModId(int id) {
    return _audioTests.where((aud) => aud.audNum == id).toList();
  }

  Future<int> addTest(AudioTest tests) async {
    var testId;
    var parameters = {
      'audNum': tests.audNum.toString(),
      'audQuesNum': tests.audQuesNum.toString(),
      'userId': tests.userId.toString(),
    };
    var uri = Uri.https('www.api.englishcoach.app',
        '/api/dev/audio/inserttest.php', parameters);
    try {
      await http.post(uri).then((response) {
        final newTest = AudioTest(
          audTestId: int.parse(response.body),
          audNum: tests.audNum,
          audQuesNum: tests.audQuesNum,
          userId: tests.userId,
          score: 0,
          status: 0,
        );
        testId = int.parse(response.body);
        _audioTests.add(newTest);
        notifyListeners();
      });
    } catch (error) {
      throw (error);
    }
    return testId;
  }

  Future<void> updateTest(int audtestId, int score) async {
    var parameters = {
      'audTestId': audtestId.toString(),
      'score': score.toString(),
    };
    var uri = Uri.https('www.api.englishcoach.app',
        '/api/dev/audio/updatetest.php', parameters);
    try {
      await http.post(uri);
    } catch (error) {
      throw (error);
    }
  }

  Future<void> deleteAllTests(int userId, int audNum) async {
    var parameters = {
      'userId': userId.toString(),
      'audNum': audNum.toString(),
    };
    var uri = Uri.https('www.api.englishcoach.app',
        '/api/dev/audio/deletetests.php', parameters);
    _audioTests
        .removeWhere((aud) => aud.audNum == audNum && aud.userId == userId);
    notifyListeners();
    try {
      await http.post(uri);
    } catch (error) {
      throw (error);
    }
  }

  List<AudioTest> passCount(int userId, int audNum) {
    return _audioTests
        .where((test) =>
            test.score! >= 70 && test.userId == userId && test.audNum == audNum)
        .toList();
  }

  Future<void> deleteTest(int testId) async {
    var parameters = {
      'audTestId': testId.toString(),
    };
    var uri = Uri.https('www.api.englishcoach.app',
        '/api/dev/audio/deletetest.php', parameters);
    try {
      await http.post(uri);
    } catch (error) {
      throw (error);
    }
  }

  void removeTest(int testid) {
    _audioTests.removeWhere((test) => test.audTestId == testid);
  }
}
