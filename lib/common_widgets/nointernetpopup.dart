import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ndialog/ndialog.dart';

class NoInternet extends StatefulWidget {
  @override
  _NoInternetState createState() => _NoInternetState();
}

class _NoInternetState extends State<NoInternet> {
  showError() {
    return DialogBackground(
      barrierColor: Colors.grey.withOpacity(1),
      blur: 0,
      dialog: AlertDialog(
        title: Row(
          children: [
            SizedBox(
              width: 40,
            ),
            Text(
              "No Internet",
              textAlign: TextAlign.center,
            ),
            SizedBox(
              width: 10,
            ),
            Icon(Icons.wifi_off_rounded)
          ],
        ),
        content: Text("You are not conneted to the Internet."),
        actions: <Widget>[
          TextButton(
            child: Text("Retry"),
            onPressed: () {
              //Navigator.of(context).pop();
              // Navigator.of(context).pushReplacementNamed(DemoPage.routeName);

              SystemChannels.platform.invokeMethod('Systemnavigator.pop');
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(' Connecting'),
                  SizedBox(width: 30),
                  CircularProgressIndicator(
                    strokeWidth: 2.0,
                  ),
                ],
              )));
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return showError();
  }
}
