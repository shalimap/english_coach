import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widget/audio_testtile.dart';
import '../provider/audiotests.dart';

class AudioTestList extends StatelessWidget {
  final int userId;

  AudioTestList(this.userId);
  @override
  Widget build(BuildContext context) {
    final testsData =
        Provider.of<AudioTests>(context, listen: false).audioTests;
    return ListView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: testsData.length,
      itemBuilder: (ctx, i) => AudioTestTile(
          testsData[i].audTestId!,
          testsData[i].userId!,
          testsData[i].audNum!,
          testsData[i].score!,
          testsData[i].status!,
          i),
    );
  }
}
