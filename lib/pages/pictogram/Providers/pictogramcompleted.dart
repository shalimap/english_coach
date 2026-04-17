import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Models/pictogrammarksheet.dart';

class PictogramCompleted with ChangeNotifier {
  List<Pictogrammarksheet> _pictcompleted = [];

  List<Pictogrammarksheet> get pictcompleted => [..._pictcompleted];

  Future<int> addPictogram(Pictogrammarksheet marksheet) async {
    var parameters = {
      'userId': marksheet.userId.toString(),
      'modId': marksheet.modId.toString(),
      'picId': marksheet.picId.toString(),
      'Sentence': marksheet.sentence,
    };
    var uri = Uri.parse(
        'https://api.englishcoach.app/api/bin/pictogram/insertpictogram.php');
    var markId;
    try {
      await http.post(uri, body: parameters).then((response) {
        final newMarksheet = Pictogrammarksheet(
          userId: marksheet.userId,
          modId: marksheet.modId,
          picId: marksheet.picId,
          sentence: marksheet.sentence,
        );
        markId = int.parse(response.body);
        _pictcompleted.add(newMarksheet);
        notifyListeners();
      });
    } catch (error) {
      throw error;
    }
    return markId;
  }

  Future getlength(modid, userId) async {
    // var uri = Uri.https('www.api.englishcoach.app',
    //     '/api/bin/pictogram/getlist.php?modId=$modid&&userId=$userId');

    var uri = Uri.parse(
        'https://api.englishcoach.app/api/bin/pictogram/getlist.php?modId=$modid&&userId=$userId');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      var convertedDatatoJson = json.decode(response.body);
      return convertedDatatoJson;
    }
  }
}
