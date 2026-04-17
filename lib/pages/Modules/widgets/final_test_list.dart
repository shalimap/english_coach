import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/final_test_tile.dart';
import '../providers/final_test_tests.dart';

class FinalTestList extends StatelessWidget {
  final int userId;

  FinalTestList(this.userId);
  @override
  Widget build(BuildContext context) {
    final testsData = Provider.of<FinalTestChecks>(context, listen: false)
        .findByUsrId(userId);
    return ListView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: testsData.length,
      itemBuilder: (ctx, i) => FinalTestTile(
          testsData[i].finalTestId!,
          testsData[i].userId!,
          testsData[i].finalTestPoints!,
          testsData[i].finalStatus!,
          i),
    );
  }
}
