import 'dart:convert';

import 'AppException.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Commons {
  static const baseURL = "http://www.api.englishcoach.app/api/";

  static const logoBlueColor = const Color(0xFF205072);
  static const logoGreen4xColor = const Color(0xFF329D9c);
  static const logoGreen3xColor = const Color(0xFF56c590);
  static const logoGreen2xColor = const Color(0xFF7be495);
  static const logoGreen1xColor = const Color(0xFFcff4d2);

  static void showError(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text(message),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(15)),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    disabledForegroundColor: Colors.black.withOpacity(0.38),
                  ),
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  static dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = jsonDecode(response.body.toString());
        print(responseJson);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
