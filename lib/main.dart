import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prospere_ai/views/homePage.dart';
import 'package:prospere_ai/views/telaInicio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    home: const RoteadorTela(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData(useMaterial3: false),
  ));
}

class RoteadorTela extends StatelessWidget {
  const RoteadorTela({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.userChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // return const HomePage();

            return const HomePage();
          } else {
            return const TelaInicio();
          }
        });
  }
}
