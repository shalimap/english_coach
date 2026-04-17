import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String errorMsg = '';
  String verificationCode = '';
  int? statusCode;

//phone verification codesent(In case value not added to verificationCode try with sharedpreferences)
  Future phoneVerification(String phoneNumber) async {
    final prefs = await SharedPreferences.getInstance();

    await _auth
        .verifyPhoneNumber(
            phoneNumber: phoneNumber,
            verificationCompleted: (phoneAuthCredential) {
              //_auth.currentUser!.linkWithCredential(phoneAuthCredential);
              print('success');
            },
            verificationFailed: (FirebaseAuthException e) {
              print('verferor :' + e.toString());
            },
            codeSent: (String verificationId, [forceResendingToken]) {
              verificationCode = verificationId;
              prefs.setString('code', verificationId);
            },
            timeout: Duration(seconds: 60),
            codeAutoRetrievalTimeout: (String verificationId) {
              verificationCode = verificationId;
              prefs.clear();
              prefs.setString('code', verificationId);
            })
        .onError((e, stackTrace) => print('phneror :' + e.toString()));
  }

//phone verification otp verifiedcode (In case error try with sharedpreferences)
  Future signinwithcredential(String otp) async {
    final prefs = await SharedPreferences.getInstance();
    String? code = prefs.getString('code').toString();

    try {
      await _auth
          .signInWithCredential(
              PhoneAuthProvider.credential(verificationId: code, smsCode: otp))
          .then((user) {
        //DatabaseProvider(userid: user.user!.uid).updateUserDetails();
        prefs.remove('code');
        print('verification cache removed successfully');
        statusCode = 200;
      });
    } on FirebaseException catch (e) {
      statusCode = 400;
      errorMsg = e.message!;
      print(errorMsg);
    } catch (e) {
      print(e);
    }
  }

  phoneVerificationWeb(String phoneNumber) async {
    try {
      ConfirmationResult confirmationResult =
          await _auth.signInWithPhoneNumber(phoneNumber);

      return confirmationResult;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future authenticateWeb(
      ConfirmationResult confirmationResult, String otp) async {
    try {
      await confirmationResult.confirm(otp).then((user) {
        print('verification cache removed successfully');
        statusCode = 200;
      });
    } on FirebaseException catch (e) {
      statusCode = 400;
      errorMsg = e.message!;
      print(errorMsg);
    } catch (e) {
      print(e);
    }

    //UserCredential userCredential = await confirmationResult.confirm('123456');
  }
}
