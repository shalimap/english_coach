import 'package:englishcoach/pages/trial/providers/modules.dart';
import 'package:flutter/material.dart';

import '../../../config/responsive.dart';
import '../screens/menu_dashboard_page.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../screens/module_detail_screen.dart';

import '../providers/module_unlock.dart';
import '../models/unlock.dart';

class ModuleItem extends StatefulWidget {
  final int modNum;
  final int modOrder;
  final String modName;
  final int userId;
  final int tNum;
  final String modDescription;
  final String modSpecialnote;

  ModuleItem(this.modNum, this.modOrder, this.modName, this.userId, this.tNum,
      this.modDescription, this.modSpecialnote);

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
  var topic;
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
          if (widget.modOrder == 1) {
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
                    TrialDashboardPage.routeName,
                    arguments: widget.userId.toString());
              });
            });
          }
        }
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final lockState = Provider.of<ModuleUnlock>(context, listen: false);
    final unlockedCount =
        Provider.of<ModuleUnlock>(context, listen: false).countLength;
    final unlockedData = lockState.unlockedModule(widget.modNum);
    final partiallyUnlocked = lockState.partiallyUnlocked(widget.modNum);
    final modulesList =
        Provider.of<TrialModules>(context, listen: false).chapters;
    final loadedModule =
        Provider.of<TrialModules>(context).findById(widget.modNum);

    return Consumer<ModuleUnlock>(
      builder: (ctx, lock, child) => ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
          child: InkWell(
            onTap: () {
              if (unlockedData != null) {
                Navigator.of(context).pushNamed(
                  TrialModuleDetailScreen.routeName,
                  arguments: {
                    'modNum': widget.modNum,
                    'userId': widget.userId,
                    'unlockCount': unlockedCount,
                    'moduleList': modulesList,
                    'moduleLength': modulesList.length,
                    'loadedModule': loadedModule,
                  },
                );
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
                                  fontSize: Responsive.isDesktop(context)
                                      ? 18
                                      : Responsive.isTablet(context)
                                          ? 20
                                          : 25,
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
                                  fontSize: Responsive.isDesktop(context)
                                      ? 18
                                      : Responsive.isTablet(context)
                                          ? 20
                                          : 25,
                                  // size.width * .0355,
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
