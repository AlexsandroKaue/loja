import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtualv2/models/section.dart';
import 'package:lojavirtualv2/models/section_item.dart';
import 'package:lojavirtualv2/screens/edit_product/components/image_source_sheet.dart';
import 'package:provider/provider.dart';

class AddTileWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final section  = context.watch<Section>();

    void onImageSelected(File file) {
      section.addItem(SectionItem(image: file));
      Navigator.of(context).pop();
    }

    return GestureDetector(
      onTap: (){
        if(Platform.isAndroid) {
          showBottomSheet(
              context: context,
              builder: (context) => ImageSourceSheet(
                onImageSelected: onImageSelected,
              )
          );
        } else {
          showCupertinoModalPopup(
              context: context,
              builder: (_) => ImageSourceSheet(
                onImageSelected: onImageSelected,
              )
          );
        }
      },
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          color: Colors.white.withAlpha(20),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
