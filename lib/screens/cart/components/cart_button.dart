import 'package:flutter/material.dart';

class CartButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.white,
      onPressed: (){
        Navigator.of(context).pushNamed('/cart');
      },
      child: Icon(Icons.shopping_cart, color: Theme.of(context).primaryColor),
    );
  }
}
