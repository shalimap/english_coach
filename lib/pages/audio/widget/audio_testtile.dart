import '../provider/audiotests.dart';
import '../provider/audioquestions.dart';
import '../screen/audio_reportdetail.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class AudioTestTile extends StatefulWidget {
  final int audTestId;
  final int userId;
  final int audNum;
  final int score;
  final int status;
  final int index;

  AudioTestTile(this.audTestId, this.userId, this.audNum, this.score,
      this.status, this.index);

  @override
  _AudioTestTileState createState() => _AudioTestTileState();
}

class _AudioTestTileState extends State<AudioTestTile> {
  var _isInit = true;
  var _isLoading = false;
  var _isBusy = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      if (!mounted) return;
      setState(() {
        _isLoading = true;
      });
      Provider.of<AudioTests>(context, listen: false)
          .fetchTests(widget.userId, widget.audNum)
          .then((_) => Provider.of<AudioQuestions>(context, listen: false)
              .fetchQuestions(widget.audNum))
          .then((_) {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading || _isBusy
        ? Center(
            child: SpinKitThreeBounce(
              color: Color(0xFF56c590),
            ),
          )
        : widget.index != 0
            ? Dismissible(
                key: UniqueKey(),
                background: Container(
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Theme.of(context).colorScheme.error,
                  ),
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 40,
                  ),
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 20),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
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
                                      'Delete Test ?',
                                      style: GoogleFonts.solway(
                                        textStyle: TextStyle(
                                            fontWeight: FontWeight.bold),
                                        fontSize: 20,
                                        color: Colors.red,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      'ഇത് പരീക്ഷയും അതിന്റെ ഫലങ്ങളും പൂർണ്ണമായും ഇല്ലാതാക്കും.',
                                      style: GoogleFonts.solway(
                                          fontSize: 15,
                                          // color: Colors.red,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        TextButton(
                                          child: new Text(
                                            "Yes",
                                            style: GoogleFonts.solway(
                                                fontSize: 15,
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          onPressed: () {
                                            if (!mounted) return;
                                            setState(() {
                                              _isBusy = true;
                                              Navigator.of(context).pop();
                                            });

                                            Provider.of<AudioTests>(context,
                                                    listen: false)
                                                .deleteTest(widget.audTestId)
                                                .then((_) {
                                              Future.delayed(
                                                      Duration(seconds: 5))
                                                  .then((_) {
                                                if (!mounted) return;
                                                setState(() {
                                                  _isBusy = false;
                                                });
                                              });
                                            });
                                            if (!mounted) return;
                                            setState(() {
                                              Provider.of<AudioTests>(context,
                                                      listen: false)
                                                  .removeTest(widget.audTestId);
                                              Navigator.of(context).pop();
                                            });
                                          },
                                        ),
                                        TextButton(
                                          child: new Text(
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
                },
                child: Card(
                  elevation: 5,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        AudioReportDetail.routename,
                        arguments: AudioTestTile(
                          widget.audTestId,
                          widget.userId,
                          widget.audNum,
                          widget.score,
                          widget.status,
                          widget.index,
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
                            size: 25,
                          ),
                          Text(
                            'Test Report  ' + (widget.index + 1).toString(),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          (widget.score >= 70)
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
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
                ),
              )
            : Card(
                elevation: 5,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      AudioReportDetail.routename,
                      arguments: AudioTestTile(
                        widget.audTestId,
                        widget.userId,
                        widget.audNum,
                        widget.score,
                        widget.status,
                        widget.index,
                      ),
                    );
                  },
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
                        (widget.score >= 70)
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
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
