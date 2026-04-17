import 'package:facebook_app_events/facebook_app_events.dart';

class FBAppevents {
  final facebookAppevents = FacebookAppEvents();

  registrationEvent(String phonenum) {
    facebookAppevents.logEvent(name: "Registration Completed", parameters: {
      "value": phonenum,
      "subname": "User completed initial registration"
    });
  }

  verificationEvent(String phonenum) {
    facebookAppevents.logEvent(
      name: "Verified Users",
      parameters: {"value": phonenum, "subname": "Registration completed"},
    );
  }

  loggedUsers(String userId) {
    facebookAppevents.logEvent(
        name: "Logged Users",
        parameters: {"value": userId, "subname": "Trial loggedin users"});
  }
}
