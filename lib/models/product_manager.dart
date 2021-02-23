
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lojavirtualv2/models/product.dart';

class ProductManager extends ChangeNotifier{

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Product> allProducts = [];
  String _search = '';

  ProductManager() {
    _loadAllProducts();
  }

  String get search => _search;
  set search(String value) {
    _search = value;
    notifyListeners();
  }

  List<Product>get filteredProducts {
    final List<Product> filteredProducts = [];
    if(_search == null || _search.isEmpty) {
      filteredProducts.addAll(allProducts);
    } else {
      filteredProducts.addAll(allProducts.where(
              (p) => p.title.toLowerCase().contains(_search.toLowerCase())));
    }

    return filteredProducts;
  }

  Future<void> _loadAllProducts() async {
    final QuerySnapshot query =  await firestore.collection('products').get();

    allProducts = query.docs.map((doc) => Product.fromDocument(doc)).toList();

    notifyListeners();
  }
}
