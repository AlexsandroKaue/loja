import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:lojavirtualv2/helpers/firebase_errors.dart';
import 'package:lojavirtualv2/models/user.dart' as local;

class UserManager extends ChangeNotifier {
  //Extende ChangeNotifier para notificar quanto ocorrer alterações nas
  // variáveis(estados) do UserManager.

  UserManager(){
    _loadCurrentUser();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  local.User user;

  bool _loading = false;

  bool get loading => _loading;

  bool get isLoggedIn => user != null;

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  bool get adminEnabled => user != null && user.admin;

  Future<void> signIn(local.User user,
      {Function onFail, Function onSucess}) async {
    loading = true;
    try {
      final UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: user.email.trim(), password: user.password);

      await _loadCurrentUser(firebaseUser: credential.user);
      onSucess();
    } on FirebaseAuthException catch (e) {
      onFail(getErrorString(e.code));
    }
    loading = false;
  }

  Future<void> signOut() async{
    await _auth.signOut();
    user = null;
    notifyListeners();
  }

  Future<void> _loadCurrentUser({User firebaseUser}) async {
    final User currentUser = firebaseUser ?? _auth.currentUser;
    if(currentUser != null) {
      final DocumentSnapshot docUser = await firestore.collection('users')
          .doc(currentUser.uid).get();
      user = local.User.fromDocument(docUser);

      final docAdmin = await firestore.collection('admins')
          .doc(user.id).get();
      if(docAdmin.exists) user.admin = true;

      notifyListeners();
    }

  }

  Future<void> signUp(local.User user,
      {Function onFail, Function onSuccess}) async {
    loading = true;
    try{
      final UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: user.email, password: user.password);

      user.id = credential.user.uid;
      this.user = user;
      await user.save();
      onSuccess();
    } on FirebaseAuthException catch(e) {
      onFail(getErrorString(e.code));
    }
    loading = false;
  }
}
