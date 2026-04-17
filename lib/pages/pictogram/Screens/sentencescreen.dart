import 'package:englishcoach/config/color.dart';
import 'package:englishcoach/pages/Modules/screens/menu_dashboard_page.dart';
import 'package:englishcoach/pages/pictogram/Components/Fieldcontainer.dart';
import 'package:englishcoach/pages/pictogram/Components/text_field_container.dart';
import 'package:englishcoach/pages/pictogram/Models/pictogrammarksheet.dart';
import 'package:englishcoach/pages/pictogram/Providers/pictogram.dart';
import 'package:englishcoach/pages/pictogram/Providers/pictogramcompleted.dart';
import 'package:englishcoach/pages/pictogram/Screens/Pictogramtestscreen.dart';
import 'package:englishcoach/pages/trial/screens/menu_dashboard_page.dart';
import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../config/responsive.dart';

class SentenceScreen extends StatefulWidget {
  static const routename = '/sentencescreen';

  @override
  _SentenceScreenState createState() => _SentenceScreenState();
}

class _SentenceScreenState extends State<SentenceScreen> {
  var isLoading = false;

  @override
  void didChangeDependencies() {
    setState(() {
      isLoading = true;
    });

    final routeArgs = ModalRoute.of(context)!.settings.arguments as Map;

    final getuserId = routeArgs['userid'];

    final getpictId = routeArgs['picid'];

    final getans = routeArgs['correct'];

    setState(() {
      isLoading = false;
    });

    super.didChangeDependencies();
  }

  final _notecontroller = TextEditingController();

  final _noteFocus = FocusNode();

  final _pickey = GlobalKey<FormState>();

  Future<bool> _onWillpopscope() async {
    final routeArgs = ModalRoute.of(context)!.settings.arguments as Map;
    final userId = routeArgs['userid'];
    final key = routeArgs['key'];

    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Center(
              child: Text('Quit'),
            ),
            content: Text(
                'നിങ്ങൾക്ക് എപ്പോൾ വേണമെങ്കിലും വീണ്ടും സന്ദർശിക്കാൻ കഴിയും'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 70),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () {
                          key == 1
                              ? Navigator.of(context).pushNamedAndRemoveUntil(
                                  MenuDashboardPage.routeName, (route) => false,
                                  arguments: userId.toString())
                              : Navigator.of(context).pushNamedAndRemoveUntil(
                                  TrialDashboardPage.routeName,
                                  (route) => false,
                                  arguments: userId.toString());
                        },
                        child: Text(
                          'Ok',
                          style: TextStyle(color: accentcolor),
                        )),
                    SizedBox(width: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: accentcolor),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final data = Provider.of<PictogramList>(context);
    print(data.pictogramindex);
    final pictData = Provider.of<PictogramList>(context).pictogramlist;
    var pictCount = pictData.length = 5;

    final routeArgs = ModalRoute.of(context)!.settings.arguments as Map;

    final getuserId = routeArgs['userid'];
    final getmodId = routeArgs['modid'];

    final getpictId = routeArgs['picid'];

    final getans = routeArgs['correct'];
    final getkey = routeArgs['key'];

    return WillPopScope(
      onWillPop: _onWillpopscope,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.chevron_left,
              color: Colors.white,
              size: 40,
            ),
            onPressed: () {},
          ),
          elevation: 0.0,
          title: Text(
            "Vocabulary",
            style: GoogleFonts.solway(
                textStyle: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
          ),
          centerTitle: true,
        ),
        body: isLoading
            ? Center(
                child: SpinKitCircle(
                  color: Color(0xFF205072),
                ),
              )
            : SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: Responsive.isDesktop(context)
                        ? EdgeInsets.symmetric(horizontal: size.width * 0.2)
                        : const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 30),
                        Text('വാക്യത്തിൽ  പ്രയോഗിക്കുക '),
                        SizedBox(height: 30),
                        FieldContainer(
                          child: TextFieldContainer(
                            child: Text(getans.toString()),
                          ),
                        ),
                        SizedBox(height: 20),
                        Form(
                          key: _pickey,
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            // height: MediaQuery.of(context).size.height * 32 / 140,
                            width: double.infinity,
                            //  MediaQuery.of(context).size.width * 0.83,
                            // decoration: BoxDecoration(
                            //     border: Border.all(width: 1, color: Colors.grey[400]),
                            //     borderRadius: BorderRadius.all(Radius.circular(15))),
                            child: TextFormField(
                              autocorrect: false,
                              enableSuggestions: false,
                              keyboardType: TextInputType.visiblePassword,
                              maxLines: 5,
                              controller: _notecontroller,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return 'Sentence cannot be empty';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText:
                                    '$getans ഉപയോഗിച്ചു  സെൻ്റെൻസ്  എഴുതുക',
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFF56C590)),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.redAccent),
                                  borderRadius: BorderRadius.circular(29),
                                ),
                              ),
                            ),

                            //  Text('data'),
                          ),
                        ),
                        SizedBox(height: 30),
                        ButtonTheme(
                          height: 50,
                          buttonColor: Color(0xFF56c590),
                          minWidth: 350,
                          child: ElevatedButton(
                            child: Text(
                              'Submit',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () {
                              if (_pickey.currentState!.validate()) {
                                var _addpic = Pictogrammarksheet(
                                  userId: getuserId,
                                  modId: getmodId,
                                  picId: getpictId,
                                  sentence: _notecontroller.text,
                                );

                                if (data.pictogramindex < pictCount - 1) {
                                  data.increment();
                                  Provider.of<PictogramCompleted>(context,
                                          listen: false)
                                      .addPictogram(_addpic);

                                  Navigator.of(context).pushReplacementNamed(
                                      PictogramTestScreen.routename,
                                      arguments: {
                                        'userid': getuserId,
                                        'modid': getmodId,
                                        'key': getkey,
                                      });
                                } else {
                                  Provider.of<PictogramCompleted>(context,
                                          listen: false)
                                      .addPictogram(_addpic);
                                  getkey == 1
                                      ? Navigator.of(context)
                                          .pushReplacementNamed(
                                              MenuDashboardPage.routeName,
                                              arguments: getuserId.toString())
                                      : Navigator.of(context)
                                          .pushReplacementNamed(
                                              TrialDashboardPage.routeName,
                                              arguments: getuserId.toString());

                                  data.pictogramindex = 0;
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accentcolor,
                              padding: EdgeInsets.only(
                                  left: 50, right: 50, bottom: 20, top: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
