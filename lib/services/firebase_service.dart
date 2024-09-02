import 'package:firebase_auth/firebase_auth.dart';

login(email, password) async {
  var auth = FirebaseAuth.instance;
  try {
    auth.signInWithEmailAndPassword(email: email, password: password);
    return true;
  } catch (e) {
    return false;
  }
}

logout() async {
  var auth = FirebaseAuth.instance;
  auth.signOut();
}

createUser(email, password) async {
  var auth = FirebaseAuth.instance;
  auth.createUserWithEmailAndPassword(email: email, password: password);
}

recoverPassword(email) async {
  var auth = FirebaseAuth.instance;
  auth.sendPasswordResetEmail(email: email);
}
