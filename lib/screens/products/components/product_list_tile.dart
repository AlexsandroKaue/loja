import 'package:flutter/material.dart';
import 'package:lojavirtualv2/models/product.dart';

class ProductListTile extends StatelessWidget {
  final Product product;
  const ProductListTile(this.product);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: InkWell (
        onTap: (){
          Navigator.of(context).pushNamed(
            '/product-details',
            arguments: product);
        },
        child: Container(
          height: 100,
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Image.network(product.images.first),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      product.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        'A partir de ',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey[500]
                        ),
                      ),
                    ),
                    Text(
                      'R\$ 19,90',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,

                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
