import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:async';

import '../models/online_payment.dart';

class OnlinePayments with ChangeNotifier {
  List<OnlinePayment> _onlinepayments = [];

  List<OnlinePayment> get unlock {
    return [..._onlinepayments];
  }

  Future<void> addOnlinePayment(OnlinePayment payments) async {
    var parameters = {
      'userId': payments.userId.toString(),
      'razorpayId': payments.razorpayId.toString(),
      'status': payments.status.toString(),
      'time': payments.time!.toIso8601String(),
      'code': payments.code.toString(),
    };
    var uri =
        Uri.parse('https://api.englishcoach.app/api/dev/payment/payment.php');
    try {
      await http.post(uri, body: parameters);
    } catch (error) {
      throw (error);
    }
  }
}
