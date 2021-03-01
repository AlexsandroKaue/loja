import 'package:flutter/material.dart';
import 'package:lojavirtualv2/models/product_manager.dart';
import 'package:lojavirtualv2/models/section_item.dart';
import 'package:provider/provider.dart';

class SelectProductScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final products = context.read<ProductManager>().allProducts;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vincular Produto'),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: ListView.separated(
        itemBuilder: (_, index) {
          final product = products[index];
          return ListTile(
            leading: Image.network(product.images.first),
            title: Text(product.title),
            subtitle: Text('R\$ ${product.basePrice.toStringAsFixed(2)}'),
            onTap: () {
              Navigator.of(context).pop(product);
            },
          );
        },
        separatorBuilder: (_, index){
          return const Divider();
        },
        itemCount: products.length
      ),
    );
  }
}
