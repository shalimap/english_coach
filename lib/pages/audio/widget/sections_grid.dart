import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../widget/section_item.dart';
import '../provider/sections.dart';
import '../model/section.dart';

class SectionsGrid extends StatelessWidget {
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
  var sections;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      if (!mounted) return;
      setState(() {
        _isLoading = true;
      });
      Provider.of<Sections>(context, listen: false).fetchSections().then((_) {
        final sectionData = Provider.of<Sections>(context, listen: false);
        List<Section> section = sectionData.sections;
        setState(() {
          sections = section;
        });
      }).then((_) {
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
    return _isLoading
        ? Center(
            child: SpinKitCircle(
              color: Color(0xFF205072),
            ),
          )
        : StaggeredGridView.countBuilder(
            crossAxisCount: 4,
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
            staggeredTileBuilder: (index) => StaggeredTile.fit(2),
            scrollDirection: Axis.vertical,
            itemCount: sections.length,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (ctx, i) => Consumer<Sections>(
              builder: (context, value, child) => SectionItem(
                sections[i].secId,
                sections[i].secName,
              ),
            ),
          );
  }
}
