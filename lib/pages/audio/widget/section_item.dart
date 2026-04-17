import '../screen/audio_dashboard.dart';
import 'package:flutter/material.dart';

class SectionItem extends StatelessWidget {
  final int secId;
  final String secName;
  SectionItem(this.secId, this.secName);
  @override
  Widget build(BuildContext context) {
    final userID = ModalRoute.of(context)!.settings.arguments;
    var width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.all(8),
      child: Column(
        children: <Widget>[
          InkWell(
            onTap: () => secName.trim() != 'Audio Translation'
                ? null
                : Navigator.of(context).pushNamed(
                    AudioDashboard.routeName,
                    arguments: userID,
                  ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
                bottomLeft: Radius.circular(16.0),
                bottomRight: Radius.circular(16.0),
              ),
              child: Image.asset('assets/images/sample.png',
                  height: width * 0.4,
                  width: MediaQuery.of(context).size.width / 0.25,
                  fit: BoxFit.cover),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16.0),
                  bottomRight: Radius.circular(16.0)),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: 15,
                ),
                Text(
                  secName,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
