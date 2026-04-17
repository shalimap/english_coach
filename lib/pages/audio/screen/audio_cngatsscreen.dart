import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../provider/audiotests.dart';

class AudioCongrats extends StatefulWidget {
  static const routename = '/audio-congratscreen';
  @override
  _AudioCongratsState createState() => _AudioCongratsState();
}

class _AudioCongratsState extends State<AudioCongrats> {
  var _isInit = true;
  var passCount;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      final data = ModalRoute.of(context)!.settings.arguments as Map;
      final userId = data['userId'];
      final audNum = data['audNum'];
      var count = Provider.of<AudioTests>(context, listen: false)
          .passCount(userId, audNum);
      print(count.length);
      passCount = count.length;
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments as Map;
    final percent = data['percent'];
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: percent >= 70
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Congratulations',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Lottie.asset(
                    'assets/images/confitte.json',
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  passCount <= 0
                      ? Text(
                          'Next Module Unlocked',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : Text(
                          'Keep On Practicing !',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                  SizedBox(
                    height: 25,
                  ),
                  ElevatedButton(
                      child: Text(
                        'Ok',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      })
                ],
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Test Failed',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Lottie.asset(
                      'assets/images/4970-unapproved-cross.json',
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Please Try Again',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    ElevatedButton(
                        child: Text(
                          'Ok',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        })
                  ],
                ),
              ),
      ),
    );
  }
}
