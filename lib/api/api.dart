class Api {
  static String baseUrl = 'https://api.englishcoach.app/api/';
  static String signupUrl = baseUrl + 'bin/Signup/insertusers.php';
  static String ismobileExists =
      baseUrl + 'bin/Signup/mobilealreadyexists.php/?userMob=';
  static String editpermission = baseUrl + 'bin/Signup/permissioninsert.php';
  static String loginUrl = baseUrl + 'bin/login/logincheck.php';
  static String fetchStates = baseUrl + 'bin/profile/getstates.php';
  static String fetchdistricts = baseUrl + 'bin/profile/getdistricts.php';
  static String getqualifications =
      baseUrl + 'bin/profile/getqualifications.php';
  static String insertProfile = baseUrl + 'bin/profile/insertprofile.php';
  static String insertmcqmarksheet =
      baseUrl + 'exp/preliminary_1/insertmcqmarksheet.php';
  static String getaudiocontents =
      baseUrl + 'dev/audiochat/getaudiocontents.php';
  static String getaudiochatusers =
      baseUrl + 'dev/audiochat/getaudiochatusers.php';
  static String getaudiochatrooms =
      baseUrl + 'dev/audiochat/getaudiochatroom.php';
  static String getaudiocontentbyid =
      baseUrl + 'dev/audiochat/getaudiocontentbyid.php';
  static String searchforchatroom =
      baseUrl + 'dev/audiochat/searchforchatroom.php';
  static String insertchatroom = baseUrl + 'dev/audiochat/insertchatroom.php';
  static String updatetaudiostatus =
      baseUrl + 'dev/audiochat/updateaudiostatus.php';
  static String updatechatexit = baseUrl + 'dev/audiochat/updateaudioexit.php';
  static String updateaudiourl = baseUrl + 'dev/audiochat/updateaudiourl.php';
  static String getgroupchatroomdetails =
      baseUrl + 'dev/audiochat/getaudiogrouproomdetails.php';
}
