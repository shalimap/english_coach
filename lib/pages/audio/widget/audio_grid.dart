import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../widget/audio_item.dart';
import '../provider/audios.dart';
import '../model/audio.dart';
import '../provider/audiolocks.dart';

class AudioGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ModuleGridElement();
  }
}

class ModuleGridElement extends StatefulWidget {
  @override
  _ModuleGridElementState createState() => _ModuleGridElementState();
}

class _ModuleGridElementState extends State<ModuleGridElement> {
  var _isInit = true;
  var _isLoading = false;

  Future<void> _refreshAudios(BuildContext context) async {
    final userID = ModalRoute.of(context)!.settings.arguments;
    int userId = int.parse(userID.toString());
    await Provider.of<AudioLocks>(context, listen: false).fetchLocks(userId);
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      if (!mounted) return;
      setState(() {
        _isLoading = true;
      });
      Provider.of<Audios>(context, listen: false).fetchAudios().then((_) {
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
    final userID = ModalRoute.of(context)!.settings.arguments;
    int userId = int.parse(userID.toString());
    final audioData = Provider.of<Audios>(context, listen: false);
    List<Audio> audio = audioData.audios;

    return _isLoading
        ? Center(
            child: SpinKitCircle(
              color: Color(0xFF205072),
            ),
          )
        : RefreshIndicator(
            onRefresh: () => _refreshAudios(context),
            backgroundColor: Color(0xFF205072),
            child: GridView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: audioData.audios.length,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: MediaQuery.of(context).size.width /
                    (MediaQuery.of(context).size.height / 5.5),
                mainAxisSpacing: 10,
              ),
              itemBuilder: (ctx, i) => Consumer<Audios>(
                builder: (context, value, child) => AudioItem(
                  audio[i].audNum!,
                  audio[i].audName!,
                  audio[i].audLevel!,
                  userId,
                ),
              ),
            ),
          );
  }
}
