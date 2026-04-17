import 'package:flutter/material.dart';

// ignore: constant_identifier_names
enum ViewState { Idle, Busy }

class BaseProvider with ChangeNotifier {
  ViewState _state = ViewState.Idle;
  ViewState get state => _state;

  void setState(ViewState viewState) {
    if (_state != viewState) _state = viewState;
    Future.delayed(const Duration(milliseconds: 100), () {
      notifyListeners();
    });
  }

  getState() {
    return _state;
  }

  void setBusy() {
    setState(ViewState.Busy);
  }

  void setIdle() {
    setState(ViewState.Idle);
  }
}
