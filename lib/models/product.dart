import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:lojavirtualv2/models/item_size.dart';
import 'package:uuid/uuid.dart';

class Product extends ChangeNotifier {

  String id;
  String title;
  String description;
  List<String> images;
  List<dynamic> newImages;
  List<ItemSize> sizes;
  ItemSize _selectedSize;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  DocumentReference get firestoreRef => firestore.doc('products/$id');

  final FirebaseStorage storage = FirebaseStorage.instance;
  Reference get storageRef => storage.ref().child('products/$id');

  Product({this.id, this.title, this.description,
    List<String> images, List<ItemSize> sizes}){
   this.images = images ?? [];
   this.sizes = sizes ?? [];
  }

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

  num get basePrice {
    num lowest = double.infinity;
    for(final size in sizes) {
      if(size.price < lowest && size.hasStock) {
        lowest = size.price;
      }
    }
    return lowest;
  }

  ItemSize findSize(String name) {
    try{
      return sizes.firstWhere((s) => s.name == name);
    } catch(e) {
      return null;
    }
  }

  Product clone(){
    return Product(
      id: id,
      title: title,
      description: description,
      images: List.from(images),
      sizes: sizes.map<ItemSize>((size) => size.clone()).toList()
    );
  }

  List<Map<String, dynamic>> exportListSizes(){
    return sizes.map((size) => size.toMap()).toList();
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'sizes': exportListSizes()
    };
  }

  Future<void> save() async {
    loading = true;
    final data = toMap();
    if(id == null) {
      final doc = await firestore.collection('products').add(data);
      id = doc.id;
    } else {
      await firestoreRef.update(data);
    }
    await updateImages();
    loading = false;
  }

  Future<void> updateImages() async {
    final List<String> updateImages = [];
    for(final newImage in newImages) {
      if(images.contains(newImage)) {
        updateImages.add(newImage as String);
      } else {
        final TaskSnapshot snapshot = await storageRef
            .child(Uuid().v1())
            .putFile(newImage as File).then((snapshot) => snapshot);

        final String url = await snapshot.ref.getDownloadURL();
        updateImages.add(url);
      }
    }
    for(final image in images){
      if(!newImages.contains(image)) {
        try {
          final Reference ref = storage.refFromURL(image);
          await ref.delete();
        } catch(e) {
          debugPrint('Falha ao deletar imagem: $image');
        }
      }
    }
    await firestoreRef.update({'images': updateImages});
    images = updateImages;
    newImages = [];
  }

  @override
  String toString() {
    return 'Product{id: $id, title: $title, description: $description, '
        'images: $images, newImages: $newImages, sizes: $sizes}';
  }


}