import 'package:englishcoach/pages/Modules/screens/module_test_screen(updated).dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import '../screens/topic_test_screen.dart';

class ModuleTestScreen extends StatelessWidget {
  static const routeName = 'module-test';

  final ScrollController _scrollController = ScrollController();

  static const Rules1 =
      "1. നിങ്ങൾക്ക് നൽകിയിരിക്കുന്ന ഇംഗ്ളീഷ് ലഘു പദങ്ങൾ ഉപയോഗിച്ച് ഒരു വാക്യം ഉണ്ടാക്കുക.";
  static const Rules1eg = "ഉദാഹരണം";
  static const Rules1eg1 = "ചോദ്യം :  Amal, write, books";
  static const Rules1eg2 = "ഉത്തരം : Amal writes books.";
  static const Rules2 =
      "2. ഏതെങ്കിലും ചോദ്യത്തിൽ സൂചകമായി പദങ്ങൾ നൽകിയിട്ടുണ്ടെങ്കിൽ ആ പദങ്ങൾ ഗ്രാമർ അനുസരിച്ച് വാചകത്തിൽ ചേർക്കണം.";

  static const Rules2eg = "ഉദാഹരണം ";
  static const Rules2eg1 = "ചോദ്യം :  Amal, write, books ( Will )  ";
  static const Rules2eg2 = "ഉത്തരം : Amal will write books.";
  static const Rules3 = "3. വാചകത്തിന്റെ ആദ്യാക്ഷരം Capital Letter ആയിരിക്കണം";
  static const Rules4 = "4. വാചകത്തിന്റെ അവസാനം Full Stop ഉണ്ടായിരിക്കണം";
  static const Rules5 =
      "5. ഒരു വാചകത്തിൽ ഒരു വ്യക്തിയുടെ പേരോ, സ്ഥലത്തിന്റെ പേരോ വന്നാൽ അവിടെയും വലിയക്ഷരം അഥവാ Capital Letter ആണ് ഉപയോഗിക്കേണ്ടത്";
  static const Rules6 =
      "6. വാചകങ്ങളിൽ Won't , Can't  എന്നിവക്ക് പകരം Would not, Can not, Should not, Will not എന്ന രീതിയിലുള്ള ശരിയായ രൂപങ്ങൾ ചേർക്കണം.";
  static const Rules7 =
      "7. ഓരോ ചോദ്യത്തിനുമുള്ള  ശരിയുത്തരം തിരഞ്ഞെടുക്കുന്നതിനുള്ള പരമാവധി സമയം ഒരു മിനിറ്റ് ആണ്.";

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments as Map;
    final moduleId = data['mod'];
    final topic = data['topic'];
    final userId = data['userId'];
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
        title: topic
            ? Text(
                'Topic Test',
                style: GoogleFonts.solway(
                    textStyle: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              )
            : Text(
                'Module Test',
                style: GoogleFonts.solway(
                    textStyle: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Test Rules",
                style: TextStyle(
                    fontSize: 21,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
            SizedBox(height: 15, width: double.infinity),
            Expanded(
              flex: 14,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 5.0,
                child: Container(
                  padding: EdgeInsets.all(10),
                  // decoration: BoxDecoration(
                  //     border: Border.all(width: 2, color: Colors.black38),
                  //     borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Scrollbar(
                    thumbVisibility: true,
                    controller: _scrollController,
                    child: ListView(
                      controller: _scrollController,
                      physics: ClampingScrollPhysics(),
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      children: <Widget>[
                        SizedBox(height: 15, width: double.infinity),
                        Text(Rules1, textAlign: TextAlign.start),
                        SizedBox(height: 25, width: double.infinity),
                        Text(Rules1eg, textAlign: TextAlign.start),
                        SizedBox(height: 25, width: double.infinity),
                        Text(Rules1eg1, textAlign: TextAlign.start),
                        SizedBox(height: 25, width: double.infinity),
                        Text(Rules1eg2, textAlign: TextAlign.start),
                        SizedBox(height: 25, width: double.infinity),
                        Text(Rules2, textAlign: TextAlign.start),
                        SizedBox(height: 25, width: double.infinity),
                        Text(Rules2eg, textAlign: TextAlign.start),
                        SizedBox(height: 25, width: double.infinity),
                        Text(Rules2eg1, textAlign: TextAlign.start),
                        SizedBox(height: 25, width: double.infinity),
                        Text(Rules2eg2, textAlign: TextAlign.start),
                        SizedBox(height: 25, width: double.infinity),
                        Text(Rules3, textAlign: TextAlign.start),
                        SizedBox(height: 25, width: double.infinity),
                        Text(Rules4, textAlign: TextAlign.start),
                        SizedBox(height: 25, width: double.infinity),
                        Text(Rules5, textAlign: TextAlign.start),
                        SizedBox(height: 25, width: double.infinity),
                        Text(Rules6, textAlign: TextAlign.start),
                        SizedBox(height: 25, width: double.infinity),
                        Text(Rules7, textAlign: TextAlign.start),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15, width: double.infinity),
            Expanded(
              flex: 1,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Color(0xFF205072),
                  backgroundColor: Color(0xFF56c590),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: topic
                    ? () {
                        Navigator.of(context)
                            .popAndPushNamed(TopicsTest.routeName, arguments: {
                          'mod': moduleId,
                          'userId': userId,
                          'topic': topic
                        });
                      }
                    : () {
                        Navigator.of(context)
                            .popAndPushNamed(ModuleTest.routeName, arguments: {
                          'mod': moduleId,
                          'userId': userId,
                          'topic': topic
                        });
                      },
                child: topic
                    ? Text(
                        'Take Topic Test',
                        style: GoogleFonts.solway(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      )
                    : Text(
                        'Take Module Test',
                        style: GoogleFonts.solway(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
