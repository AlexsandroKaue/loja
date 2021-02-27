import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lojavirtualv2/models/product.dart';
import 'package:lojavirtualv2/models/product_manager.dart';
import 'package:lojavirtualv2/screens/edit_product/components/images_form.dart';
import 'package:lojavirtualv2/screens/edit_product/components/sizes_form.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatelessWidget {
  final Product product;
  final bool editing;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  EditProductScreen(Product p)
      : editing = p != null,
        product = p != null ? p.clone() : Product();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return ChangeNotifierProvider<Product>.value(
      value: product,
      child: Scaffold(
        appBar: AppBar(
          title: Text('${editing ? 'Editar' : 'Criar'} Produto'),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: Form(
          key: formKey,
          child: ListView(
            children: [
              ImagesForm(product),
              Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        initialValue: product.title,
                        decoration: const InputDecoration(
                            border: InputBorder.none, hintText: 'Título'),
                        style: const TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.w600),
                        validator: (title) {
                          if (title.length < 6) {
                            return 'Título muito curto';
                          }
                          return null;
                        },
                        onSaved: (title) => product.title = title,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text('A partir de',
                            style: TextStyle(
                                fontSize: 13.0, color: Colors.grey[600])),
                      ),
                      Text('R\$ ...',
                          style: TextStyle(
                              fontSize: 22.0,
                              color: primaryColor,
                              fontWeight: FontWeight.bold)),
                      const Padding(
                        padding: EdgeInsets.only(top: 16.0),
                        child: Text(
                          'Descrição',
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.w500),
                        ),
                      ),
                      TextFormField(
                        initialValue: product.description,
                        decoration: const InputDecoration(
                            border: InputBorder.none, hintText: 'Descrição'),
                        style: const TextStyle(fontSize: 16.0),
                        maxLines: null,
                        validator: (description) {
                          if (description.length < 10) {
                            return 'Descrição muito curta';
                          }
                          return null;
                        },
                        onSaved: (description) =>
                            product.description = description,
                      ),
                      SizesForm(product),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 44,
                        child: Consumer<Product>(
                          builder: (_, product, __) {
                            return RaisedButton(
                              onPressed: !product.loading
                                  ? () async {
                                      if (formKey.currentState.validate()) {
                                        formKey.currentState.save();
                                        await product.save();
                                        context.read<ProductManager>()
                                            .update(product);
                                      }
                                    }
                                  : null,
                              textColor: Colors.white,
                              color: primaryColor,
                              disabledColor: primaryColor.withAlpha(100),
                              child: product.loading
                                  ? const CircularProgressIndicator(
                                      valueColor:
                                          AlwaysStoppedAnimation(Colors.white),
                                    )
                                  : const Text(
                                      'Salvar',
                                      style: TextStyle(fontSize: 18),
                                    ),
                            );
                          },
                        ),
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
