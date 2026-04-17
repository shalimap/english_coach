import '../providers/topictest_tests.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/module_test_tile.dart';
import '../providers/module_tests.dart';

class ModuleTestList extends StatelessWidget {
  final int moduleId;
  final bool topic;
  final int tNum;
  final int userId;

  ModuleTestList(this.moduleId, this.topic, this.tNum, this.userId);
  @override
  Widget build(BuildContext context) {
    final testsData =
        Provider.of<ModuleTests>(context, listen: false).findByModId(moduleId);
    final testData =
        Provider.of<TopicTests>(context, listen: false).findByTopicId(tNum);
    return ListView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: topic ? testData.length : testsData.length,
      itemBuilder: (ctx, i) => topic
          ? ModuleTestTile(
              testData[i].ttestId!,
              testData[i].modId!,
              testData[i].userId!,
              testData[i].ttestPoints!,
              i,
              topic,
              tNum,
            )
          : ModuleTestTile(
              testsData[i].mTestId!,
              testsData[i].modNum!,
              testsData[i].userId!,
              testsData[i].mTestPoints!,
              i,
              topic,
              tNum,
            ),
    );
  }
}
