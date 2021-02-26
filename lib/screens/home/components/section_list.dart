import 'package:flutter/material.dart';
import 'package:lojavirtualv2/models/section.dart';
import 'package:lojavirtualv2/screens/home/components/item_tile.dart';
import 'package:lojavirtualv2/screens/home/components/section_header.dart';

class SectionList extends StatelessWidget {
  final Section section;
  const SectionList(this.section);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(section),
          SizedBox(
            height: 150,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              separatorBuilder: (_, __) => const SizedBox(width: 4,),
              itemCount: section.items.length,
              itemBuilder: (_, index) {
                return ItemTile(section.items[index]);
              },

            ),
          )
        ],
      ),
    );
  }
}
