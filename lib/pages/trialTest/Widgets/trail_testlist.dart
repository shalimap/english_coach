import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/trial_tests.dart';
import '../Widgets/trail_test_tile.dart';

class TrailTestList extends StatelessWidget {
  final int userId;
  final int modId;

  TrailTestList(this.modId, this.userId);
  @override
  Widget build(BuildContext context) {
    final testsData =
        Provider.of<TrialTest>(context, listen: false).findByUsrId(userId);
    return ListView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: testsData.length,
      itemBuilder: (ctx, i) => TrailTestTile(
        testsData[i].testId!,
        testsData[i].modId!,
        testsData[i].userId!,
        testsData[i].mcqPoints!,
        testsData[i].status!,
        i,
      ),
    );
  }
}
