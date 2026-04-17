import 'package:englishcoach/config/color.dart';
import 'package:englishcoach/pages/preliminary2/screens/translation_test_page.dart';
import 'package:flutter/material.dart';

class Prelim2TestRules extends StatelessWidget {
  static const routeName = '/prelim2-testrules';

  final ScrollController _scrollController = ScrollController();

  static const Rules1 =
      "1. ഈ സെക്ഷനിൽ പത്ത് ചോദ്യങ്ങൾക്കുള്ള ഉത്തരമാണ് പൂർത്തീകരിക്കേണ്ടത്.";
  static const Rules2 =
      "2. മലയാളത്തിൽ നിന്നും ഇംഗ്ളീഷിലേക്ക് തർജ്ജമ ചെയ്യേണ്ട രീതിയിലാണ് ഈ ചോദ്യങ്ങൾ.";
  static const Rules3 =
      "3. ഓരോ ചോദ്യത്തിനുമുള്ള ഏറ്റവും ഉചിതമായ തർജ്ജമ അഥവാ Translation ആണ് ചെയ്യേണ്ടത്";
  static const Rules4 =
      "4. ഉത്തരങ്ങൾ സമർപ്പിക്കുമ്പോൾ താഴെക്കൊടുത്തിരിക്കുന്നവ ശ്രദ്ധിക്കുക";
  static const Rules5 =
      "5. ഇംഗ്ളീഷ് തർജ്ജമയുടെ അഥവാ Translation ന്റെ ആദ്യ അക്ഷരം വലിയക്ഷരത്തിലായിരിക്കണം അഥവാ  Capital Letter ആയിരിക്കണം.";
  static const Rules6 =
      "6. ഇംഗ്ളീഷ് തർജ്ജമക്ക് അഥവാ Translation ന് പൂർണ്ണ വിരാമം അഥവാ Full Stop ഉണ്ടായിരിക്കണം";
  static const Rules6eg = "ഉദാഹരണം ";

  static const Rules6eg1 = "Malayalam : ദേവി പഠിച്ചു";

  static const Rules6eg2 = "Wrong Translation   :  devi studied";

  static const Rules6eg3 = "Right  Translation  :  Devi studied.";

  static const Rules7 =
      "7. ഒരു വാചകത്തിൽ ഒരു വ്യക്തിയുടെ പേരോ, സ്ഥലത്തിന്റെ പേരോ വന്നാൽ അവിടെയും വലിയക്ഷരം അഥവാ Capital Letter ആണ് ഉപയോഗിക്കേണ്ടത് ";
  static const Rules7eg = "Malayalam : കിരണും സാബിത്തും ബാംഗ്ലൂരിൽ പോയി.";

  static const Rules7eg1 =
      "Wrong Translation   :  kiran and sabith went to bangalore";

  static const Rules7eg2 =
      "Right  Translation  :  Kiran and Sabith went to Bangalore.";

  static const Rules8 =
      "8. ഓരോ ചോദ്യത്തിനുമുള്ള  ശരിയുത്തരം തിരഞ്ഞെടുക്കുന്നതിനുള്ള പരമാവധി സമയം രണ്ട് മിനിറ്റ് ആണ്.";

  static const Rules9 =
      "9. വാചകങ്ങളിൽ Won't , Can't  എന്നിവക്ക് പകരം Would not, Can not, Should not, Will not എന്ന രീതിയിലുള്ള ശരിയായ രൂപങ്ങൾ ചേർക്കണം.";

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context)!.settings.arguments as Map;
    final userid = routeArgs['userid'];
    final testid = routeArgs['testid'];
    final mcqpoints = routeArgs['mcqpoints'];
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.chevron_left,
              size: 40,
              color: Colors.transparent,
            ),
            onPressed: null,
          ),
          elevation: 0.0,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Text("TEST RULES",
                  style: TextStyle(
                      fontSize: 21,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
            ),
            Expanded(
                flex: 25,
                child: Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    elevation: 5.0,
                    child: Container(
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(10),
                        // decoration: BoxDecoration(
                        //     border: Border.all(width: 2, color: Colors.black38),
                        //     borderRadius: BorderRadius.all(Radius.circular(15))),
                        child: Scrollbar(
                          thumbVisibility: true,
                          controller: _scrollController,
                          child: ListView(
                            padding: EdgeInsets.all(15),
                            controller: _scrollController,
                            physics: ClampingScrollPhysics(),
                            children: <Widget>[
                              SizedBox(height: 15, width: double.infinity),
                              Text(Rules1, textAlign: TextAlign.start),
                              SizedBox(height: 25, width: double.infinity),
                              Text(Rules2, textAlign: TextAlign.start),
                              SizedBox(height: 25, width: double.infinity),
                              Text(Rules3, textAlign: TextAlign.start),
                              SizedBox(height: 25, width: double.infinity),
                              Text(Rules4, textAlign: TextAlign.start),
                              SizedBox(height: 25, width: double.infinity),
                              Text(Rules5, textAlign: TextAlign.start),
                              SizedBox(height: 25, width: double.infinity),
                              Text(Rules6, textAlign: TextAlign.start),
                              SizedBox(height: 25, width: double.infinity),
                              Text(Rules6eg, textAlign: TextAlign.start),
                              SizedBox(height: 25, width: double.infinity),
                              Text(Rules6eg1, textAlign: TextAlign.start),
                              SizedBox(height: 25, width: double.infinity),
                              Text(Rules6eg2, textAlign: TextAlign.start),
                              SizedBox(height: 25, width: double.infinity),
                              Text(Rules6eg3, textAlign: TextAlign.start),
                              SizedBox(height: 25, width: double.infinity),
                              Text(Rules7, textAlign: TextAlign.start),
                              SizedBox(height: 25, width: double.infinity),
                              Text(Rules7eg, textAlign: TextAlign.start),
                              SizedBox(height: 25, width: double.infinity),
                              Text(Rules7eg1, textAlign: TextAlign.start),
                              SizedBox(height: 25, width: double.infinity),
                              Text(Rules7eg2, textAlign: TextAlign.start),
                              SizedBox(height: 25, width: double.infinity),
                              Text(Rules8, textAlign: TextAlign.start),
                              SizedBox(height: 25, width: double.infinity),
                              Text(Rules9, textAlign: TextAlign.start),
                            ],
                          ),
                        )),
                  ),
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
                                  TranslationTest.routeName,
                                  arguments: {
                                    'userid': userid,
                                    'testid': testid,
                                    'mcqpoints': mcqpoints,
                                  });
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
