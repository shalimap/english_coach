import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:englishcoach/pages/Modules/screens/menu_dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../screens/module_detail_screen.dart';
import '../screens/finaltest-reportscreen.dart';
import '../screens/carousal.dart';
import '../providers/module_unlock.dart';
import '../providers/modules.dart';
import '../models/unlock.dart';

class ModuleItem extends StatefulWidget {
  final int modNum;
  final int modOrder;
  final String modName;
  final int userId;
  final int tNum;
  final int finalTestId;

  ModuleItem(this.modNum, this.modOrder, this.modName, this.userId, this.tNum,
      this.finalTestId);

  @override
  _ModuleItemState createState() => _ModuleItemState();
}

class _ModuleItemState extends State<ModuleItem> {
  var _isInit = true;
  var nullLock = false;
  List<Unlock>? previousModId;
  var moduleId;
  var unlockedCount;
  var remainingTime;
  var topic = false;
  var difference;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<ModuleUnlock>(context, listen: false)
          .fetchLocks(widget.userId)
          .then((lock) {
        if (lock.length == 0) {
          if (!mounted) return;
          setState(() {
            nullLock = true;
          });
        }
        Provider.of<ModuleUnlock>(context, listen: false)
            .fetchLocks(widget.userId)
            .then((count) => Provider.of<ModuleUnlock>(context, listen: false)
                .previous(widget.userId))
            .then((value) {
          previousModId = value;
          if (value.isNotEmpty) {
            if (!mounted) return;
            setState(() {
              moduleId = previousModId!.last.modNum;
            });
          }
        });
        if (nullLock) {
          if (widget.modOrder == 1 || widget.modOrder == 2) {
            var _introMod = Unlock(
              modNum: widget.modNum,
              userId: widget.userId,
              mLockOpenNow: 1,
              mLockUnlockedTime: DateTime.now(),
            );
            Provider.of<ModuleUnlock>(context, listen: false)
                .unLockNextModule(_introMod)
                .then((value) {
              Future.delayed(Duration(seconds: 3), () {
                Navigator.of(context).pushReplacementNamed(
                    MenuDashboardPage.routeName,
                    arguments: widget.userId.toString());
              });
            });
          }
        }
      }).then((_) {
        final lockState = Provider.of<ModuleUnlock>(context, listen: false);
        final partiallyUnlocked = lockState.partiallyUnlocked(widget.modNum);
        if (partiallyUnlocked) {
          final timerData = Provider.of<ModuleUnlock>(context, listen: false)
              .findById(widget.modNum);
          var unlockedTime = timerData.mLockUnlockedTime;
          var limit = unlockedTime!.add(Duration(hours: 24));
          var diff = DateTime.now().difference(limit);
          difference = diff;
          print('Difference : ' + diff.toString());
          diff >= Duration(seconds: 1)
              ? _updateTimer(widget.userId, widget.modNum)
              : print('');
        }
      });
    }
    if (widget.modName.trim() == 'TOPIC TEST' ||
        widget.modName.trim() == 'FINAL TEST') {
      topic = true;
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _updateTimer(int userId, int modNum) {
    Provider.of<ModuleUnlock>(context, listen: false)
        .updateTimer(userId, modNum);
  }

  void _timerDialog(BuildContext context, int modId) {
    final timerData =
        Provider.of<ModuleUnlock>(context, listen: false).findById(modId);
    var unlockedTime = timerData.mLockUnlockedTime;
    var limit = unlockedTime!.add(Duration(hours: 24));
    Duration remainingTime = limit.difference(DateTime.now());
    Size size = MediaQuery.of(context).size;
    var alertDialog = AlertDialog(
      title: Center(
          child: Text(
        'ദയവായി കാത്തിരിക്കുക',
        style: TextStyle(fontSize: 15),
      )),
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
                  Provider.of<ModuleUnlock>(context, listen: false)
                      .unlockCompletely(widget.userId, widget.modNum, 1)
                      .then((_) {
                    if (!mounted) return;
                    setState(() {
                      final lockState =
                          Provider.of<ModuleUnlock>(context, listen: false);
                      final unlockedData =
                          lockState.unlockedModule(widget.modNum);
                    });
                    Navigator.of(context).pushReplacementNamed(
                        MenuDashboardPage.routeName,
                        arguments: widget.userId.toString());
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
    final lockState = Provider.of<ModuleUnlock>(context, listen: false);
    final unlockedCount =
        Provider.of<ModuleUnlock>(context, listen: false).countLength;
    final unlockedData = lockState.unlockedModule(widget.modNum);
    final partiallyUnlocked = lockState.partiallyUnlocked(widget.modNum);
    final modulesList = Provider.of<Modules>(context, listen: false).chapters;
    return Consumer<ModuleUnlock>(
      builder: (ctx, lock, child) => ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
          child: InkWell(
            onTap: () {
              if (unlockedData != null) {
                widget.finalTestId == widget.modNum
                    ? Navigator.of(context).pushNamed(
                        TestReportScreen.routename,
                        arguments: widget.userId)
                    : widget.modOrder != 1
                        ? Navigator.of(context).pushNamed(
                            ModuleDetailScreen.routeName,
                            arguments: {
                              'modNum': widget.modNum,
                              'userId': widget.userId,
                              'unlockCount': unlockedCount,
                              'moduleList': modulesList,
                              'moduleLength': modulesList.length,
                              'topic': topic,
                            },
                          )
                        : Navigator.of(context)
                            .pushNamed(CarousalScreen.routeName);
              } else {
                if (partiallyUnlocked) {
                  final timerData =
                      Provider.of<ModuleUnlock>(context, listen: false)
                          .findById(widget.modNum);
                  var unlockedTime = timerData.mLockUnlockedTime;
                  var limit = unlockedTime!.add(Duration(hours: 24));
                  var diff = DateTime.now().difference(limit);
                  diff >= Duration(seconds: 1)
                      ? setState(() {
                          _updateTimer(widget.userId, widget.modNum);
                          if (!mounted) return;
                          Provider.of<ModuleUnlock>(context, listen: false)
                              .fetchLocks(widget.userId);
                        })
                      : _timerDialog(context, widget.modNum);
                } else {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        widget.modName + '  Is Locked',
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
                color: widget.modName.trim() != "TOPIC TEST"
                    ? widget.modName.trim() == "FINAL TEST"
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
                  widget.modName.trim() == 'TOPIC TEST' ||
                          widget.modName.trim() == 'FINAL TEST'
                      ? Flexible(
                          flex: 2,
                          fit: FlexFit.tight,
                          child: Center(
                            child: Text(
                              widget.modName,
                              style: TextStyle(
                                  fontSize: 18,
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
                  widget.modName.trim() == 'TOPIC TEST' ||
                          widget.modName.trim() == 'FINAL TEST'
                      ? Text('')
                      : Expanded(
                          child: Center(
                            child: Text(
                              widget.modName,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                  widget.modName.trim() == 'TOPIC TEST' ||
                          widget.modName.trim() == 'FINAL TEST'
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
