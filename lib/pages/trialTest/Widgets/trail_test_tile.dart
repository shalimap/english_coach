import 'package:englishcoach/pages/trialTest/screens/trial_reportpage.dart';

import '../providers/trial_tests.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TrailTestTile extends StatefulWidget {
  final int testId;
  final int modId;
  final int userId;
  final int mcqPoints;
  final int status;
  final int index;

  TrailTestTile(this.testId, this.modId, this.userId, this.mcqPoints,
      this.status, this.index);

  @override
  _TrailTestTileState createState() => _TrailTestTileState();
}

class _TrailTestTileState extends State<TrailTestTile> {
  var _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<TrialTest>(context).fetchTests(widget.modId, widget.userId);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: InkWell(
        onTap: () {
          // Navigator.of(context).pushNamed(
          //   ReportDetailscreen.routename,
          //   arguments: FinalTestTile(
          //     widget.finalTestId,
          //     widget.userId,
          //     widget.finalTestPoints,
          //     widget.finalStatus,
          //     widget.index,
          //   ),
          // );

          Navigator.of(context)
              .pushNamed(TrialReportPage.routename, arguments: {
            'testid': widget.testId,
            'mcq': widget.mcqPoints,
          });
        },
        child: Container(
          height: 70,
          child: Row(
            // crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(
                Icons.assignment,
                color: Color(0xFF205072),
                size: 25,
              ),
              Text(
                'Test Report  ' + (widget.index + 1).toString(),
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              (widget.mcqPoints >= 60)
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Passed',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(
                          Icons.cancel,
                          color: Colors.red,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Failed',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
