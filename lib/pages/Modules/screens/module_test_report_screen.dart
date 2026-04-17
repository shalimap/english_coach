import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../providers/module_marksheet.dart';
import '../providers/topictest_marksheet.dart';
import '../widgets/module_report_tile.dart';
import '../widgets/module_test_tile.dart';
import '../widgets/topic_report_tile.dart';

class ModuleTestReportScreen extends StatefulWidget {
  static const routeName = '/module-test-report';

  @override
  _ModuleTestReportScreenState createState() => _ModuleTestReportScreenState();
}

class _ModuleTestReportScreenState extends State<ModuleTestReportScreen> {
  var _isInit = true;
  var _isLoading = false;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      final ModuleTestTile testIdMark =
          ModalRoute.of(context)!.settings.arguments as ModuleTestTile;
      testIdMark.topic
          ? Provider.of<TopicTestMarksheet>(context, listen: false)
              .fetchMarksheet(testIdMark.mTestId)
              .then((_) => setState(() {
                    _isLoading = false;
                  }))
          : Provider.of<ModuleMarkSheet>(context, listen: false)
              .fetchMarksheet(testIdMark.mTestId)
              .then((_) => setState(() {
                    _isLoading = false;
                  }));
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final ModuleTestTile testIdMark =
        ModalRoute.of(context)!.settings.arguments as ModuleTestTile;
    final loadedTest = Provider.of<ModuleMarkSheet>(context, listen: false)
        .findByTestId(testIdMark.mTestId);
    final loadedTopicTest =
        Provider.of<TopicTestMarksheet>(context, listen: false)
            .findByTestId(testIdMark.mTestId);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Test Report',
          style: GoogleFonts.solway(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            size: 40,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0.0,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xFF205072)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Marks Scored',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    testIdMark.mTestPoints.toString(),
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          _isLoading
              ? Center(
                  child: SpinKitThreeBounce(
                    color: Color(0xFF56c590),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(10.0),
                    shrinkWrap: true,
                    itemCount: testIdMark.topic
                        ? loadedTopicTest.length
                        : loadedTest.length,
                    itemBuilder: (ctx, i) => testIdMark.topic
                        ? TopicReportTile(
                            loadedTopicTest[i].topansId!,
                            loadedTopicTest[i].ttestId!,
                            loadedTopicTest[i].topicQueNum!,
                            loadedTopicTest[i].topansAnswer!,
                            testIdMark.topic,
                            i,
                          )
                        : ModuleReportTile(
                            loadedTest[i].mMarkId!,
                            loadedTest[i].mTestId!,
                            loadedTest[i].exeNum!,
                            loadedTest[i].mMarkAnswer!,
                            testIdMark.topic,
                            i,
                          ),
                  ),
                ),
        ],
      ),
    );
  }
}
