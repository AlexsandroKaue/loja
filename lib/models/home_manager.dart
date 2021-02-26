import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:lojavirtualv2/models/section.dart';

class HomeManager extends ChangeNotifier {
  final firestore = FirebaseFirestore.instance;
  List<Section> sections = [];

  HomeManager(){
    _loadSections();
  }


  Future<void> _loadSections() async {
    firestore.collection('home').snapshots().listen(
      (snapshot) {
        sections.clear();
        for(final document in snapshot.docs) {
          sections.add(Section.fromDocument(document));
        }
        notifyListeners();
      }
    );
  }


}