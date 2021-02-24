import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtualv2/models/cart_product.dart';
import 'package:lojavirtualv2/models/product.dart';
import 'package:lojavirtualv2/models/user.dart';
import 'package:lojavirtualv2/models/user_manager.dart';

class CartManager extends ChangeNotifier{
  List<CartProduct> items = [];
  UserData user;
  num productsPrice = 0.0;

  Future<void> _loadCartItems() async {
    final QuerySnapshot cartSnap = await user.cartReference.get();

    items = cartSnap.docs.map((d) {
      return CartProduct.fromDocument(d)..addListener(_onItemUpdated);
    }).toList();
  }

  void addToCart(Product product){
    try{
      final e = items.firstWhere((p) => p.stackable(product));
      e.increment();
    } catch(e) {
      final cartProduct = CartProduct.fromProduct(product);
      //Adiciona um ouvinte para quando o cartProduct chama notifyListener
      // e em seguida executa _onItemUpdated
      cartProduct.addListener(_onItemUpdated);
      items.add(cartProduct);
      user.cartReference.add(cartProduct.toMap()).then(
          (ref) => cartProduct.id = ref.id
      );
      _onItemUpdated();
    }
    notifyListeners();
  }

  void removeOfCart(CartProduct cartProduct){
    items.removeWhere((p) => p.id == cartProduct.id);
    user.cartReference.doc(cartProduct.id).delete();
    cartProduct.removeListener(_onItemUpdated);
    notifyListeners();
  }

  void updateUser(UserManager userManager) {
    user = userManager.userData;
    items.clear();

    if(user != null) {
      _loadCartItems();
    }
  }

  bool get isCartValid {
    for(final cartProduct in items) {
      if(!cartProduct.hasStock) return false;
    }
    return true;
  }

  void _onItemUpdated(){
    productsPrice = 0.0;
    final iterator = items.iterator;
    for(int i=0; i<items.length; i++){
      final cartProduct = items[i];
      if(cartProduct.quantity == 0){
        removeOfCart(cartProduct);
        i--;
        continue;
      }
      productsPrice += cartProduct.totalPrice;
      _updateCartProduct(cartProduct);
    }
    notifyListeners();
  }

  Future<void> _updateCartProduct(CartProduct cartProduct) async {
    if(cartProduct.id != null) {
      await user.cartReference.doc(cartProduct.id)
          .update(cartProduct.toMap());
    }

  }
}
