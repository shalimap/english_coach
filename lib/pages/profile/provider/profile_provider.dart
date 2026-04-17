import 'package:englishcoach/api/api.dart';
import 'package:englishcoach/config/base_provider.dart';
import 'package:englishcoach/pages/profile/models/qualification.dart';
import 'package:englishcoach/pages/profile/models/state-district.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileProvider extends BaseProvider {
  List<States> _states = [
    States(stateId: 1000, stateName: 'abc'),
    States(stateId: 2000, stateName: 'def')
  ];

  List<Districts> _districts = [
    Districts(distId: 1000, stateId: 1000, distName: 'abcxyz1'),
    Districts(distId: 2000, stateId: 1000, distName: 'abcxyz2'),
    Districts(distId: 3000, stateId: 2000, distName: 'defxyz1'),
    Districts(distId: 4000, stateId: 2000, distName: 'defxyz2')
  ];

  List<States> get states => [..._states];

  List<Districts> get districts => [..._districts];
  set districts(List<Districts> val) {
    _districts = val;
    notifyListeners();
  }

  set states(List<States> val) {
    _states = val;
    notifyListeners();
  }

  Future fetchStates() async {
    var uri = Uri.parse(Api.fetchStates);
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        List extractedStates = json.decode(response.body);
        List<States> loadedstates = [];
        for (var i = 0; i < extractedStates.length; i++) {
          var selectedstate = States.fromJson(extractedStates[i]);
          loadedstates.add(selectedstate);
        }
        _states = loadedstates;
        notifyListeners();
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchDistricts() async {
    var uri = Uri.parse(Api.fetchdistricts);
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        List extractedDistricts = json.decode(response.body);
        List<Districts> loadeddistricts = [];
        for (var i = 0; i < extractedDistricts.length; i++) {
          var selecteddistrict = Districts.fromJson(extractedDistricts[i]);
          loadeddistricts.add(selecteddistrict);
        }
        _districts = loadeddistricts;
        notifyListeners();
      }
    } catch (error) {
      throw error;
    }
  }

  List<Qualifications> _qualifications = [];

  List<Qualifications> get qualifications => [..._qualifications];

  set qualifications(List<Qualifications> val) {
    _qualifications = val;
    notifyListeners();
  }

  Future getData() async {
    var uri = Uri.parse(Api.getqualifications);
    try {
      var response =
          await http.get(uri, headers: {"Accept": "application/json"});
      if (response.statusCode == 200) {
        List extractedqual = json.decode(response.body);
        List<Qualifications> loadedqual = [];
        for (var i = 0; i < extractedqual.length; i++) {
          var selectedqual = Qualifications.fromJson(extractedqual[i]);
          loadedqual.add(selectedqual);
        }
        _qualifications = loadedqual;
        notifyListeners();
      }
    } catch (error) {
      throw error;
    }
  }

  Future addProfile(int userid, int imgid, DateTime studytime, int qualid,
      String gender, DateTime dob, int stateid, int distid) async {
    var uri = Uri.parse(Api.insertProfile);
    await http.post(uri, body: {
      "userId": userid.toString(),
      "imgId": imgid.toString(),
      "studyTime": studytime.toIso8601String(),
      "qualId": qualid.toString(),
      "studGender": gender,
      "studDob": dob.toIso8601String(),
      "stateId": stateid.toString(),
      "distId": distid.toString(),
    });
  }

  Future getprofileimg(userid) async {
    var uri = Uri.parse(
        'https://api.englishcoach.app/api/bin/trialtest/getprofile.php');
    final response = await http.post(uri, body: {
      "userId": userid,
    });
    if (response.statusCode == 200) {
      var convertedDatatoJson = json.decode(response.body);

      return convertedDatatoJson;
    }
  }

  Future getusername(userid) async {
    var uri = Uri.parse(
        'https://api.englishcoach.app/api/bin/trialtest/getusername.php');
    final response = await http.post(uri, body: {
      "userId": userid,
    });
    if (response.statusCode == 200) {
      var convertedDatatoJson = json.decode(response.body);
      return convertedDatatoJson;
    }
  }

  Future updateProfile(int userId, int imgid, DateTime studytime) async {
    var parameters = {
      "userId": userId.toString(),
      "imgValue": imgid.toString(),
      "selectedTime": studytime.toIso8601String(),
    };
    var uri = Uri.parse(
        'https://api.englishcoach.app/api/bin/profile/updateprofile.php');
    try {
      final res = await http.post(uri, body: parameters);
      print(res.statusCode);
    } catch (error) {
      print(error);
    }
  }

  Future setstudyTime(int userId, DateTime studytime) async {
    var parameters = {
      "userId": userId.toString(),
      "selectedTime": studytime.toIso8601String(),
    };
    var uri = Uri.parse(
        'https://api.englishcoach.app/api/bin/profile/updateStudytime.php');
    try {
      final res = await http.post(uri, body: parameters);
      print(res.statusCode);
    } catch (error) {
      print(error);
    }
  }
}
