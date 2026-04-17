import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import '../models/unlock.dart';

class ModuleUnlock with ChangeNotifier {
  List<Unlock> _unlock = [];
  var countLength;

  List<Unlock> get unlock {
    return [..._unlock];
  }

  Unlock findById(int id) {
    return _unlock.firstWhere((lock) => lock.modNum == id);
  }

  bool checkLock(int id) {
    var lock = _unlock
        .firstWhere((lock) => lock.modNum == id && lock.mLockOpenNow == 0);
    if (lock != null)
      return true;
    else
      return false;
  }

  Future<List<Unlock>> fetchLocks(int userId) async {
    var parameters = {'userId': userId.toString()};
    var uri = Uri.https(
        'www.api.englishcoach.app', '/api/dev/lock/lock.php', parameters);
    Map<String, String> headers = {"Content-Type": "application/json"};
    try {
      var response = await http.get(
        uri, /* headers: headers */
      );
      if (response.statusCode == 200) {
        List extractedData = json.decode(response.body);
        List<Unlock> unlockedModules = [];
        for (var i = 0; i < extractedData.length; i++) {
          var module = Unlock.fromJson(extractedData[i]);
          //unlockedModules.add(module);
          var exists =
              unlockedModules.indexWhere((e) => e.modNum == module.modNum);

          unlockedModules.add(module);
          if (exists != -1) {
            unlockedModules.removeAt(exists);
          }
        }

        if (unlockedModules.isNotEmpty) {
          unlockedModules.sort(
              (a, b) => a.mLockUnlockedTime!.compareTo(b.mLockUnlockedTime!));
          _unlock = unlockedModules;
          List<Unlock> count = _unlock
              .where((unlocks) =>
                  unlocks.userId == userId && unlocks.mLockOpenNow == 1)
              .toList();
          countLength = count.length;

          notifyListeners();
        }
      }
    } catch (error) {
      // print('ERROR : ' + error.toString());
      // throw (error);
    }
    return _unlock;
  }

  Unlock? lockInform(int user, int mod) {
    for (var item in _unlock) {
      if (item.modNum == mod && item.userId == user) {
        return item;
      }
    }
    return null;
  }

  Unlock? unlockedModule(int id) {
    for (var item in _unlock) {
      if (item.modNum == id && item.mLockOpenNow == 1) {
        return item;
      }
    }
    return null;
  }

  bool partiallyUnlocked(int id) {
    for (var item in _unlock) {
      if (item.modNum == id && item.mLockOpenNow == 0) {
        return true;
      }
    }
    return false;
  }

  List<Unlock> previous(int id) {
    return _unlock.where((module) => module.mLockOpenNow == 1).toList();
  }

  updateLock(int mod) {
    return _unlock.firstWhere((unlock) => unlock.modNum == mod);
  }

  void addLock(Unlock unlock) {
    final newLock = Unlock(
      mLockId: unlock.mLockId,
      userId: unlock.userId,
      modNum: unlock.modNum,
      mLockOpenNow: unlock.mLockOpenNow,
      mLockUnlockedTime: unlock.mLockUnlockedTime,
    );
    _unlock.add(newLock);
    notifyListeners();
  }

  void unlockModule(Unlock unlock) {
    final updateLock = Unlock(
      mLockId: unlock.mLockId,
      userId: unlock.userId,
      modNum: unlock.modNum,
      mLockOpenNow: unlock.mLockOpenNow,
      mLockUnlockedTime: unlock.mLockUnlockedTime,
    );
    _unlock.add(updateLock);
    notifyListeners();
  }

  List<Unlock> count(int user) {
    return _unlock
        .where((unlocks) => unlocks.userId == user && unlocks.mLockOpenNow == 1)
        .toList();
  }

  nextUnlockModule(int id) {
    return _unlock.firstWhere((unlocks) => unlocks.modNum == id);
  }

  Future<void> unLockNextModule(Unlock unlocks) async {
    var parameters = {
      'userId': unlocks.userId.toString(),
      'modNum': unlocks.modNum.toString(),
      'lockOpen': unlocks.mLockOpenNow.toString(),
      'unlockedTime': unlocks.mLockUnlockedTime!.toIso8601String(),
    };
    var uri = Uri.parse('https://api.englishcoach.app/api/dev/lock/unlock.php');
    try {
      await http.post(uri, body: parameters);
    } catch (error) {
      throw (error);
    }
  }

  Future<void> unlockCompletely(int userId, int modId, int unlock) async {
    var parameters = {
      'userId': userId.toString(),
      'modId': modId.toString(),
      'unlock': unlock.toString(),
    };
    var uri = Uri.https(
        'www.api.englishcoach.app', '/api/dev/lock/updatelock.php', parameters);
    try {
      await http.post(uri);
    } catch (error) {
      throw (error);
    }
  }

  bool checkUnlocked(int modId) {
    return _unlock.contains(modId);
  }

  Future<void> updateTimer(int userId, int modNum) async {
    var parameters = {
      'userId': userId.toString(),
      'modNum': modNum.toString(),
    };
    var uri = Uri.parse(
        'https://api.englishcoach.app/api/dev/payment/updatetimer.php');
    try {
      await http.post(uri, body: parameters);
    } catch (error) {
      throw (error);
    }
  }

  Future getunlocks(userid) async {
    var uri = Uri.https(
        'www.api.englishcoach.app', '/api/dev/lock/lock.php?userId=$userid');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      var convertedDatatoJson = json.decode(response.body);
      return convertedDatatoJson;
    }
  }

  Unlock findbymlockopen(int modid) {
    var item;
    var index = _unlock.indexWhere((e) => e.modNum == modid);
    item = _unlock[index];
    return item;
  }

  int length(int userId) {
    return _unlock.length;
  }
}
