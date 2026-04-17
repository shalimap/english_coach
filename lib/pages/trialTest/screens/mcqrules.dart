import 'package:englishcoach/config/color.dart';
import 'package:englishcoach/pages/preliminary1/screens/mcqtaketest.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MCQRules extends StatefulWidget {
  static const routename = '/mcqrulesscreen';
  MCQRules({Key? key}) : super(key: key);

  @override
  _MCQRulesState createState() => _MCQRulesState();
}

class _MCQRulesState extends State<MCQRules> {
  var isBusy = false;
  static const Rules1 =
      "1. ഈ സെക്ഷനിൽ പത്ത് ചോദ്യങ്ങൾക്കുള്ള ഉത്തരമാണ് പൂർത്തീകരിക്കേണ്ടത്. ";

  static const Rules2 =
      "2.ഓരോ ചോദ്യത്തിനും ഉള്ള നാല് ഓപ്‌ഷനുകളിൽ നിന്നും ശരിയുത്തരം തിരഞ്ഞെടുക്കുക.";

  static const Rules3 =
      "3.ഓരോ ചോദ്യത്തിനുമുള്ള  ശരിയുത്തരം തിരഞ്ഞെടുക്കുന്നതിനുള്ള പരമാവധി സമയം ഒരു മിനിറ്റ് ആണ്.";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final getuserid = ModalRoute.of(context)!.settings.arguments;
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.chevron_left,
              size: 40,
            ),
            onPressed: null,
          ),
          elevation: 0.0,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(),
            ),
            Expanded(
                flex: 25,
                child: Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(width: 2, color: Colors.black38),
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: ListView(
                        physics: ClampingScrollPhysics(),
                        children: <Widget>[
                          Text("TEST RULE",
                              style: TextStyle(
                                  fontSize: 21,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center),
                          SizedBox(height: 15, width: double.infinity),
                          Text(Rules1, textAlign: TextAlign.justify),
                          SizedBox(height: 25, width: double.infinity),
                          Text(Rules2, textAlign: TextAlign.justify),
                          SizedBox(height: 25, width: double.infinity),
                          Text(Rules3, textAlign: TextAlign.justify)
                        ],
                      )),
                )),
            Expanded(
              flex: 2,
              child: Container(),
            ),
            Expanded(
              flex: 2,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Container(),
                  ),
                  Expanded(
                      flex: 2,
                      child: Container(
                        decoration: BoxDecoration(
                            color: accentcolor,
                            borderRadius: BorderRadius.circular(
                                MediaQuery.of(context).size.height * 2 / 62)),
                        child: InkWell(
                            onTap: () {
                              Navigator.of(context).pushReplacementNamed(
                                McqTaketest.routename,
                                arguments: getuserid,
                              );
                            },
                            child: Center(
                              child: Text(
                                "OK",
                                style: TextStyle(
                                    fontSize: 21,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                      )),
                  Expanded(
                    flex: 2,
                    child: Container(),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}
