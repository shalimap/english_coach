import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import '../models/coupon.dart';

class Coupons with ChangeNotifier {
  List<Coupon> _coupons = [];

  List<Coupon> get coupons {
    return [..._coupons];
  }

  Future<List<Coupon>> fetchCoupons() async {
    var uri =
        Uri.https('www.api.englishcoach.app', '/api/dev/payment/coupon.php');
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        List extractedData = json.decode(response.body);
        List<Coupon> loadedCoupons = [];
        for (var i = 0; i < extractedData.length; i++) {
          var bank = Coupon.fromJson(extractedData[i]);
          loadedCoupons.add(bank);
        }
        loadedCoupons.sort((a, b) => a.couponId!.compareTo(b.couponId!));
        _coupons = loadedCoupons;
        notifyListeners();
      }
    } catch (error) {
      print('ERROR : ' + error.toString());
      //throw (error);
    }
    return _coupons;
  }

  int calculateReduction(String coupon) {
    var _reduction;
    var coup = _coupons
        .firstWhere((c) => c.couponName!.toUpperCase() == coupon.toUpperCase());
    _reduction = coup.couponReduction;
    return _reduction;
  }

  bool isValidCoupon(String coupon) {
    var validCoupon = _coupons
        .where((c) => c.couponName!.toUpperCase() == coupon.toUpperCase());
    if (validCoupon.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  bool isExpired(String coupon) {
    var notExpired = _coupons.where((c) =>
        c.couponName!.toUpperCase() == coupon.toUpperCase() &&
        c.couponCount! > 0);
    if (notExpired.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  List<Coupon> couponCount(String coupon) {
    return _coupons
        .where((c) => c.couponName!.toUpperCase() == coupon.toUpperCase())
        .toList();
  }

  Future<void> updateCouponCount(int couponId, int couponCount) async {
    var parameters = {
      'couponId': couponId.toString(),
      'couponCount': (couponCount - 1).toString(),
    };
    var uri = Uri.parse(
        'https://api.englishcoach.app/api/dev/payment/updatecoupon.php');
    try {
      await http.post(uri, body: parameters);
    } catch (error) {
      throw (error);
    }
  }
}
