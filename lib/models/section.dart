import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:lojavirtualv2/models/section_item.dart';
import 'package:uuid/uuid.dart';

class Section extends ChangeNotifier {

  String id;
  String name;
  String type;
  List<SectionItem> items;
  List<SectionItem> originalItems;

  Section({this.id, this.name, this.type, List<SectionItem> items}){
    this.items = items ?? [];
    originalItems = List.from(this.items);
  }

  Section.fromDocument(DocumentSnapshot document) {
    id = document.id;
    name = document.data()['name'] as String;
    type = document.data()['type'] as String;
    items = (document.data()['items'] as List).map(
      (i) => SectionItem.fromMap(i as Map<String, dynamic>)
    ).toList();
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  DocumentReference get firestoreRef => firestore.doc('home/$id');

  final FirebaseStorage storage = FirebaseStorage.instance;
  Reference get storageRef => storage.ref().child('home/$id');
  
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type,
      'items': exportListItems()
    };
  }

  List<Map<String, dynamic>> exportListItems(){
    return items.map((e) => e.toMap()).toList();
  }

  String _error;
  String get error => _error;
  set error(String value) {
    _error = value;
    notifyListeners();
  }

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Section clone() {
    return Section(
      id: id,
      name: name,
      type: type,
      items: items.map((e) => e.clone()).toList()
    );
  }

  void addItem(SectionItem item) {
    items.add(item);
    notifyListeners();
  }

  void removeItem(SectionItem item) {
    items.remove(item);
    notifyListeners();
  }

  bool valid() {
    if(name == null || name.isEmpty){
      error = 'Insira um título para a seção';
    } else if(items.isEmpty) {
      error = 'Insira ao menos uma item na seção';
    } else {
      error = null;
    }
    return error == null;
  }
  
  Future<void> save(int pos) async {
    final data = {
      'name': name,
      'type': type,
      'pos': pos
    };

    if(id == null){
      final doc = await firestore.collection('home').add(data);
      id = doc.id;
    } else {
      await firestore.collection('home').doc(id).update(data);
    }

    for(final item in items) {
      if(item.image is File) {
        final TaskSnapshot snapshot = await storageRef
            .child(Uuid().v1())
            .putFile(item.image as File).then((snapshot) => snapshot);

        final String url = await snapshot.ref.getDownloadURL();
        item.image = url;
      }
    }

    for(final item in originalItems){
      if(!items.contains(item)) {
        try {
          final Reference ref = storage.refFromURL(item.image as String);
          await ref.delete();
        } catch(e) {
          debugPrint('Falha ao deletar imagem: ${item.image}');
        }
      }
    }
    await firestoreRef.update(
        {'items': items.map((e) => e.toMap()).toList()}
     );
  }

  Future<void> delete() async {
    await firestoreRef.delete();
    for(final item in items){
      try {
        final Reference ref = storage.refFromURL(item.image as String);
        await ref.delete();
      // ignore: empty_catches
      } catch(e) {}
    }
  }

  @override
  String toString() {
    return 'Section{name: $name, type: $type, items: $items}';
  }


}