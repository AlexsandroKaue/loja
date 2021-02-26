import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lojavirtualv2/models/section.dart';
import 'package:lojavirtualv2/screens/home/components/item_tile.dart';
import 'package:lojavirtualv2/screens/home/components/section_header.dart';

class SectionStaggered extends StatelessWidget {
  final Section section;
  const SectionStaggered(this.section);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(section),
          SizedBox(
            child: StaggeredGridView.countBuilder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              crossAxisCount: 4,
              itemCount: section.items.length,
              itemBuilder: (BuildContext context, int index)
                => ItemTile(section.items[index]),
              staggeredTileBuilder: (int index)
                => StaggeredTile.count(2, index.isEven ? 2 : 1),
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
            )
          )
        ],
      ),
    );
  }
}
