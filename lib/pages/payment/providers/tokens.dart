import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import '../models/token.dart';

class Tokens with ChangeNotifier {
  List<Token> _tokens = [];

  List<Token> get tokens {
    return [..._tokens];
  }

  Token? findByUserId(int user) {
    if (_tokens.isNotEmpty) {
      return _tokens.firstWhere((token) => token.userId == user);
    }
    return null;
  }

  Future<List<Token>> fetchTokens(int userId) async {
    var parameters = {'userId': userId.toString()};
    var uri = Uri.https(
        'www.api.englishcoach.app', '/api/dev/payment/token.php', parameters);
    Map<String, String> headers = {"Content-Type": "application/json"};
    try {
      var response = await http.get(
        uri, /*  headers: headers */
      );
      if (response.statusCode == 200) {
        List extractedData = json.decode(response.body);
        List<Token> loadedTokens = [];
        for (var i = 0; i < extractedData.length; i++) {
          var token = Token.fromJson(extractedData[i]);
          loadedTokens.add(token);
        }
        loadedTokens
            .sort((a, b) => a.generatedTime!.compareTo(b.generatedTime!));
        _tokens = loadedTokens;
        notifyListeners();
      }
    } catch (error) {
      print('ERROR : ' + error.toString());
      throw (error);
    }
    return _tokens;
  }

  Future<int> insertToken(Token token) async {
    var parameters = {
      'userId': token.userId.toString(),
      'tokenNum': token.tokenNum.toString(),
      'time': token.generatedTime!.toIso8601String(),
      'valid': token.validTill!.toIso8601String(),
    };
    var uri = Uri.parse(
        'https://api.englishcoach.app/api/dev/payment/inserttoken.php');
    var tokenId;
    try {
      await http.post(uri, body: parameters).then((response) {
        final newToken = Token(
          tokenId: int.parse(response.body),
          userId: token.userId,
          tokenNum: token.tokenNum,
          generatedTime: token.generatedTime,
          validTill: token.validTill,
        );
        tokenId = int.parse(response.body);
        _tokens.add(newToken);
        notifyListeners();
      });
    } catch (error) {
      // throw (error);
      //print(error);
    }
    return tokenId;
  }

  Future<void> updateToken(int userId) async {
    var parameters = {
      'userId': userId.toString(),
    };
    var uri = Uri.parse(
      'https://api.englishcoach.app/api/dev/payment/updatetoken.php',
    );
    await http.post(uri, body: parameters);
  }

  Future<String> getMobile(int userid) async {
    var uri = Uri.parse(
        'https://api.englishcoach.app/api/dev/payment/mobile.php?userId=$userid');
    var mobileNum;
    try {
      final response = await http.get(uri);
      final extractedData = json.decode(response.body);
      var mobile = extractedData[0]['user_mob'];
      mobileNum = mobile;
      return mobile;
    } catch (error) {
      print(error);
    }
    return mobileNum;
  }
}
