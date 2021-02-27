import 'package:flutter/material.dart';
import 'package:lojavirtualv2/commom/custom_drawer.dart';
import 'package:lojavirtualv2/models/product.dart';
import 'package:lojavirtualv2/models/product_manager.dart';
import 'package:lojavirtualv2/models/user_manager.dart';
import 'package:lojavirtualv2/screens/cart/components/cart_button.dart';
import 'package:lojavirtualv2/screens/products/components/product_list_tile.dart';
import 'package:lojavirtualv2/screens/products/components/search_dialog.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<ProductManager>(
          builder: (_, productManager, __){
            if(productManager.search.isEmpty){
              return const Text('Produtos');
            } else {
              return LayoutBuilder(
                builder: (_, boxConstraints){
                  // ignore: sized_box_for_whitespace
                  return Container(
                    width: boxConstraints.maxWidth,
                    child: GestureDetector(
                        onTap: () async {
                          final String term = await showDialog(context: context,
                            builder: (
                                context) => SearchDialog(productManager.search));
                          if(term != null){
                            productManager.search = term;
                          }
                        },
                        child: Text(productManager.search, textAlign: TextAlign.center,)
                    ),
                  );
                },
              );
            }
          },
          child: const Text('Produtos')
        ),
        centerTitle: true,
        actions: [
          Consumer<ProductManager>(
            builder: (_, productManager, __){
              if(productManager.search.isEmpty) {
                return IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () async {
                    //Pega termo que retornou da pesquisa
                    final String term = await showDialog(context: context,
                      builder: (context) => SearchDialog(productManager.search));
                    if(term != null){
                      productManager.search = term;
                    }
                  },
                );
              } else {
                return IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () async {
                    productManager.search = '';
                  },
                );
              }
            },
          ),
          Consumer<UserManager>(
            builder: (_, userManager, __) {
              if(userManager.adminEnabled) {
                return IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: (){
                      Navigator.of(context)
                          .pushNamed( '/edit-product');
                    }
                );
              } else {
                return Container();
              }
            },
          )
        ],
      ),
      drawer: CustomDrawer(),
      body: Consumer<ProductManager>(
        builder: (_, productManager, __) {
          final filteredProducts = productManager.filteredProducts;
          return ListView.builder(
            padding: const EdgeInsets.all(4.0),
            itemCount: filteredProducts.length,
            itemBuilder: (_, index) {
              return ProductListTile(filteredProducts[index]);
            },
          );
        },
      ),
      floatingActionButton: CartButton(),
    );
  }
}
