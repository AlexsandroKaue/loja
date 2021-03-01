import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lojavirtualv2/models/home_manager.dart';
import 'package:lojavirtualv2/models/product.dart';
import 'package:lojavirtualv2/models/product_manager.dart';
import 'package:lojavirtualv2/models/section.dart';
import 'package:lojavirtualv2/models/section_item.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:provider/provider.dart';

class ItemTile extends StatelessWidget {
  final SectionItem item;

  const ItemTile(this.item);

  @override
  Widget build(BuildContext context) {
    final homeManager = context.watch<HomeManager>();

    return GestureDetector(
      onTap: () {
        if (item.product != null) {
          final product = context.read<ProductManager>()
              .findProductByID(item.product);
          if (product != null) {
            Navigator.of(context)
                .pushNamed('/product-details', arguments: product);
          }
        }
      },
      onLongPress: homeManager.editing
          ? (){
            showDialog(context: context, builder: (_) {
              final product = context.read<ProductManager>()
                  .findProductByID(item.product);
              return AlertDialog(
                title: const Text('Editar Anúncio'),
                content: product != null
                  ? ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Image.network(product.images.first),
                    title: Text(product.title),
                    subtitle: Text('R\$ ${product.basePrice.toStringAsFixed(2)}'),
                  )
                  : null,
                actions: [
                  FlatButton(
                    onPressed: (){
                      context.read<Section>().removeItem(item);
                      Navigator.of(context).pop();
                    },
                    textColor: Colors.red,
                    child: const Text('Excluir'),
                  ),
                  FlatButton(
                      onPressed: () async {
                        if(product != null) {
                          item.product = null;
                        } else {
                          final product = await Navigator.of(context)
                              .pushNamed('/select-product') as Product;
                          item.product = product?.id;
                        }
                        Navigator.of(context).pop();
                      },
                      child: Text(product != null ? 'Desvincular':'Vincular'),
                  )
                ],
              );
            });
          }
          : null,
      child: AspectRatio(
          aspectRatio: 1,
          child: item.image is String
              ? FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: item.image as String,
                  fit: BoxFit.cover,
                )
              : Image.file(item.image as File, fit: BoxFit.cover,)
      ),
    );
  }
}
