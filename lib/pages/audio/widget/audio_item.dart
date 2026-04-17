import '../screen/audio_reportscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../provider/audiolocks.dart';
import '../model/audiolock.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import '../screen/audio_dashboard.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class AudioItem extends StatefulWidget {
  final int audNum;
  final String audName;
  final String audlevel;
  final int userId;
  AudioItem(this.audNum, this.audName, this.audlevel, this.userId);

  @override
  _AudioItemState createState() => _AudioItemState();
}

class _AudioItemState extends State<AudioItem> {
  var _isInit = true;
  var _isLoading = false;
  var nullLock = false;
  List<AudioLock>? previousModId;
  var moduleId;
  var unlockedCount;
  var remainingTime;
  var topic;
  var difference;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      if (!mounted) return;
      setState(() {
        _isLoading = true;
      });
      Provider.of<AudioLocks>(context, listen: false)
          .fetchLocks(widget.userId)
          .then((lock) {
        if (lock.length == 0) {
          if (!mounted) return;
          setState(() {
            nullLock = true;
          });
        }
        Provider.of<AudioLocks>(context, listen: false)
            .fetchLocks(widget.userId)
            .then((count) => Provider.of<AudioLocks>(context, listen: false)
                .previous(widget.userId))
            .then((value) {
          previousModId = value;
          if (value.isNotEmpty) {
            if (!mounted) return;
            setState(() {
              moduleId = previousModId!.last.audNum;
            });
          }
          _isLoading = false;
        });
        if (nullLock) {
          if (widget.audNum == 1) {
            var _introMod = AudioLock(
              audNum: widget.audNum,
              userId: widget.userId,
              audLockOpen: 1,
              audUnlockedTime: DateTime.now(),
            );
            if (!mounted) return;
            setState(() {
              Provider.of<AudioLocks>(context, listen: false)
                  .unLockNextAudio(_introMod);
            });
          }
          Navigator.of(context).pushReplacementNamed(AudioDashboard.routeName,
              arguments: widget.userId.toString());
        }
      }).then((_) {
        final lockState = Provider.of<AudioLocks>(context, listen: false);
        final partiallyUnlocked = lockState.partiallyUnlocked(widget.audNum);
        if (partiallyUnlocked) {
          final timerData = Provider.of<AudioLocks>(context, listen: false)
              .findById(widget.audNum);
          var unlockedTime = timerData.audUnlockedTime;
          var limit = unlockedTime!.add(Duration(hours: 24));
          var diff = DateTime.now().difference(limit);
          difference = diff;
          print('Difference : ' + diff.toString());
          diff >= Duration(seconds: 1)
              ? _updateTimer(widget.userId, widget.audNum)
              : print('');
        }
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _updateTimer(int userId, int modNum) {
    if (!mounted) return;
    setState(() {
      Provider.of<AudioLocks>(context, listen: false)
          .updateTimer(userId, modNum);
    });
  }

  void _timerDialog(BuildContext context, int modId) {
    final timerData =
        Provider.of<AudioLocks>(context, listen: false).findById(modId);
    var unlockedTime = timerData.audUnlockedTime;
    var limit = unlockedTime!.add(Duration(hours: 24));
    Duration remainingTime = limit.difference(DateTime.now());
    Size size = MediaQuery.of(context).size;
    var alertDialog = AlertDialog(
      title: Center(child: Text('ദയവായി കാത്തിരിക്കുക')),
      content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return Container(
          width: double.infinity,
          height: size.height * 0.3,
          child: Center(
            child: CircularCountDownTimer(
              duration: remainingTime.inSeconds,
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.height / 2,
              ringColor: Color(0xFF56c590),
              fillColor: Colors.white,
              strokeWidth: 10.0,
              textStyle: TextStyle(
                  fontSize: 22.0,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold),
              isReverse: true,
              isTimerTextShown: true,
              onComplete: () {
                if (!mounted) return;
                setState(() {
                  Provider.of<AudioLocks>(context, listen: false)
                      .unlockCompletely(widget.userId, widget.audNum)
                      .then((_) {
                    if (!mounted) return;
                    setState(() {
                      final lockState =
                          Provider.of<AudioLocks>(context, listen: false);
                      final unlockedData =
                          lockState.unlockedModule(widget.audNum);
                    });
                    Navigator.of(context).pushReplacementNamed(
                        AudioDashboard.routeName,
                        arguments: {
                          'userId': widget.userId,
                          'audNum': widget.audNum
                        });
                  });
                });
              },
            ),
          ),
        );
      }),
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final lockState = Provider.of<AudioLocks>(context, listen: false);
    final unlockedData = lockState.unlockedModule(widget.audNum);
    final partiallyUnlocked = lockState.partiallyUnlocked(widget.audNum);
    return _isLoading
        ? Center(
            child: SpinKitThreeBounce(
              color: Color(0xFF56c590),
            ),
          )
        : Consumer<AudioLocks>(
            builder: (ctx, lock, child) => ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: GridTile(
                child: InkWell(
                  onTap: () {
                    if (unlockedData != null) {
                      Navigator.of(context).pushNamed(
                          AudioTestReportScreen.routename,
                          arguments: {
                            'userId': widget.userId,
                            'audNum': widget.audNum,
                          });
                    } else {
                      if (partiallyUnlocked) {
                        final timerData =
                            Provider.of<AudioLocks>(context, listen: false)
                                .findById(widget.audNum);
                        var unlockedTime = timerData.audUnlockedTime;
                        var limit = unlockedTime!.add(Duration(hours: 24));
                        var diff = DateTime.now().difference(limit);
                        diff >= Duration(seconds: 1)
                            ? setState(() {
                                if (!mounted) return;
                                setState(() {
                                  _isLoading = true;
                                });
                                _updateTimer(widget.userId, widget.audNum);
                                //if (!mounted) return;
                                Provider.of<AudioLocks>(context, listen: false)
                                    .fetchLocks(widget.userId)
                                    .then((value) {
                                  if (!mounted) return;
                                  setState(() {
                                    _isLoading = false;
                                  });
                                });
                              })
                            : _timerDialog(context, widget.audNum);
                      } else {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              widget.audName + '  Is Locked',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.solway(
                                  textStyle: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red)),
                            ),
                            duration: Duration(
                              seconds: 2,
                            ),
                          ),
                        );
                      }
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: widget.audName.trim() != "TOPIC TEST"
                          ? widget.audName.trim() == "FINAL TEST"
                              ? unlockedData != null
                                  ? Color(0xFF329D9c)
                                  : Colors.grey
                              : unlockedData != null
                                  ? Color(0xFF56c590)
                                  : Colors.grey
                          : unlockedData != null
                              ? Color(0xFF205072)
                              : Colors.grey,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        widget.audName.trim() == 'TOPIC TEST' ||
                                widget.audName.trim() == 'FINAL TEST'
                            ? Flexible(
                                flex: 2,
                                fit: FlexFit.tight,
                                child: Center(
                                  child: Text(
                                    widget.audName,
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              )
                            : Expanded(
                                flex: 1,
                                child: unlockedData != null
                                    ? SvgPicture.asset(
                                        'assets/images/parrot-unlock1.svg',
                                        fit: BoxFit.contain,
                                      )
                                    : SvgPicture.asset(
                                        'assets/images/parrot-lock.svg',
                                        fit: BoxFit.contain,
                                      ),
                              ),
                        unlockedData == null
                            ? Expanded(
                                child: Icon(
                                  Icons.lock_outline,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              )
                            : Text(''),
                        widget.audName.trim() == 'TOPIC TEST' ||
                                widget.audName.trim() == 'FINAL TEST'
                            ? Text('')
                            : Expanded(
                                child: Center(
                                  child: Text(
                                    widget.audName,
                                    style: TextStyle(
                                        fontSize: size.width * .0355,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                        widget.audName.trim() == 'TOPIC TEST' ||
                                widget.audName.trim() == 'FINAL TEST'
                            ? Text('')
                            : unlockedData != null
                                ? Expanded(
                                    child: Icon(
                                    Icons.chevron_right,
                                    size: 40,
                                    color: Colors.white,
                                  ))
                                : Text(''),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
