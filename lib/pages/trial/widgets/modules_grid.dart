import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../widgets/module_item.dart';
import '../providers/modules.dart';
import '../providers/module_unlock.dart';
import '../models/module.dart';

class TrialModulesGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ModuleUnlock(),
        ),
        ChangeNotifierProvider(
          create: (context) => TrialModules(),
        ),
      ],
      child: ModuleGridElement(),
    );
  }
}

class ModuleGridElement extends StatefulWidget {
  @override
  _ModuleGridElementState createState() => _ModuleGridElementState();
}

class _ModuleGridElementState extends State<ModuleGridElement> {
  var _isInit = true;
  var _isLoading = false;
  //var finalTestId;
  //var userID = 10073;

  Future<void> _refreshModules(BuildContext context) async {
    final userID = ModalRoute.of(context)!.settings.arguments;
    int userId = int.parse(userID.toString());
    await Provider.of<ModuleUnlock>(context, listen: false).fetchLocks(userId);
  }

  // @override
  // void didChangeDependencies() {
  //   if (_isInit) {
  //     if (!mounted) return;
  //     setState(() {
  //       _isLoading = true;
  //     });
  //     final userID = ModalRoute.of(context).settings.arguments;
  //     int userId = int.parse(userID);
  //     print(userId);
  //     print(userId.runtimeType.toString());
  //     Provider.of<TrialModules>(context, listen: false).fetchLevel(userId).then(
  //           (level) => Provider.of<TrialModules>(context, listen: false)
  //               .fetchTrialModules()
  //               .then((_) {
  //             // Provider.of<ModuleUnlock>(context, listen: false)
  //             //     .fetchLocks(userId);
  //             // final modulesData = Provider.of<Modules>(context, listen: false);
  //             //List<Module> modules = modulesData.chapters;
  //             //final finalTestID = modules.last.modNum;
  //             //finalTestId = finalTestID;
  //           }).then(
  //             (_) {
  //               if (!mounted) return;
  //               setState(() {
  //                 _isLoading = false;
  //               });
  //             },
  //           ),
  //         );
  //   }
  //   _isInit = false;
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    final userID = ModalRoute.of(context)!.settings.arguments;
    int userId = int.parse(userID.toString());
    // int userId = userID;

    return
        // _isLoading
        //     ? Center(
        //         child: SpinKitCircle(
        //           color: Color(0xFF205072),
        //         ),
        //       )
        //     :
        StreamBuilder(
            stream: Stream.fromFuture(
                Provider.of<TrialModules>(context, listen: false)
                    .fetchTrialModules()),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Provider.of<ModuleUnlock>(context, listen: false)
                    .fetchLocks(userId);
                final modulesData =
                    Provider.of<TrialModules>(context, listen: false);
                List<Module> modules = modulesData.chapters;

                return RefreshIndicator(
                  onRefresh: () => _refreshModules(context),
                  backgroundColor: Color(0xFF205072),
                  child: GridView.builder(
                    padding: const EdgeInsets.all(10.0),
                    itemCount: modulesData.chapters.length,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      childAspectRatio: MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.height / 5.5),
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (ctx, i) => Consumer<TrialModules>(
                      builder: (context, value, child) => ModuleItem(
                        modules[i].modNum!,
                        modules[i].modOrder!,
                        modules[i].modName!,
                        userId,
                        modules[i].tNum!,
                        modules[i].modDescription!,
                        modules[i].modSpecialnote!,
                        //finalTestId,
                      ),
                    ),
                  ),
                );
              }
              return Center(
                child: SpinKitCircle(
                  color: Color(0xFF205072),
                ),
              );
            });
  }
}
