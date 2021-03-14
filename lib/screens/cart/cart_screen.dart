import 'package:flutter/material.dart';
import 'package:lojavirtualv2/commom/empty_card.dart';
import 'package:lojavirtualv2/commom/login_card.dart';
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

          if(!userManager.isLoggedIn) {
            return LoginCard();
          }

          if(cartManager.items.isEmpty) {
            return const EmptyCard(
              text: 'O carrinho está vazio',
              iconData: Icons.remove_shopping_cart
            );
          }

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
            ) : LoginCard();
        },
      ),
    );
  }
}
