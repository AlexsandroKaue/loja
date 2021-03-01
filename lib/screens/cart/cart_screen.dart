import 'package:flutter/material.dart';
import 'package:lojavirtualv2/commom/price_card.dart';
import 'package:lojavirtualv2/models/cart_manager.dart';
import 'package:lojavirtualv2/models/user_manager.dart';
import 'package:lojavirtualv2/screens/cart/components/cart_tile.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrinho'),
        centerTitle: true,
      ),
      body: Consumer2<CartManager, UserManager>(
        builder: (_, cartManager, userManager, __){

          return userManager.isLoggedIn
            ? ListView(
              children: [
                Column(
                  children: cartManager.items.map((cartProduct) {
                    return CartTile(cartProduct);
                  }).toList(),
                ),
                PriceCard(
                  onPressed: cartManager.isCartValid ? (){
                    Navigator.of(context).pushNamed('/address');
                  } : null,
                  buttonText: 'Continuar para entrega',
                )
              ],
            ) : Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.remove_shopping_cart,
                  size: 80.0,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox( height: 16.0,),
                const Text(
                  "Faça login para acessar seu carrinho!",
                  style:
                  TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16.0,),
                Container(
                  height: 45.0,
                  child: RaisedButton(
                      textColor: Colors.white,
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        Navigator.of(context).pushNamed('/login');
                      },
                    child: const Text(
                      "Entrar",
                      style: TextStyle(fontSize: 18.0),
                    )
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
