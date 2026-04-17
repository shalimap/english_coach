import 'dart:convert';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:englishcoach/common_widgets/profiletextfieldcontainer.dart';
import 'package:englishcoach/common_widgets/toast_widget.dart';
import 'package:englishcoach/config/color.dart';
import 'package:englishcoach/config/responsive.dart';
import 'package:englishcoach/pages/login/screen/login.dart';
import 'package:englishcoach/pages/payment/models/online_payment.dart';
import 'package:englishcoach/pages/payment/models/token.dart';
import 'package:englishcoach/pages/payment/providers/banks.dart';
import 'package:englishcoach/pages/payment/providers/coupon.dart';
import 'package:englishcoach/pages/payment/providers/tokens.dart';
import 'package:englishcoach/pages/payment/utils/dialogresponse.dart';
import 'package:englishcoach/pages/profile/screen/update_studytime.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oktoast/oktoast.dart';
import 'package:otp/otp.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/online_payments.dart';
import 'package:base32/base32.dart';
import 'package:http/http.dart' as http;

class PaymentPage extends StatefulWidget {
  static const routename = '/paymentpage';

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  File? _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    final File file = File(pickedFile!.path);

    setState(() {
      _image = File(file.path);
    });
  }

  var _isUploading = false;
  var _submitted = false;

  var phpEndPoint = Uri.https(
      'www.api.englishcoach.app', 'chellan/chellan-api-dont-delete.php');

  void _upload() {
    if (_image == null) return;
    String base64Image = base64Encode(_image!.readAsBytesSync());
    String fileName = 'Token No : ' +
        currentUserToken.toString() +
        ' | ' +
        offlineCouponCode.toString() +
        ' | ' +
        _image!.path.split("/").last;

    http.post(phpEndPoint, body: {
      "image": base64Image,
      "name": fileName,
    }).then((res) {
      setState(() {
        _isUploading = false;
      });
      if (res.statusCode == 200) {
        Size size = MediaQuery.of(context).size;
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
                  title: Center(
                    child: Text('Success'),
                  ),
                  content: Container(
                    height: 150,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'കോഴ്‌സ് 24 മണിക്കൂറിനു ശേഷം അൺലോക്കു ചെയ്യും.',
                          style: TextStyle(fontSize: size.width * .045),
                        ),
                        Text(
                          'Upload Successful',
                          style: TextStyle(
                              fontSize: size.width * .045,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _submitted = true;
                        });
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Okay',
                        style: TextStyle(color: Color(0xFF56c590)),
                      ),
                    ),
                  ],
                ));
      } else {
        showToastWidget(
            ToastWidget(
              title: 'Failed',
              description: '',
            ),
            duration: Duration(seconds: 3));
      }

      print(res.statusCode);
    }).catchError((err) {
      print(err);
    });
  }

  List bankList = [];
  String? _bank;
  _bankDropdown() {
    final bankData = Provider.of<Banks>(context, listen: false);
    setState(() {
      bankList = bankData.banks;
    });
  }

  int calculateTotalAmount(String coupon) {
    var reduction =
        Provider.of<Coupons>(context, listen: false).calculateReduction(coupon);
    totalAmount = 499 - reduction;
    return totalAmount!;
  }

  int? totalAmount;
  Razorpay? _razorpay;

  void initState() {
    _razorpay = Razorpay();
    _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    _bankDropdown();
    super.initState();
  }

  void dispose() {
    super.dispose();
    _razorpay!.clear();
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_live_T8dRVJmi5jbSm3',
      'amount': totalAmount! * 100,
      'name': 'English Coach',
      'description': 'Salmed E Learning OPC Pvt Ltd',
      'prefill': {'Registered Phone No': '', 'Email': ''},
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      _razorpay!.open(options);
    } catch (e) {
      print("Encountered error:" + e.toString());
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    final userid = ModalRoute.of(context)!.settings.arguments;

    var payment = OnlinePayment(
      userId: int.parse(userid.toString()),
      razorpayId: response.paymentId,
      status: 1,
      time: DateTime.now(),
      code: couponCode.toString(),
    );
    Provider.of<OnlinePayments>(context, listen: false)
        .addOnlinePayment(payment)
        .then((_) => Navigator.of(context).pushNamedAndRemoveUntil(
            SelectStudyTime.routeName, (route) => false,
            arguments: userid));

    //  Navigator.of(context).pushNamedAndRemoveUntil(
    //     MenuDashboardPage.routeName, (route) => false,
    //     arguments: userid));
    Provider.of<Coupons>(context, listen: false)
        .updateCouponCount(couponId, couponCount);
    _showDialogRes();
    Provider.of<Coupons>(context, listen: false)
        .updateCouponCount(couponId, couponCount);
    facebookAppevents.logPurchase(
        amount: totalAmount!.toDouble(),
        currency: "INR",
        parameters: {
          "id": userid,
        });
  }

  // void couponSuccess() {
  //   Provider.of<Coupons>(context, listen: false)
  //       .updateCouponCount(couponId, couponCount);
  // }

  void _handlePaymentError(PaymentFailureResponse response) {
    final userid = ModalRoute.of(context)!.settings.arguments;

    var payment = OnlinePayment(
      userId: int.parse(userid.toString()),
      razorpayId: response.message,
      status: 0,
      time: DateTime.now(),
      code: couponCode.toString(),
    );
    Provider.of<OnlinePayments>(context, listen: false)
        .addOnlinePayment(payment);
    _showDialogErr();
    facebookAppevents.logEvent(name: "Purchase Cancelled", parameters: {
      "id": userid,
    });
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    final userid = ModalRoute.of(context)!.settings.arguments;

    var payment = OnlinePayment(
      userId: int.parse(userid.toString()),
      razorpayId: response.walletName,
      status: 1,
      time: DateTime.now(),
      code: couponCode.toString(),
    );
    Provider.of<OnlinePayments>(context, listen: false)
        .addOnlinePayment(payment)
        .then((_) => Navigator.of(context).pushNamedAndRemoveUntil(
            SelectStudyTime.routeName, (route) => false,
            arguments: userid));

    //  Navigator.of(context).pushNamedAndRemoveUntil(
    //     MenuDashboardPage.routeName, (route) => false,
    //     arguments: userid)

    _showDialogRes();
    Provider.of<Coupons>(context, listen: false)
        .updateCouponCount(couponId, couponCount);
    facebookAppevents.logPurchase(
        amount: totalAmount!.toDouble(),
        currency: "INR",
        parameters: {
          "id": userid,
        });
  }

  void _showDialogRes() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return DialogResponses(
          color: Colors.green[300]!,
          icon: Icons.check_circle,
          message: "Transaction\nSuccessfull",
        );
      },
    );
  }

  void _showDialogErr() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogResponses(
          color: Colors.red[300]!,
          icon: Icons.cancel,
          message: "Transaction\nFailed",
        );
      },
    );
  }

  void _showDialogs(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                Container(
                  height: 250,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Confirmation',
                        style: GoogleFonts.solway(
                          textStyle: TextStyle(fontWeight: FontWeight.bold),
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Are you sure you want to logout ?',
                        style: GoogleFonts.solway(
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                              onPressed: () async {
                                final prefs =
                                    await SharedPreferences.getInstance();
                                prefs.clear();
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    LoginPage.routename, (route) => false);
                              },
                              child: Text(
                                'Ok',
                                style: GoogleFonts.solway(
                                  fontSize: 14,
                                  color: accentcolor,
                                ),
                              )),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Cancel',
                                style: GoogleFonts.solway(
                                    fontSize: 14, color: accentcolor),
                              )),
                        ],
                      )
                    ],
                  ),
                ),
                Positioned(
                    top: -50,
                    child: CircleAvatar(
                      backgroundColor: Color(0xFF205072),
                      radius: 50,
                      child: Image.asset('assets/icons/Icon.png'),
                    ))
              ],
            ),
          );
        });
  }

  void _insertToken() {
    final userid = ModalRoute.of(context)!.settings.arguments;
    var _tokenData = Token(
      userId: int.parse(userid.toString()),
      tokenNum: int.parse(token),
      generatedTime: DateTime.now(),
      validTill: DateTime.now().add(
        Duration(days: 7),
      ),
    );
    Provider.of<Tokens>(context, listen: false).insertToken(_tokenData);
  }

  void _updateToken(int userId) {
    Provider.of<Tokens>(context, listen: false).updateToken(userId);
    setState(() {
      currentUserToken = null;
    });
  }

  var _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<Banks>(context, listen: false).fetchBanks();
      Provider.of<Coupons>(context, listen: false).fetchCoupons();
      final userid = ModalRoute.of(context)!.settings.arguments;
      Provider.of<Tokens>(context, listen: false)
          .getMobile(int.parse(userid.toString()))
          .then((value) => mobile = value)
          .then((value) {
        Provider.of<Tokens>(context, listen: false)
            .fetchTokens(int.parse(userid.toString()))
            .then((_) {
          final userTokenData = Provider.of<Tokens>(context, listen: false)
              .findByUserId(int.parse(userid.toString()));
          currentUserToken = userTokenData?.tokenNum ?? null;
        }).then((value) {
          final userTokenData = Provider.of<Tokens>(context, listen: false)
              .findByUserId(int.parse(userid.toString()));
          var diff = DateTime.now().difference(userTokenData?.validTill ??
              DateTime.now().add(Duration(days: 90)));
          // print('Difference : ' + diff.toString());
          diff >= Duration(seconds: 1)
              ? _updateToken(int.parse(userid.toString()))
              : print('');
        });
      });
    }
    setState(() {
      _isInit = false;
    });
    super.didChangeDependencies();
  }

  final facebookAppevents = FacebookAppEvents();
  var mobile;
  var currentUserToken;
  var couponId;
  var couponCode;
  var couponCount;
  var offlineCouponCode;
  Color activecolor = Color(0xFF205072);
  Color inactivecolor = Colors.grey;
  var active = 0;
  var accountno;
  var branch;
  var ifsc;
  var token;
  var value = false;
  var applied = 0;

  void _tokenGenerator() {
    setState(() {
      _submitted = false;
      var encoded = base32.encodeHexString(mobile);
      var code = OTP.generateTOTPCodeString(
          encoded, DateTime.now().millisecondsSinceEpoch,
          length: 6);
      print(code);
      token = code;
    });
    Size size = MediaQuery.of(context).size;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
              title: Center(
                child: Text(
                  'അറിയിപ്പ്',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              content: Container(
                height: size.height * .5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'ഇംഗ്ളീഷ് കോച്ചിന്റെ അക്കൗണ്ടിൽ പണമടക്കുമ്പോൾ ടോക്കൺ നമ്പർ കൂടി പേ ഇൻ സ്ലിപ്പ് / ചെല്ലാനിൽ രേഖപ്പെടുത്തുക. ബാങ്കിൽ നിന്നും തിരികെ ലഭിക്കുന്ന പേ ഇൻ സ്ലിപ് / ചെല്ലാന്റെ ഭാഗം ഫോട്ടോ എടുത്ത് അപ്‌ലോഡ് ചെയ്യുക.  നിങ്ങളുടെ മൊബൈൽ നമ്പറിനൊപ്പം ടോക്കൺ നമ്പർ മറക്കാതെ രേഖപ്പെടുത്തണം എന്ന് ബാങ്ക് ഉദ്യോസ്ഥനോട് ആവശ്യപ്പെടുക.',
                      style: TextStyle(fontSize: size.width * .040),
                      textAlign: TextAlign.justify,
                    ),
                    Text(
                      'ടോക്കൺ നമ്പർ : ' + token.toString(),
                      style: TextStyle(
                          fontSize: size.width * .045,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _submitted = true;
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'ശരി',
                    style: TextStyle(color: Color(0xFF56c590)),
                  ),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    final userid = ModalRoute.of(context)!.settings.arguments;
    final bankData = Provider.of<Banks>(context, listen: false);
    final curScaleFactor = MediaQuery.of(context).textScaleFactor;
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
          appBar: AppBar(
            title: Center(
              child: Text(
                'Make Your Payment',
                style: GoogleFonts.solway(
                    fontWeight: FontWeight.bold,
                    fontSize: Responsive.isDesktop(context) ||
                            Responsive.isTablet(context)
                        ? 14
                        : size.width * .045),
              ),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.chevron_left,
                size: 40,
              ),
              onPressed: () =>
                  _isUploading ? null : Navigator.of(context).pop(),
            ),
            elevation: 0.0,
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.power_settings_new),
                  onPressed: () {
                    _showDialogs(context);
                  })
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding:
                  Responsive.isDesktop(context) || Responsive.isTablet(context)
                      ? EdgeInsets.symmetric(horizontal: size.width * 0.1)
                      : const EdgeInsets.all(0.0),
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      Row(
                        children: <Widget>[
                          // GestureDetector(
                          //   onTap: () {
                          //     setState(() {
                          //       active = 0;
                          //     });
                          //   },
                          //   child: Container(
                          //     width: Responsive.isDesktop(context) ||
                          //             Responsive.isTablet(context)
                          //         ? size.width * 0.30
                          //         : size.width * 0.45,
                          //     margin: EdgeInsets.only(left: 15, top: 20),
                          //     decoration: BoxDecoration(
                          //         borderRadius: BorderRadius.circular(10),
                          //         color: active == 0
                          //             ? activecolor
                          //             : inactivecolor),
                          //     child: Padding(
                          //       padding: EdgeInsets.all(15),
                          //       child: Center(
                          //         child: Text(
                          //           'Online Payment',
                          //           style: TextStyle(
                          //               fontSize:
                          //                   Responsive.isDesktop(context) ||
                          //                           Responsive.isTablet(context)
                          //                       ? 15
                          //                       : size.width * .04,
                          //               fontWeight: FontWeight.bold,
                          //               color: Colors.white),
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          // GestureDetector(
                          //   onTap: () {
                          //     setState(() {
                          //       active = 1;
                          //     });
                          //   },
                          //   child: Container(
                          //     width: Responsive.isDesktop(context) ||
                          //             Responsive.isTablet(context)
                          //         ? size.width * 0.30
                          //         : size.width * 0.45,
                          //     margin: EdgeInsets.only(left: 15, top: 20),
                          //     decoration: BoxDecoration(
                          //         borderRadius: BorderRadius.circular(10),
                          //         color: active == 1
                          //             ? activecolor
                          //             : inactivecolor),
                          //     child: Row(
                          //       mainAxisAlignment:
                          //           MainAxisAlignment.spaceAround,
                          //       children: [
                          //         Padding(
                          //           padding: EdgeInsets.all(15),
                          //           child: Center(
                          //             child: Text(
                          //               'Offline Payment',
                          //               style: TextStyle(
                          //                   fontSize: Responsive.isDesktop(
                          //                               context) ||
                          //                           Responsive.isTablet(context)
                          //                       ? 15
                          //                       : size.width * .04,
                          //                   fontWeight: FontWeight.bold,
                          //                   color: Colors.white),
                          //             ),
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.08,
                      ),
                      active == 0
                          ? Column(
                              children: <Widget>[
                                _submitted
                                    ? Container()
                                    : Row(
                                        children: [
                                          Container(
                                            width: Responsive.isDesktop(
                                                        context) ||
                                                    Responsive.isTablet(context)
                                                ? size.width * .45
                                                : size.width * .55,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: TextFormField(
                                                inputFormatters: [
                                                  LengthLimitingTextInputFormatter(
                                                      11)
                                                ],
                                                decoration: InputDecoration(
                                                  labelText: "Promo Code",
                                                  labelStyle: TextStyle(
                                                      color: Color(0xFF205072)),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0),
                                                    borderSide: BorderSide(
                                                      color: Color(0xFF205072),
                                                      width: 2,
                                                    ),
                                                  ),
                                                ),
                                                onChanged: (value) {
                                                  setState(() {
                                                    couponCode = value;
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                            width: Responsive.isDesktop(
                                                        context) ||
                                                    Responsive.isTablet(context)
                                                ? size.width * .2
                                                : size.width * .4,
                                            child: GestureDetector(
                                              onTap: () {
                                                var _valid = Provider.of<
                                                            Coupons>(context,
                                                        listen: false)
                                                    .isValidCoupon(couponCode);
                                                if (_valid) {
                                                  var _notExpired = Provider.of<
                                                              Coupons>(context,
                                                          listen: false)
                                                      .isExpired(couponCode);
                                                  if (_notExpired) {
                                                    var _couponCount =
                                                        Provider.of<Coupons>(
                                                                context,
                                                                listen: false)
                                                            .couponCount(
                                                                couponCode);
                                                    couponCount =
                                                        _couponCount[0]
                                                            .couponCount;
                                                    couponId = _couponCount[0]
                                                        .couponId;

                                                    print('count - ' +
                                                        couponCount.toString());
                                                    setState(() {
                                                      applied = 1;
                                                    });
                                                    print('valid-coupon');
                                                    // couponSuccess();
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .hideCurrentSnackBar();
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          'Coupon Expired',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: GoogleFonts
                                                              .solway(
                                                            textStyle:
                                                                TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors.red,
                                                            ),
                                                          ),
                                                        ),
                                                        duration: Duration(
                                                          seconds: 2,
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .hideCurrentSnackBar();
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'Invalid Coupon',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style:
                                                            GoogleFonts.solway(
                                                          textStyle: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                      ),
                                                      duration: Duration(
                                                        seconds: 2,
                                                      ),
                                                    ),
                                                  );
                                                }
                                              },
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    left: 0, top: 0),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: applied == 1
                                                        ? inactivecolor
                                                        : activecolor),
                                                child: Padding(
                                                  padding: EdgeInsets.all(15),
                                                  child: Center(
                                                    child: Text(
                                                      applied == 1
                                                          ? 'Coupon Applied'
                                                          : 'Apply Coupon',
                                                      style: TextStyle(
                                                          fontSize: Responsive
                                                                      .isDesktop(
                                                                          context) ||
                                                                  Responsive
                                                                      .isTablet(
                                                                          context)
                                                              ? 14
                                                              : size.width *
                                                                  .04,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                SizedBox(
                                  height: size.height * 0.035,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: ButtonTheme(
                                    height: 50,
                                    minWidth: double.infinity,
                                    buttonColor: Color(0xFF56c590),
                                    child: ElevatedButton(
                                      onPressed: !_submitted
                                          ? () {
                                              if (couponCode == null) {
                                                totalAmount = 499;
                                                openCheckout();
                                                facebookAppevents.logEvent(
                                                    name: "Purchase Initiated",
                                                    parameters: {
                                                      "id": userid,
                                                    });
                                              } else {
                                                var amt = calculateTotalAmount(
                                                    couponCode);
                                                print('Amount - ' +
                                                    amt.toString());
                                                totalAmount = amt;
                                                openCheckout();
                                                facebookAppevents.logEvent(
                                                    name: "Purchase Initiated",
                                                    parameters: {
                                                      "id": userid,
                                                    });
                                              }
                                            }
                                          : null,
                                      child: Text(
                                        'Online Payment Options',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        elevation: 5,
                                        backgroundColor: accentcolor,
                                        padding: EdgeInsets.only(
                                            left: 50,
                                            right: 50,
                                            bottom: 20,
                                            top: 20),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: size.height * 0.035,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: DottedBorder(
                                    borderType: BorderType.RRect,
                                    radius: Radius.circular(12),
                                    color: Colors.grey,
                                    child: Card(
                                      margin: EdgeInsets.all(20),
                                      elevation: 0.0,
                                      child: Column(
                                        children: [
                                          Text(
                                            'ശ്രദ്ധിക്കുക',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                          SizedBox(
                                            height: size.height * 0.02,
                                          ),
                                          Text(
                                            'ഗൂഗിൾ പേ, പേ ടി എം, ഫോൺ പേ തുടങ്ങിയ എല്ലാ UPI സേവനങ്ങളൊ, ഇന്റർനെറ്റ് ബാങ്കിങ്, മൊബൈൽ ബാങ്കിങ്, ക്രെഡിറ്റ് കാർഡ്, ഡെബിറ്റ് കാർഡ് എന്നിവയോ ഉപയോഗിച്ച് ഫീസ് അടക്കുവാൻ ONLINE പേയ്‌മെന്റ് തിരഞ്ഞെടുക്കുക.',
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.justify,
                                          ),
                                          SizedBox(
                                            height: size.height * 0.02,
                                          ),
                                          // Text(
                                          //   'താങ്കളുടെ സമീപത്തുള്ള കാനറ ബാങ്ക് വഴി ഫീസ് അടക്കുവാൻ OFFLINE പേയ്‌മെന്റ് തിരഞ്ഞെടുക്കുക',
                                          //   style: TextStyle(
                                          //       fontSize: 13,
                                          //       fontWeight: FontWeight.bold),
                                          //   textAlign: TextAlign.justify,
                                          // ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )
                          : SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                  _image != null
                                      ? Container()
                                      : Text(
                                          'ബാങ്ക് ശാഖ മുഖേന പണമടക്കാം',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                  _image != null
                                      ? Container()
                                      : SizedBox(
                                          height: 20,
                                        ),
                                  _image != null
                                      ? Container()
                                      : ProfileFieldContainer(
                                          child: new DropdownButton(
                                            isExpanded: true,
                                            items: bankData.banks.map((item) {
                                              return new DropdownMenuItem(
                                                child: new Text(item.bankName!),
                                                value: item.bankId.toString(),
                                              );
                                            }).toList(),
                                            onChanged: (String? newVal) {
                                              setState(() {
                                                _bank = newVal;
                                                final bankDatas = bankData.banks
                                                    .firstWhere((x) =>
                                                        x.bankId.toString() ==
                                                        _bank.toString());
                                                accountno = bankDatas.bankAccnum
                                                    .toString();
                                                branch = bankDatas.bankBranch
                                                    .toString();
                                                ifsc = bankDatas.bankIfsc
                                                    .toString();
                                              });
                                            },
                                            value: _bank,
                                            hint: Text(
                                                'ദയവായി ഒരു ബാങ്ക് തിരഞ്ഞെടുക്കുക',
                                                style: TextStyle(
                                                    fontSize:
                                                        15 * curScaleFactor)),
                                          ),
                                        ),
                                  _image != null
                                      ? Container()
                                      : SizedBox(
                                          height: size.height * 0.03,
                                        ),
                                  _image != null
                                      ? Container()
                                      : _image != null
                                          ? Container()
                                          : Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 40, right: 10),
                                              child: Row(
                                                children: <Widget>[
                                                  Text(
                                                    'Company Name :',
                                                    style: TextStyle(
                                                        fontSize:
                                                            15 * curScaleFactor,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    width: size.width * 0.02,
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                        'Salmed E Learning OPC Pvt Ltd'),
                                                  ),
                                                ],
                                              ),
                                            ),
                                  _image != null
                                      ? Container()
                                      : SizedBox(
                                          height: size.height * 0.02,
                                        ),
                                  _image != null
                                      ? Container()
                                      : Padding(
                                          padding:
                                              const EdgeInsets.only(left: 40),
                                          child: Row(
                                            children: <Widget>[
                                              Text(
                                                'Account Number :',
                                                style: TextStyle(
                                                    fontSize:
                                                        15 * curScaleFactor,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                width: size.width * 0.02,
                                              ),
                                              Text(accountno == null
                                                  ? 'Select Bank'
                                                  : '$accountno'),
                                            ],
                                          ),
                                        ),
                                  _image != null
                                      ? Container()
                                      : SizedBox(
                                          height: size.height * 0.02,
                                        ),
                                  _image != null
                                      ? Container()
                                      : Padding(
                                          padding:
                                              const EdgeInsets.only(left: 40),
                                          child: Row(
                                            children: <Widget>[
                                              Text(
                                                'Branch :',
                                                style: TextStyle(
                                                    fontSize:
                                                        15 * curScaleFactor,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                width: size.width * 0.02,
                                              ),
                                              Text(branch == null
                                                  ? 'Select Bank'
                                                  : '$branch'),
                                            ],
                                          ),
                                        ),
                                  _image != null
                                      ? Container()
                                      : SizedBox(
                                          height: size.height * 0.02,
                                        ),
                                  _image != null
                                      ? Container()
                                      : Padding(
                                          padding:
                                              const EdgeInsets.only(left: 40),
                                          child: Row(
                                            children: <Widget>[
                                              Text(
                                                'IFSC code :',
                                                style: TextStyle(
                                                    fontSize:
                                                        15 * curScaleFactor,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                width: size.width * 0.02,
                                              ),
                                              Text(ifsc == null
                                                  ? 'Select Bank'
                                                  : '$ifsc'),
                                            ],
                                          ),
                                        ),
                                  SizedBox(
                                    height: size.height * 0.02,
                                  ),
                                  value
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(left: 40),
                                          child: Row(
                                            children: <Widget>[
                                              Text(
                                                'Token :',
                                                style: TextStyle(
                                                    fontSize:
                                                        15 * curScaleFactor,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                width: size.width * 0.02,
                                              ),
                                              currentUserToken != null
                                                  ? Text(currentUserToken
                                                      .toString())
                                                  : Text('$token'),
                                            ],
                                          ),
                                        )
                                      : _image != null
                                          ? _submitted == true
                                              ? Container()
                                              : Padding(
                                                  padding: const EdgeInsets.all(
                                                      30.0),
                                                  child: TextFormField(
                                                    inputFormatters: [
                                                      LengthLimitingTextInputFormatter(
                                                          11)
                                                    ],
                                                    decoration: InputDecoration(
                                                      labelText: "Promo Code",
                                                      labelStyle: TextStyle(
                                                          color: Color(
                                                              0xFF205072)),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15.0),
                                                        borderSide: BorderSide(
                                                          color:
                                                              Color(0xFF205072),
                                                          width: 2,
                                                        ),
                                                      ),
                                                    ),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        offlineCouponCode =
                                                            value;
                                                      });
                                                    },
                                                  ),
                                                )
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.all(20.0),
                                              child: ButtonTheme(
                                                height: 50,
                                                minWidth: double.infinity,
                                                buttonColor: Color(0xFF56c590),
                                                child: ElevatedButton(
                                                  onPressed: currentUserToken ==
                                                              null &&
                                                          accountno != null
                                                      ? () {
                                                          _tokenGenerator();
                                                          print(token);
                                                          //_showToken();
                                                          _insertToken();
                                                          facebookAppevents
                                                              .logEvent(
                                                                  name:
                                                                      "Offline Purchase Initiated",
                                                                  parameters: {
                                                                "id": userid,
                                                              });
                                                          setState(() {
                                                            value = true;
                                                          });
                                                        }
                                                      : () {},
                                                  child:
                                                      currentUserToken == null
                                                          ? Text(
                                                              'Generate Token',
                                                              style: TextStyle(
                                                                  //color: Colors.white,
                                                                  ),
                                                            )
                                                          : Tooltip(
                                                              message:
                                                                  'ടോക്കൺ സാധുത 7 ദിവസം മാത്രമാണ്',
                                                              child: _isUploading
                                                                  ? Text('ദയവായി പൂർത്തിയാകുന്നതുവരെ കാത്തിരിക്കുക',
                                                                      style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            size.width *
                                                                                .032,
                                                                      ))
                                                                  : Text(
                                                                      'TOKEN NO : ' +
                                                                          currentUserToken
                                                                              .toString(),
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              20),
                                                                    ),
                                                            ),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    foregroundColor:
                                                        Colors.white,
                                                    backgroundColor:
                                                        currentUserToken == null
                                                            ? accentcolor
                                                            : activecolor,
                                                    elevation: 5,
                                                    padding: EdgeInsets.only(
                                                        left: 50,
                                                        right: 50,
                                                        bottom: 20,
                                                        top: 20),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                  currentUserToken != null &&
                                          _submitted == false
                                      ? Center(
                                          child: _image == null
                                              ? Text(
                                                  'അപ്‌ലോഡു ചെയ്യാൻ ചെല്ലാൻ ഫോട്ടോ എടുക്കുക')
                                              : Card(
                                                  elevation: 3.0,
                                                  shadowColor: activecolor,
                                                  child: Container(
                                                    padding: EdgeInsets.all(3),
                                                    child: Image.file(
                                                      _image!,
                                                      height: 150,
                                                    ),
                                                  ),
                                                ),
                                        )
                                      : Container(),
                                  currentUserToken != null &&
                                          _submitted == false
                                      ? Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 120, vertical: 20),
                                          child: _isUploading
                                              ? SpinKitThreeBounce(
                                                  color: Color(0xFF56c590),
                                                )
                                              : ButtonTheme(
                                                  minWidth: double.infinity,
                                                  buttonColor:
                                                      Color(0xFF56c590),
                                                  child: ElevatedButton(
                                                    onPressed: _image == null
                                                        ? null
                                                        : () {
                                                            setState(() {
                                                              _isUploading =
                                                                  true;
                                                            });
                                                            _upload();
                                                          },
                                                    child: Text(
                                                      'Upload',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12),
                                                    ),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      elevation: 5,
                                                      backgroundColor:
                                                          accentcolor,
                                                      padding: EdgeInsets.only(
                                                          left: 35,
                                                          right: 35,
                                                          bottom: 20,
                                                          top: 20),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                        )
                                      : Container(),
                                  _isUploading
                                      ? Text(
                                          'ദയവായി പൂർത്തിയാകുന്നതുവരെ കാത്തിരിക്കുക',
                                          style: TextStyle(
                                              // color: Colors.white,
                                              fontSize: size.width * .035,
                                              fontWeight: FontWeight.bold))
                                      : Text('')
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          floatingActionButton:
              active == 1 && currentUserToken != null && _submitted == false
                  ? _isUploading
                      ? null
                      : FloatingActionButton(
                          onPressed: getImage,
                          tooltip: 'Pick Image',
                          child: Icon(Icons.add_a_photo),
                        )
                  : null),
    );
  }
}
