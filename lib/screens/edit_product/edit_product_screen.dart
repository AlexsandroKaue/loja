import 'package:flutter/material.dart';
import 'package:lojavirtualv2/models/product.dart';
import 'package:lojavirtualv2/screens/edit_product/components/images_form.dart';

class EditProductScreen extends StatelessWidget {
  final Product product;
  const EditProductScreen(this.product);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Anúncio'),
        centerTitle: true,
      ),body: ImagesForm(product),
    );
  }
}
