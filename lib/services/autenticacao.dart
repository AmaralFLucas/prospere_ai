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

  // Função para cadastrar usuário com e-mail e senha
  Future<String?> cadastrarUsuario({
    required String email,
    required String cpf,
    required String nome,
    required String senha,
  }) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: senha);
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

  // Função para logar com e-mail e senha
  Future<bool> logarUsuarios(
      {required String email, required String senha}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: senha);
      return true; // Retorna true se o login for bem-sucedido
    } catch (e) {
      print("Erro no login: $e"); // Exibe o erro no console para depuração
      return false; // Retorna false em caso de falha no login
    }
  }

  // Função para realizar o login com o Google
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null; // O usuário cancelou o login
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

      // Aqui você pode salvar informações adicionais do usuário no Firestore, se necessário
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
      // Verifica se o usuário está logado com o Google
      if (_firebaseAuth.currentUser != null) {
        // Se for um login do Google, realiza o signOut no Google também
        for (final providerProfile
            in _firebaseAuth.currentUser?.providerData ?? []) {
          if (providerProfile.providerId == 'google.com') {
            await _googleSignIn.signOut(); // Desloga do Google
            break;
          }
        }
      }
      // Desloga do Firebase (mesmo que não seja Google)
      await _firebaseAuth.signOut();
    } catch (e) {
      print('Erro ao deslogar: $e');
    }
  }

  // Função para redefinir senha
  Future<String?> redefinirSenha({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
    return null;
  }
}
