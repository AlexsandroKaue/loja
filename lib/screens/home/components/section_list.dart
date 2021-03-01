import 'package:flutter/material.dart';
import 'package:lojavirtualv2/models/home_manager.dart';
import 'package:lojavirtualv2/models/section.dart';
import 'package:lojavirtualv2/screens/home/components/add_tile_widget.dart';
import 'package:lojavirtualv2/screens/home/components/item_tile.dart';
import 'package:lojavirtualv2/screens/home/components/section_header.dart';
import 'package:provider/provider.dart';

class SectionList extends StatelessWidget {
  final Section section;
  const SectionList(this.section);

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
              height: 150,
              child: Consumer<Section>(
                builder: (_, section, __) {
                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (_, __) => const SizedBox(width: 4,),
                    itemCount: homeManager.editing
                        ? section.items.length+1
                        : section.items.length,
                    itemBuilder: (_, index) {
                      if(index < section.items.length) {
                        return ItemTile(section.items[index]);
                      } else {
                        return AddTileWidget();
                      }
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
