import 'package:englishcoach/pages/preliminary1/Models/mcq_marksheet.dart';
import 'package:englishcoach/pages/trialTest/Widgets/trialreporttile.dart';
import 'package:englishcoach/pages/trialTest/providers/trial_answered.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TrialReportPage extends StatefulWidget {
  static const routename = '/trialReportScreen';
  @override
  _TrialReportPageState createState() => _TrialReportPageState();
}

class _TrialReportPageState extends State<TrialReportPage> {
  List<Mcqmarksheet> exerciseQuestions = [];

  var _isInit = true;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      final routeArgs = ModalRoute.of(context)!.settings.arguments as Map;
      final testid = routeArgs['testid'];
      Provider.of<TrialAnswered>(context).fetchMarksheet(testid);
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context)!.settings.arguments as Map;
    final testid = routeArgs['testid'];
    final mcqpoints = routeArgs['mcq'];
    final loadedTest = Provider.of<TrialAnswered>(context).findByTestId(testid);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            size: 40,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0.0,
        title: Text(
          'Test Report',
          style: GoogleFonts.solway(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
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
                    mcqpoints.toString(),
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
                padding: const EdgeInsets.all(10.0),
                shrinkWrap: true,
                itemCount: loadedTest.length,
                itemBuilder: (ctx, i) => TrialReportTile(
                      loadedTest[i].trailMcqNum!,
                      loadedTest[i].testId!,
                      loadedTest[i].trialAns!,
                      i,
                    )),
          ),
        ],
      ),
    );
  }
}
