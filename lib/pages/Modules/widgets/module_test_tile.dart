import 'package:englishcoach/config/color.dart';
import 'package:englishcoach/pages/Modules/providers/module_questions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../screens/module_test_report_screen.dart';
import '../screens/excercises_overview_screen.dart';
import '../providers/topictest_questions.dart';
import '../providers/module_tests.dart';
import '../providers/topictest_tests.dart';

class ModuleTestTile extends StatefulWidget {
  final int mTestId;
  final int modNum;
  final int userId;
  final int mTestPoints;
  final int index;
  final bool topic;
  final int tNum;

  ModuleTestTile(
    this.mTestId,
    this.modNum,
    this.userId,
    this.mTestPoints,
    this.index,
    this.topic,
    this.tNum,
  );

  @override
  _ModuleTestTileState createState() => _ModuleTestTileState();
}

class _ModuleTestTileState extends State<ModuleTestTile> {
  var _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      widget.topic
          ? Provider.of<TopicTestQuestion>(context, listen: false)
              .fetchQuestions(widget.tNum, widget.modNum)
          : Provider.of<ModuleQuestions>(context, listen: false)
              .fetchQuestions(widget.tNum, widget.modNum);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _deleteDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
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
                  margin: EdgeInsets.all(25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Delete ?',
                        style: GoogleFonts.solway(
                          textStyle: TextStyle(fontWeight: FontWeight.bold),
                          fontSize: 20,
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'ഇത് പരീക്ഷയും അതിന്റെ ഫലങ്ങളും പൂർണമായും ഇല്ലാതാക്കും.',
                        style: GoogleFonts.solway(
                            fontSize: 15,
                            // color: Colors.red,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            child: new Text(
                              "Yes",
                              style: GoogleFonts.solway(
                                  fontSize: 15,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: widget.topic
                                ? () {
                                    if (!mounted) return;
                                    setState(() {
                                      Navigator.of(context).pop();
                                    });

                                    Provider.of<TopicTests>(context,
                                            listen: false)
                                        .deleteTest(widget.mTestId);

                                    if (!mounted) return;
                                    setState(() {
                                      Provider.of<TopicTests>(context,
                                              listen: false)
                                          .removeTest(widget.mTestId);
                                      Navigator.of(context)
                                          .pushReplacementNamed(
                                              ExcercisesoverviewScreen
                                                  .routeName,
                                              arguments: {
                                            'mod': widget.modNum,
                                            'topic': widget.topic,
                                            'userId': widget.userId
                                          });
                                    });
                                  }
                                : () {
                                    if (!mounted) return;
                                    setState(() {
                                      Navigator.of(context).pop();
                                    });

                                    Provider.of<ModuleTests>(context,
                                            listen: false)
                                        .deleteTest(widget.mTestId);

                                    if (!mounted) return;
                                    setState(() {
                                      Provider.of<ModuleTests>(context,
                                              listen: false)
                                          .removeTest(widget.mTestId);
                                      Navigator.of(context)
                                          .pushReplacementNamed(
                                              ExcercisesoverviewScreen
                                                  .routeName,
                                              arguments: {
                                            'mod': widget.modNum,
                                            'topic': widget.topic,
                                            'userId': widget.userId
                                          });
                                    });
                                  },
                          ),
                          TextButton(
                            child: Text(
                              "No",
                              style: GoogleFonts.solway(
                                  fontSize: 15,
                                  color: Color(0xFF56c590),
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              setState(() {
                                Navigator.of(context).pop();
                              });
                            },
                          ),
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Row(
      children: [
        Container(
          width: size.width * .75,
          child: Card(
            elevation: 5,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(
                  ModuleTestReportScreen.routeName,
                  arguments: ModuleTestTile(
                    widget.mTestId,
                    widget.modNum,
                    widget.userId,
                    widget.mTestPoints,
                    widget.index,
                    widget.topic,
                    widget.tNum,
                  ),
                );
              },
              child: Container(
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(
                      Icons.assignment,
                      color: Color(0xFF205072),
                      size: 20,
                    ),
                    Text(
                      'Test Report  ' + (widget.index + 1).toString(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    (widget.mTestPoints >= 80)
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 20,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Passed',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 12,
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
                                size: 20,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Failed',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: size.width * .01,
        ),
        Container(
          width: size.width * .18,
          height: 78,
          child: Card(
            color: primaryColor,
            child: IconButton(
              onPressed: () => _deleteDialog(context),
              icon: Icon(Icons.delete),
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
