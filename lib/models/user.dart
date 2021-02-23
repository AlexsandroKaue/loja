import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {

  String id;
  String name;
  String email;
  String password;
  String confirmPassword;

  UserData({this.email, this.password, this.name, this.confirmPassword, this.id});

  UserData.fromDocument(DocumentSnapshot document){
    name = document.data()['name'] as String;
    email = document.data()['email'] as String;
  }

  DocumentReference get firestoreRef
    => FirebaseFirestore.instance.doc('users/$id');

  Future<void> save() async {
    await firestoreRef.set(toMap());
  }

  Map<String, dynamic> toMap(){
    return {
      'name': name,
      'email': email
    };
  }
}