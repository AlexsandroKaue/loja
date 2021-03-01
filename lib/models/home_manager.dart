import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lojavirtualv2/models/section.dart';
import 'package:provider/provider.dart';

class HomeManager extends ChangeNotifier {
  final firestore = FirebaseFirestore.instance;
  final List<Section> _sections = [];
  List<Section> _editingSections = [];

  bool editing = false;
  bool loading = false;

  HomeManager(){
    _loadSections();
  }

  List<Section> get sections {
    if(editing) {
      return _editingSections;
    } else {
      return _sections;
    }
  }

  Future<void> _loadSections() async {
    firestore.collection('home').orderBy('pos').snapshots().listen(
      (snapshot) {
        _sections.clear();
        for(final document in snapshot.docs) {
          _sections.add(Section.fromDocument(document));
        }
        notifyListeners();
      }
    );
  }

  void enterEditing() {
    editing = true;
    _editingSections = _sections.map((s) => s.clone()).toList();
    notifyListeners();
  }

  void addSection(Section section){
    _editingSections.add(section);
    notifyListeners();
  }

  void removeSection(Section section){
    _editingSections.remove(section);
    notifyListeners();
  }

  Future<void> saveEditing() async{
    bool valid = true;

    for(final section in sections){
      if(!section.valid()) valid = false;
    }
    if(!valid) return;

    loading = true;
    notifyListeners();

    int pos = 0;
    for(final section in _editingSections){
      await section.save(pos);
      pos++;
    }

    for(final section in List.from(_sections)){
      if(!_editingSections.any((s) => s.id == section.id)) {
        await section.delete();
      }
    }

    loading = false;
    editing = false;
    notifyListeners();
  }

  void discardEditing() {
    editing = false;
    notifyListeners();
  }

  void onMoveUp(Section section) {
    final index = sections.indexOf(section);
    sections.remove(section);
    sections.insert(index-1, section);
    notifyListeners();
  }

  void onMoveDown(Section section){
    final index = sections.indexOf(section);
    sections.remove(section);
    sections.insert(index+1, section);
    notifyListeners();
  }
}