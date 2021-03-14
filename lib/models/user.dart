import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lojavirtualv2/models/address.dart';

class User {

  String id;
  String name;
  String email;
  String password;
  Address address;

  String confirmPassword;
  bool admin = false;

  User({this.email, this.password, this.name, this.confirmPassword, this.id});

  User.fromDocument(DocumentSnapshot document){
    id = document.id;
    name = document.data()['name'] as String;
    email = document.data()['email'] as String;
    if(document.data().containsKey('address')) {
      address = Address.fromMap(document.data()['address'] as Map<String, dynamic>);
    }
  }

  DocumentReference get firestoreRef
    => FirebaseFirestore.instance.doc('users/$id');

  CollectionReference get cartReference
    => firestoreRef.collection('cart');

  Future<void> save() async {
    await firestoreRef.set(toMap());
  }

  Map<String, dynamic> toMap(){
    return {
      'name': name,
      'email': email,
      if(address!=null)
        'address': address.toMap()
    };
  }

  void setAddress(Address address){
    this.address = address;
    save();
  }
}