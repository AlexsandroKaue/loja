import 'package:flutter/material.dart';
import 'package:lojavirtualv2/models/product_manager.dart';
import 'package:lojavirtualv2/models/section_item.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';


class ItemTile extends StatelessWidget {
  final SectionItem item;
  const ItemTile(this.item);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if(item.product != null) {
          final product = context.read<ProductManager>()
              .findProductByID(item.product);
          if(product != null) {
            Navigator.of(context)
                .pushNamed('/product-details', arguments: product);
          }
        }
      },
      child: AspectRatio(
          aspectRatio: 1,
          child: FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            image: item.image,
            fit: BoxFit.cover,
          )
      ),
    );
  }
}
