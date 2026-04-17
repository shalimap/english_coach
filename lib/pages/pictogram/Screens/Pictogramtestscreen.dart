import 'package:englishcoach/config/color.dart';
import 'package:englishcoach/config/responsive.dart';
import 'package:englishcoach/pages/Modules/screens/menu_dashboard_page.dart';
import 'package:englishcoach/pages/pictogram/Components/Fieldcontainer.dart';
import 'package:englishcoach/pages/pictogram/Components/pic_input_field.dart';
import 'package:englishcoach/pages/pictogram/Components/text_field_container.dart';
import 'package:englishcoach/pages/pictogram/Models/getpictogram.dart';
import 'package:englishcoach/pages/pictogram/Models/pictogrammarksheet.dart';
import 'package:englishcoach/pages/pictogram/Providers/audioprovider.dart';
import 'package:englishcoach/pages/pictogram/Providers/pictogram.dart';
import 'package:englishcoach/pages/pictogram/Providers/pictogramanswer.dart';
import 'package:englishcoach/pages/pictogram/Providers/pictogramcompleted.dart';
import 'package:englishcoach/pages/pictogram/Screens/sentencescreen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import '../../trial/screens/menu_dashboard_page.dart';

class PictogramTestScreen extends StatefulWidget {
  static const routename = '/picttestscreen';

  @override
  _PictogramTestScreenState createState() => _PictogramTestScreenState();
}

class _PictogramTestScreenState extends State<PictogramTestScreen> {
  var _isinit = true;
  var _isloading = false;
  // var pictogramIndex = 3;

  var exact;
  var similar = false;

  List<Pictogrammarksheet> pictcompleted = [];

  List<Pictogram> pictogramnewList = [];
  List<Pictogram> pictnewList = [];

  var _loadedPictogram = true;

  final player = AudioPlayer();

  @override
  void didChangeDependencies() {
    if (_isinit) {
      final routeArgs = ModalRoute.of(context)!.settings.arguments;
      setState(() {
        _isloading = true;
      });
      final data = Provider.of<PictogramList>(context);

      Provider.of<PictogramList>(context).fetchpictogram().then((_) {
        if (_loadedPictogram) {
          final randompictogram =
              Provider.of<PictogramList>(context, listen: false).random();
          pictogramnewList = randompictogram;
          _loadedPictogram = false;
        }
      }).then((_) {
        Provider.of<PictogramAnswerList>(context, listen: false)
            .fetchanswer(pictogramnewList[data.pictogramindex].picId);
      }).then((_) {
        final pictCompleted =
            Provider.of<PictogramCompleted>(context, listen: false)
                .pictcompleted;

        pictcompleted = pictCompleted;
      }).then((_) {
        setState(() {
          _isloading = false;
        });
      });
    }
    _isinit = false;
    super.didChangeDependencies();
  }

  var correctans;
  var similarans;
  // var userId = 994623;
  final _wordcontroller = TextEditingController();
  final _wordkey = GlobalKey<FormState>();

  Duration duration = Duration();
  Duration position = Duration();

  bool? playing;

  AudioPlayer audioPlayer = new AudioPlayer();
  //AudioProvider audioProvider = new AudioProvider(url);

  Widget slider() {
    return Slider.adaptive(
      min: 0.0,
      value: position.inSeconds.toDouble(),
      max: duration.inSeconds.toDouble(),
      onChanged: (double value) {
        setState(() {
          audioPlayer.seek(Duration(seconds: value.toInt()));
        });
      },
    );
  }

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

  var pictCount = 5;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final routeArgs = ModalRoute.of(context)!.settings.arguments as Map;
    final userId = routeArgs['userid'];
    final modId = routeArgs['modid'];
    final key = routeArgs['key'];

    final data = Provider.of<PictogramList>(context);

    final pictData = Provider.of<PictogramList>(context).pictogramlist;
    // var pictCount = pictData.length = 5;

    final ansData = Provider.of<PictogramAnswerList>(context).pictanslist;
    for (var i = 0; i < ansData.length; i++) {
      print(ansData[i].picAnswers);

      correctans = ansData[0].picAnswers;
      similarans = ansData[i].picAnswers;
    }

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
        body: _isloading
            ? Center(
                child: SpinKitCircle(
                  color: Color(0xFF205072),
                ),
              )
            : Padding(
                padding: Responsive.isDesktop(context)
                    ? EdgeInsets.symmetric(horizontal: size.width * 0.2)
                    : const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 30),
                      Text('ഇംഗ്ലീഷിലേക്ക് തർജിമ  ചെയ്യുക',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(18.0),
                              child: Card(
                                elevation: 2,
                                child: FancyShimmerImage(
                                  imageUrl:
                                      pictogramnewList[data.pictogramindex]
                                          .image!,
                                ),
                              ),
                            ),
                            SizedBox(height: 30),
                            FieldContainer(
                              child: TextFieldContainer(
                                  child: Text(
                                      pictogramnewList[data.pictogramindex]
                                          .word!)),
                            ),
                            Form(
                              key: _wordkey,
                              child: PictInputField(
                                  keyboard: TextInputType.visiblePassword,
                                  hintText: 'ശരിയായ  പദം നൽകുക',
                                  controller: _wordcontroller,
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return 'Field cannot be empty';
                                    }
                                    return null;
                                  },
                                  icon1: exact == null
                                      ? null
                                      : exact
                                          ? Icon(Icons.check_circle,
                                              color: Colors.green)
                                          : Icon(
                                              Icons.cancel,
                                              color: Colors.red,
                                            )),
                            ),
                            exact == false
                                ? FieldContainer(
                                    child: TextFieldContainer(
                                        child: Row(
                                      children: [
                                        Text(
                                          'Correct word :',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.green),
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          correctans,
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    )),
                                  )
                                : Text(''),
                            InkWell(
                              onTap: exact == null
                                  ? null
                                  : () {
                                      play();
                                      setState(() {
                                        playing = true;
                                      });
                                    },
                              child: FieldContainer(
                                child: TextFieldContainer(
                                  child: Row(
                                    children: [
                                      InkWell(
                                        child: Icon(
                                          Icons.volume_up,
                                          color: exact == true || exact == false
                                              ? Colors.green
                                              : Colors.grey,
                                          size: 20,
                                        ),
                                        onTap: exact == null
                                            ? null
                                            : () {
                                                play();
                                                setState(() {
                                                  playing = true;
                                                });
                                              },
                                      ),
                                      SizedBox(width: 30),

                                      Flexible(
                                        child: Text(
                                          'ശരിയായ വാക്ക് കേൾക്കുക',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color:
                                                exact == true || exact == false
                                                    ? Colors.green
                                                    : Colors.grey,
                                          ),
                                        ),
                                      )
                                      // slider(),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 30),
                            ButtonTheme(
                              height: 50.0,
                              buttonColor: Color(0xFF56c590),
                              minWidth: 350,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: accentcolor,
                                  padding: EdgeInsets.only(
                                      left: 50, right: 50, bottom: 20, top: 20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: Text(
                                  playing == true || playing == false
                                      ? 'Next'
                                      : 'Submit',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () {
                                  if (_wordkey.currentState!.validate()) {
                                    if (_wordcontroller.text.trim() == correctans ||
                                        _wordcontroller.text.trim() ==
                                            similarans ||
                                        _wordcontroller.text
                                                .trim()
                                                .toLowerCase() ==
                                            similarans
                                                .toString()
                                                .trim()
                                                .toLowerCase() ||
                                        _wordcontroller.text
                                                .trim()
                                                .toLowerCase() ==
                                            correctans
                                                .toString()
                                                .trim()
                                                .toLowerCase()) {
                                      setState(() {
                                        exact = true;
                                      });
                                    } else {
                                      setState(() {
                                        exact = false;
                                      });
                                    }

                                    if (playing == true || playing == false) {
                                      Navigator.of(context)
                                          .pushReplacementNamed(
                                              SentenceScreen.routename,
                                              arguments: {
                                            'userid': userId,
                                            'modid': modId,
                                            'picid': pictogramnewList[
                                                    data.pictogramindex]
                                                .picId,
                                            'correct': correctans,
                                            'key': key,
                                          });
                                    }
                                    return;
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  play() async {
    final data = Provider.of<PictogramList>(context, listen: false);
    final String url = pictogramnewList[data.pictogramindex].audioUrl!;

    if (kIsWeb) {
      await player.play(UrlSource(url));
    } else {
      AudioProvider audioProvider = new AudioProvider(url);
      String localUrl = await audioProvider.load();

      audioPlayer
          .play(UrlSource(
        localUrl,
      ))
          .then((_) {
        setState(() {
          playing = false;
        });
      });
    }

    // if (playing) {
    //   var res = await audioPlayer.pause();
    //   if (res == 1) {
    //     setState(() {
    //       playing = false;
    //     });
    //   }
    // } else {
    //   var res = await audioPlayer.play(localUrl, isLocal: true);
    //   if (res == 1) {
    //     setState(() {
    //       playing = true;
    //     });
    //   }
    // }
    // audioPlayer.onDurationChanged.listen((Duration dd) {
    //   setState(() {
    //     duration = dd;
    //   });
    // });
    // audioPlayer.onAudioPositionChanged.listen((Duration dd) {
    //   setState(() {
    //     position = dd;
    //   });
    // });
  }
}
