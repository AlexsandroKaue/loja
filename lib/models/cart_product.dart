import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lojavirtualv2/models/item_size.dart';
import 'package:lojavirtualv2/models/product.dart';

class CartProduct extends ChangeNotifier {
  Product product;
  String id;
  String productId;
  int quantity;
  String size;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  CartProduct.fromProduct(this.product) {
    productId = product.id;
    quantity = 1;
    size = product.selectedSize.name;
  }

  CartProduct.fromDocument(DocumentSnapshot document) {
    id = document.id;
    productId = document.data()['pid'] as String;
    quantity = document.data()['quantity'] as int;
    size = document.data()['size'] as String;

    firestore.doc('products/$productId').get().then(
      (doc) {
        product = Product.fromDocument(doc);
        notifyListeners();
      }
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'pid': productId,
      'quantity': quantity,
      'size': size
    };
  }

  bool stackable(Product product) {
    return productId == product.id && size == product.selectedSize.name;
  }

  void increment(){
    quantity++;
    notifyListeners();
  }

  void decrement(){
    quantity--;
    notifyListeners();
  }

  ItemSize get itemSize {
    if(product == null) return null;
    return product.findSize(size);
  }

  num get unitPrice {
    //if(product == null) return null;
    return itemSize?.price ?? 0;
  }

  num get totalPrice {
    return unitPrice * quantity;
  }

  bool get hasStock {
    final size = itemSize;
    if(size != null){
      return size.stock >= quantity;
    }
  }


}