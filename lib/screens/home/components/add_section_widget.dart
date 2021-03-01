import 'package:flutter/material.dart';
import 'package:lojavirtualv2/models/home_manager.dart';
import 'package:lojavirtualv2/models/section.dart';

class AddSectionWidget extends StatelessWidget {
  final HomeManager homeManager;
  const AddSectionWidget(this.homeManager);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FlatButton(
            textColor: Colors.white,
            onPressed: (){
              homeManager.addSection(Section(type: 'List'));
            },
            child: const Text(
              'Adicionar Lista',
              style: TextStyle(
                color: Colors.white
              ),
            )
          ),
        ),
        Expanded(
          child: FlatButton(
            textColor: Colors.white,
            onPressed: (){
              homeManager.addSection(Section(type: 'Staggered'));
            },
            child: const Text(
              'Adicionar Grade',
              style: TextStyle(),
            )
          ),
        ),
      ],
    );
  }
}
