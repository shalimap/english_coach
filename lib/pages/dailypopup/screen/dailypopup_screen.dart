import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/popuplists.dart';
import '../provider/dailypopups.dart';

import '../model/dailypopup.dart';
import '../model/popuplist.dart';

class DailyPopUpScreen extends StatefulWidget {
  static const routeName = '/dailypopup';
  DailyPopUpScreen({Key? key}) : super(key: key);

  @override
  _DailyPopUpScreenState createState() => _DailyPopUpScreenState();
}

class _DailyPopUpScreenState extends State<DailyPopUpScreen> {
  var _isInit = true;
  var _nullPops = false;
  var popup = DailyPopUp(
    popupId: null,
    userId: null,
    dateTime: null,
    count: null,
  );
  var firstPopupId = 1;
  List<DailyPopUp>? currentPopupData;
  var currentPopupId;
  List<PopUpList>? showPopup;
  var difference;

  void _showPopup(BuildContext context, url) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Flex(
              direction: Axis.horizontal,
              children: [
                Expanded(
                  child: Image.network(url),
                ),
              ],
            ),
          );
        });
  }

  @override
  void didChangeDependencies() {
    final userID = ModalRoute.of(context)!.settings.arguments;
    int userId = int.parse(userID.toString());
    if (_isInit) {
      Provider.of<PopUpLists>(context, listen: false).fetchPopupList().then(
        (_) {
          Provider.of<DailyPopUps>(context, listen: false)
              .fetchDailyPopUps(userId)
              .then(
            (popupData) {
              if (popupData.isEmpty) {
                _nullPops = true;
              }
              if (popupData.isNotEmpty) {
                currentPopupData = popupData;
                currentPopupId = popupData[0].popupId;
                print('current-id');
              }
            },
          ).then(
            (_) {
              if (_nullPops) {
                print('Null Pops');
                popup = DailyPopUp(
                  popupId: firstPopupId,
                  userId: userId,
                  dateTime: DateTime.now(),
                  count: 1,
                );
                Provider.of<DailyPopUps>(context, listen: false)
                    .addPopup(popup);
                showPopup = Provider.of<PopUpLists>(context, listen: false)
                    .findPopupById(firstPopupId);
                _showPopup(context, showPopup![0].popupUrl);
                print('Show-first-popup');
              } else {
                print('Pops Exists');
                print('current-id-call');
                showPopup = Provider.of<PopUpLists>(context, listen: false)
                    .randomPopup(currentPopupId);
                var previousTime = currentPopupData![0].dateTime;
                var limit = previousTime!.add(Duration(hours: 24));
                var diff = DateTime.now().difference(limit);
                difference = diff;
                print('Difference : ' + diff.toString());
                diff >= Duration(seconds: 1)
                    ? _showPopup(context, showPopup![0].popupUrl)
                    : print('No Popup');
                if (diff >= Duration(seconds: 1)) {
                  Provider.of<DailyPopUps>(context, listen: false)
                      .updatePopupData(
                    userId,
                    showPopup![0].popupId!,
                    currentPopupData![0].count! + 1,
                    DateTime.now(),
                  );
                  print('popup-updated');
                }
              }
            },
          );
        },
      );
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Current UI'),
      ),
    );
  }
}
