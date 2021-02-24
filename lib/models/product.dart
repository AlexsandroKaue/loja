import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:lojavirtualv2/models/item_size.dart';

class Product extends ChangeNotifier {

  String id;
  String title;
  String description;
  List<String> images;
  List<ItemSize> sizes;

  ItemSize _selectedSize;

  Product.fromDocument(DocumentSnapshot document){
    id = document.id;
    title = document.data()['title'] as String;
    description = document.data()['description'] as String;
    images = List<String>.from(document.data()['images'] as List<dynamic>);
    sizes = (document.data()['sizes'] as List<dynamic> ?? []).map(
            (s) => ItemSize.fromMap(s as Map<String, dynamic>)).toList();
  }

  ItemSize get selectedSize => _selectedSize;
  set selectedSize(ItemSize value) {
    _selectedSize = value;
    notifyListeners();
  }

  int get totalStock {
    int total = 0 ;
    for(final ItemSize size in sizes) {
      total += size.stock;
    }
    return total;
  }

  bool get hasStock => totalStock > 0;

  ItemSize findSize(String name) {
    try{
      return sizes.firstWhere((s) => s.name == name);
    } catch(e) {
      return null;
    }

  }

}