import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lojavirtualv2/models/home_manager.dart';
import 'package:lojavirtualv2/models/section.dart';
import 'package:lojavirtualv2/screens/home/components/add_tile_widget.dart';
import 'package:lojavirtualv2/screens/home/components/item_tile.dart';
import 'package:lojavirtualv2/screens/home/components/section_header.dart';
import 'package:provider/provider.dart';

class SectionStaggered extends StatelessWidget {
  final Section section;
  const SectionStaggered(this.section);

  @override
  Widget build(BuildContext context) {
    final homeManager = context.watch<HomeManager>();
    final sections = homeManager.sections;

    return ChangeNotifierProvider.value(
      value: section,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
              key: ObjectKey(section),
              onMoveUp: section != sections.first ? (){
                homeManager.onMoveUp(section);
              } : null,
              onMoveDown: section != sections.last ? (){
                homeManager.onMoveDown(section);
              } : null,
            ),
            SizedBox(
              child: Consumer<Section>(
                builder: (_, section, __) {
                  return StaggeredGridView.countBuilder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 4,
                    itemCount: homeManager.editing
                        ? section.items.length+1
                        : section.items.length,
                    itemBuilder: (BuildContext context, int index){
                      if(index < section.items.length) {
                        return ItemTile(section.items[index]);
                      } else {
                        return AddTileWidget();
                      }
                    },
                    staggeredTileBuilder: (int index)
                    => StaggeredTile.count(2, index.isEven ? 2 : 1),
                    mainAxisSpacing: 4.0,
                    crossAxisSpacing: 4.0,
                  );
                },
              )
            )
          ],
        ),
      ),
    );
  }
}
