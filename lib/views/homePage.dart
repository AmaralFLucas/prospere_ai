import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prospere_ai/components/customBottomAppBar.dart';
import 'package:prospere_ai/views/inicio.dart';
import 'package:prospere_ai/views/mais.dart';
import 'package:prospere_ai/views/planejamento.dart';
import 'package:prospere_ai/views/transacoes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

late PageController pageController = PageController();
int initialPosition = 0;
bool mostrarSenha = true;
Color myColor = Color.fromARGB(255, 30, 163, 132);
Color cardColor = Color(0xFFF4F4F4);
Color textColor = Colors.black87;
Icon eyeIcon = Icon(Icons.visibility_off);

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void _onTabSelected(int index) {
    setState(() {
      initialPosition = index;
      pageController.jumpToPage(index);
    });
  }

  void _onFabPressed() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: (index) {
          setState(() {
            initialPosition = index;
          });
        },
        children: [
          Inicio(
            userId: uid,
          ),
          Transacoes(userId: uid),
          Planejamento(),
          Mais(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.mic),
        backgroundColor: myColor,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomBottomAppBar(
        myColor: myColor,
        selectedIndex: initialPosition,
        onTabSelected: _onTabSelected,
        onFabPressed: _onFabPressed,
      ),
    );
  }
}
