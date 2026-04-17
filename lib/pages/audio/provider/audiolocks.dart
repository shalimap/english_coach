import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import '../model/audiolock.dart';

class AudioLocks with ChangeNotifier {
  List<AudioLock> _audiolocks = [];
  var countLength;

  List<AudioLock> get audiolock {
    return [..._audiolocks];
  }

  AudioLock findById(int id) {
    return _audiolocks.firstWhere((lock) => lock.audNum == id);
  }

  bool checkLock(int id) {
    var lock = _audiolocks
        .firstWhere((lock) => lock.audNum == id && lock.audLockOpen == 0);
    if (lock != null)
      return true;
    else
      return false;
  }

  Future<List<AudioLock>> fetchLocks(int userId) async {
    var parameters = {'userId': userId.toString()};
    var uri = Uri.https(
        'www.api.englishcoach.app', '/api/dev/audio/lock.php', parameters);
    Map<String, String> headers = {"Content-Type": "application/json"};
    try {
      var response = await http.get(
        uri, /* headers: headers */
      );
      if (response.statusCode == 200) {
        List extractedData = json.decode(response.body);
        List<AudioLock> unlockedAudios = [];
        for (var i = 0; i < extractedData.length; i++) {
          var audio = AudioLock.fromJson(extractedData[i]);
          var exists =
              unlockedAudios.indexWhere((e) => e.audNum == audio.audNum);

          unlockedAudios.add(audio);
          if (exists != -1) {
            unlockedAudios.removeAt(exists);
          }
        }

        if (unlockedAudios.isNotEmpty) {
          unlockedAudios
              .sort((a, b) => a.audUnlockedTime!.compareTo(b.audUnlockedTime!));
          _audiolocks = unlockedAudios.toSet().toList();
          print('audioLocks ' + _audiolocks.length.toString());
          List<AudioLock> count = _audiolocks
              .where((unlocks) =>
                  unlocks.userId == userId && unlocks.audLockOpen == 1)
              .toList();
          countLength = count.length;
          print('countLength ' + countLength.toString());
          // _audiolocks.forEach((e) {
          //   print('id :' +
          //       ' ' +
          //       e.audLockId.toString() +
          //       ' ' +
          //       'audNum :' +
          //       ' ' +
          //       e.audNum.toString() +
          //       ' ' +
          //       'lockopen :' +
          //       ' ' +
          //       e.audLockOpen.toString() +
          //       ' ' +
          //       'time :' +
          //       ' ' +
          //       e.audUnlockedTime.toIso8601String());
          // });

          notifyListeners();
        }
      }
    } catch (error) {
      // print('ERROR : ' + error.toString());
      // throw (error);
    }
    return _audiolocks;
  }

  AudioLock? lockInform(int user, int aud) {
    for (var item in _audiolocks) {
      if (item.audNum == aud && item.userId == user) {
        return item;
      }
    }
    return null;
  }

  AudioLock? unlockedModule(int id) {
    for (var item in _audiolocks) {
      if (item.audNum == id && item.audLockOpen == 1) {
        return item;
      }
    }
    return null;
  }

  bool partiallyUnlocked(int id) {
    for (var item in _audiolocks) {
      if (item.audNum == id && item.audLockOpen == 0) {
        return true;
      }
    }
    return false;
  }

  List<AudioLock> previous(int id) {
    return _audiolocks.where((aud) => aud.audLockOpen == 1).toList();
  }

  updateLock(int aud) {
    return _audiolocks.firstWhere((unlock) => unlock.audNum == aud);
  }

  void addLock(AudioLock unlock) {
    final newLock = AudioLock(
      audLockId: unlock.audLockId,
      userId: unlock.userId,
      audNum: unlock.audNum,
      audLockOpen: unlock.audLockOpen,
      audUnlockedTime: unlock.audUnlockedTime,
    );
    _audiolocks.add(newLock);
    notifyListeners();
  }

  void unlockAudio(AudioLock unlock) {
    final updateLock = AudioLock(
      audLockId: unlock.audLockId,
      userId: unlock.userId,
      audNum: unlock.audNum,
      audLockOpen: unlock.audLockOpen,
      audUnlockedTime: unlock.audUnlockedTime,
    );
    _audiolocks.add(updateLock);
    notifyListeners();
  }

  List<AudioLock> count(int user) {
    return _audiolocks
        .where((unlocks) => unlocks.userId == user && unlocks.audLockOpen == 1)
        .toList();
  }

  nextUnlockAudio(int id) {
    return _audiolocks.firstWhere((unlocks) => unlocks.audNum == id);
  }

  Future<void> unLockNextAudio(AudioLock unlocks) async {
    var parameters = {
      'userId': unlocks.userId.toString(),
      'audNum': unlocks.audNum.toString(),
      'lockOpen': unlocks.audLockOpen.toString(),
      'unlockedTime': unlocks.audUnlockedTime!.toIso8601String(),
    };
    var uri = Uri.https(
        'www.api.englishcoach.app', '/api/dev/audio/unlock.php', parameters);
    try {
      await http.post(uri);
    } catch (error) {
      throw (error);
    }
  }

  Future<void> unlockCompletely(int userId, int audNum) async {
    var parameters = {
      'userId': userId.toString(),
      'audNum': audNum.toString(),
    };
    var uri = Uri.https('www.api.englishcoach.app',
        '/api/dev/audio/updatelock.php', parameters);
    try {
      await http.post(uri);
    } catch (error) {
      throw (error);
    }
  }

  bool checkUnlocked(int audNum) {
    return _audiolocks.contains(audNum);
  }

  Future<void> updateTimer(int userId, int audNum) async {
    var parameters = {
      'userId': userId.toString(),
      'audNum': audNum.toString(),
    };
    var uri = Uri.https('www.api.englishcoach.app',
        '/api/dev/audio/updatelock.php', parameters);
    try {
      await http.post(uri);
    } catch (error) {
      throw (error);
    }
  }

  int length(int userId) {
    return _audiolocks.length;
  }
}
