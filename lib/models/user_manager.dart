import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:lojavirtualv2/helpers/firebase_errors.dart';
import 'package:lojavirtualv2/models/user.dart';

class UserManager extends ChangeNotifier {
  //Extende ChangeNotifier para notificar quanto ocorrer alterações nas
  // variáveis(estados) do UserManager.

  UserManager(){
    _loadCurrentUser();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  UserData userData;

  bool _loading = false;

  bool get loading => _loading;

  bool get isLoggedIn => userData != null;

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> signIn(UserData userData,
      {Function onFail, Function onSucess}) async {
    loading = true;
    try {
      final UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: userData.email, password: userData.password);

      await _loadCurrentUser(firebaseUser: credential.user);
      onSucess();
    } on FirebaseAuthException catch (e) {
      onFail(getErrorString(e.code));
    }
    loading = false;
  }

  Future<void> signOut() async{
    await _auth.signOut();
    userData = null;
    notifyListeners();
  }

  Future<void> _loadCurrentUser({User firebaseUser}) async {
    final User currentUser = firebaseUser ?? _auth.currentUser;
    if(currentUser != null) {
      final DocumentSnapshot docUser = await firestore.collection('users')
          .doc(currentUser.uid).get();
      userData = UserData.fromDocument(docUser);
      notifyListeners();
    }

  }

  Future<void> signUp(UserData userData,
      {Function onFail, Function onSuccess}) async {
    loading = true;
    try{
      final UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: userData.email, password: userData.password);

      userData.id = credential.user.uid;
      this.userData = userData;
      await userData.save();
      onSuccess();
    } on FirebaseAuthException catch(e) {
      onFail(getErrorString(e.code));
    }
    loading = false;
  }
}
