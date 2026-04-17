import '../providers/final_test_tests.dart';
import '../screens/finalreport-detailscreen.dart';
import '../providers/final_test_questions.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class FinalTestTile extends StatefulWidget {
  final int finalTestId;
  final int userId;
  final int finalTestPoints;
  final int finalStatus;
  final int index;

  FinalTestTile(this.finalTestId, this.userId, this.finalTestPoints,
      this.finalStatus, this.index);

  @override
  _FinalTestTileState createState() => _FinalTestTileState();
}

class _FinalTestTileState extends State<FinalTestTile> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<FinalTestChecks>(context)
          .fetchTests(widget.userId)
          .then((_) => Provider.of<FinaltestQuestions>(context, listen: false)
              .fetchQuestions())
          .then((_) => setState(() {
                _isLoading = false;
              }));
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: SpinKitThreeBounce(
              color: Color(0xFF56c590),
            ),
          )
        : InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(
                ReportDetailscreen.routename,
                arguments: FinalTestTile(
                  widget.finalTestId,
                  widget.userId,
                  widget.finalTestPoints,
                  widget.finalStatus,
                  widget.index,
                ),
              );
            },
            child: Card(
              elevation: 5,
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
                    (widget.finalTestPoints >= 80)
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
