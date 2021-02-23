import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtualv2/models/product.dart';
import 'package:lojavirtualv2/models/user_manager.dart';
import 'package:lojavirtualv2/screens/products/components/size_widget.dart';
import 'package:provider/provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;
  const ProductDetailsScreen(this.product);

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return ChangeNotifierProvider<Product>.value(
      value: product,
      child: Scaffold(
        appBar: AppBar(
          title: Text(product.title),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: ListView(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Carousel(
                images: product.images.map((url) {
                  return NetworkImage(url);
                }).toList(),
                dotSize: 4,
                dotSpacing: 15,
                dotColor: primaryColor,
                dotBgColor: Colors.transparent,
                autoplay: false,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(product.title,
                    style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600)
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text('A partir de',
                        style: TextStyle(
                            fontSize: 13.0,
                            color: Colors.grey[600])
                    ),
                  ),
                  Text('R\$ 19.90',
                      style: TextStyle(
                          fontSize: 22.0,
                          color: primaryColor,
                          fontWeight: FontWeight.bold)
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top:16.0, bottom: 8.0),
                    child: Text(
                      'Descrição',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                  ),
                  Text(
                    product.description,
                    style: const TextStyle(
                        fontSize: 16.0
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top:16.0, bottom: 8.0),
                    child: Text(
                      'Tamanhos',
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                  ),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: product.sizes.map((s) {
                      return SizeWidget(s);
                    }).toList(),
                  ),
                  const SizedBox(height: 20,),
                  if(product.hasStock)
                    Consumer2<UserManager, Product>(
                      builder: (_, userManager, product, __){
                        return SizedBox(
                          height: 44,
                          child: RaisedButton(
                            onPressed: product.selectedSize != null
                              ? (){
                                if(userManager.isLoggedIn){
                                  //TODO: ADICIONAR AO CARRINHO
                                } else {
                                  Navigator.of(context).pushNamed('/login');
                                }
                              }
                              : null,
                            color: primaryColor,
                            textColor: Colors.white,
                            child: Text(userManager.isLoggedIn
                              ? 'Adicionar ao Carrinho'
                              : 'Entre para Comprar',
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        );
                      },
                    )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
