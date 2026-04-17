import 'package:englishcoach/pages/preliminary2/widget/report_tile.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/marksheets.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class TransReportScreen extends StatefulWidget {
  static const routename = '/transReportScreen';

  @override
  _TransReportScreenState createState() => _TransReportScreenState();
}

class _TransReportScreenState extends State<TransReportScreen> {
  var _isInit = true;
  var isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        isLoading = true;
      });
      final routeArgs = ModalRoute.of(context)!.settings.arguments as Map;
      final testid = routeArgs['testid'];
      Provider.of<PrelimTransMarksheets>(context)
          .fetchMarksheet(testid)
          .then((_) => setState(() {
                isLoading = false;
              }));
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context)!.settings.arguments as Map;
    final testid = routeArgs['testid'];
    final transpoints = routeArgs['trans'];
    final loadedTest =
        Provider.of<PrelimTransMarksheets>(context).findByTestId(testid);

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
                    transpoints.toString(),
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          isLoading
              ? Center(
                  child: SpinKitThreeBounce(
                    color: Color(0xFF56c590),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(10.0),
                    shrinkWrap: true,
                    itemCount: loadedTest.length,
                    itemBuilder: (ctx, i) => TransReportTile(
                      loadedTest[i].prelimTransAnsId!,
                      loadedTest[i].testId!,
                      loadedTest[i].prelimTransQuesNum!,
                      loadedTest[i].prelimTransAnswered!,
                      i,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
