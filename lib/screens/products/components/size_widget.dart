import 'package:flutter/material.dart';
import 'package:lojavirtualv2/models/item_size.dart';
import 'package:lojavirtualv2/models/product.dart';
import 'package:provider/provider.dart';

class SizeWidget extends StatelessWidget {
  final ItemSize size;
  const SizeWidget(this.size);

  @override
  Widget build(BuildContext context) {
    final product = context.watch<Product>();
    final selected = size == product.selectedSize;
    print(selected);

    Color color;
    if(!size.hasStock) {
      color = Colors.red.withAlpha(50);
    } else if(selected){
      color = Theme.of(context).primaryColor;
    } else {
      color = Colors.grey;
    }

    return GestureDetector(
      onTap: (){
        product.selectedSize = size;
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: color
          )
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              color: color,
              child: Text(size.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'R\$ ${size.price}',
                style: TextStyle(
                  fontSize: 16,
                  color: color,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
