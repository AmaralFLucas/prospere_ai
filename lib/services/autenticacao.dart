import 'package:firebase_auth/firebase_auth.dart';
import 'package:prospere_ai/services/bancoDeDados.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AutenticacaoServico {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
    clientId:
        '229392966027-e0ktmec4ags230nlefjmqom7sq4qddtc.apps.googleusercontent.com',
  );

  Future<String?> cadastrarUsuario({
    required String email,
    required String cpf,
    required String nome,
    required String senha,
  }) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: senha);
      addCadastro(
          userCredential.user!.uid, nome, email, DateTime.now(), '', cpf, '');
      await userCredential.user!.updateDisplayName(nome);
      await addCategoriasPadrao(userCredential.user!.uid);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        return "O usuário já está cadastrado";
      } else {
        return "Erro desconhecido";
      }
    }
  }

  Future<bool> logarUsuarios(
      {required String email, required String senha}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: senha);
      return true;
    } catch (e) {
      print("Erro no login: $e");
      return false;
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      User? user = userCredential.user;

      return user;
    } on FirebaseAuthException catch (e) {
      throw 'Erro de autenticação: ${e.message}';
    } catch (e) {
      if (e.toString().contains('popup_closed')) {
        throw 'O processo de login foi cancelado. Por favor, tente novamente';
      } else {
        throw 'Erro ao fazer login com Google: $e';
      }
    }
  }

  Future<void> deslogarUsuario() async {
    try {
      if (_firebaseAuth.currentUser != null) {
        for (final providerProfile
            in _firebaseAuth.currentUser?.providerData ?? []) {
          if (providerProfile.providerId == 'google.com') {
            await _googleSignIn.signOut();
            break;
          }
        }
      }
      await _firebaseAuth.signOut();
    } catch (e) {
      print('Erro ao deslogar: $e');
    }
  }

  Future<String?> redefinirSenha({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
    return null;
  }
}
