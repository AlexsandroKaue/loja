import 'package:flutter/material.dart';
import 'package:lojavirtualv2/commom/custom_icon_button.dart';
import 'package:lojavirtualv2/models/home_manager.dart';
import 'package:lojavirtualv2/models/section.dart';
import 'package:provider/provider.dart';

class SectionHeader extends StatelessWidget {

  final VoidCallback onRemove;
  final VoidCallback onMoveUp;
  final VoidCallback onMoveDown;
  const SectionHeader({Key key, this.onMoveDown, this.onMoveUp,
    this.onRemove}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final section = context.watch<Section>();
    final homeManager = context.watch<HomeManager>();

    if(homeManager.editing) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: section.name,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Título',
                  ),
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 18
                  ),
                  onChanged: (text) => section.name = text,
                ),
              ),
              CustomIconButton(
                color: Colors.white,
                iconData: Icons.remove,
                onTap: () {
                  homeManager.removeSection(section);
                },
              ),
              CustomIconButton(
                iconData: Icons.arrow_drop_up,
                color: Colors.white,
                onTap: onMoveUp,
              ),
              CustomIconButton(
                iconData: Icons.arrow_drop_down,
                color: Colors.white,
                onTap: onMoveDown,
              )
            ],
          ),
          if(section.error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                color: Colors.white,
                child: Text(
                  section.error,
                  style: const TextStyle(
                    color: Colors.red
                  ),),
              ),
            )
        ],
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          section.name ?? 'Teste',
          style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 18
          ),
        ),
      );
    }
  }
}
