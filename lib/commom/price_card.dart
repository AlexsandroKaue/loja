import 'package:flutter/material.dart';
import 'package:lojavirtualv2/models/cart_manager.dart';
import 'package:provider/provider.dart';

class PriceCard extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;
  const PriceCard({this.onPressed, this.buttonText});

  @override
  Widget build(BuildContext context) {
    final cartManager = context.watch<CartManager>();
    final productsPrice = cartManager.productsPrice;
    final deliveryPrice = cartManager.deliveryPrice;
    final totalPrice = cartManager.totalPrice;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Resumo do Pedido',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16
              )
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Subtotal'),
                Text('R\$ ${productsPrice.toStringAsFixed(2)}'),
              ],
            ),
            const SizedBox(height: 12,),
            if(deliveryPrice != null)
              ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Entrega'),
                    Text('R\$ ${deliveryPrice.toStringAsFixed(2)}'),
                  ],
                ),
                const Divider(),
              ],
            const SizedBox(height: 12,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(
                    fontWeight: FontWeight.w500
                  ),
                ),
                Text('R\$ ${totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 17
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8,),
            RaisedButton(
              onPressed: onPressed,
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              disabledColor: Theme.of(context).primaryColor.withAlpha(100),
              child: Text(
                buttonText,
                style: const TextStyle(fontSize: 16),
              ),
            )
          ],
        ),
      ),
    );
  }
}
