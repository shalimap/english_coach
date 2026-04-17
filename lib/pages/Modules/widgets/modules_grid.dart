import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../widgets/module_item.dart';
import '../providers/modules.dart';
import '../providers/module_unlock.dart';
import '../models/module.dart';

class ModulesGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ModuleUnlock(),
        ),
        ChangeNotifierProvider(
          create: (context) => Module(),
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
  // var _isLoading = false;
  var _isLoading = true;
  var finalTestId;

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
  //     Provider.of<Modules>(context, listen: false).fetchLevel(userId).then(
  //           (level) => Provider.of<Modules>(context, listen: false)
  //               .fetchModules(level)
  //               .then((_) {
  //             final modulesData = Provider.of<Modules>(context, listen: false);
  //             List<Module> modules = modulesData.chapters;
  //             final finalTestID = modules.last.modNum;
  //             finalTestId = finalTestID;
  //           }).then(
  //             (_) {
  //               if (!mounted) return;
  // setState(() {
  //   _isLoading = false;
  // });
  //             },
  //           ),
  //         );
  //   }
  //   _isInit = false;
  //   super.didChangeDependencies();
  // }
  var modulesData;
  List<Module>? modules;

  @override
  Widget build(BuildContext context) {
    final userID = ModalRoute.of(context)!.settings.arguments;
    int userId = int.parse(userID.toString());
    // final modulesData = Provider.of<Modules>(context, listen: false);
    // List<Module> modules = modulesData.chapters;

    return StreamBuilder(
      stream: Stream.fromFuture(
          Provider.of<Modules>(context, listen: false).fetchLevel(userId)),
      builder: (context, snapshot) {
        var level = snapshot.data;
        if (snapshot.hasData) {
          Provider.of<Modules>(context, listen: false)
              .fetchModules(level.toString())
              .then((_) {
            modulesData = Provider.of<Modules>(context, listen: false);
            modules = modulesData.chapters;
            final finalTestID = modules!.last.modNum;
            finalTestId = finalTestID;
          }).then((_) {
            setState(() {
              _isLoading = false;
            });
          });
          return !_isLoading
              ? RefreshIndicator(
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
                    itemBuilder: (ctx, i) => Consumer<Modules>(
                      builder: (context, value, child) => ModuleItem(
                        modules![i].modNum!,
                        modules![i].modOrder!,
                        modules![i].modName!,
                        userId,
                        modules![i].tNum!,
                        finalTestId,
                      ),
                    ),
                  ),
                )
              : Center(
                  child: SpinKitCircle(
                    color: Color(0xFF205072),
                  ),
                );
        }
        return Center(
          child: SpinKitCircle(
            color: Color(0xFF205072),
          ),
        );
      },
    );
  }
}
