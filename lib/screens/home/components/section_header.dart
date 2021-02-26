import 'package:flutter/material.dart';
import 'package:lojavirtualv2/models/section.dart';

class SectionHeader extends StatelessWidget {
  final Section section;
  const SectionHeader(this.section);

  @override
  Widget build(BuildContext context) {
    return Container(
    padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(section.name,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 18
        ),
      ),
    );
  }
}
