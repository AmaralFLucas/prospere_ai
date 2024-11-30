import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prospere_ai/views/categoriasReceitas.dart';
import 'package:prospere_ai/views/relatorio.dart';

class Mais extends StatefulWidget {
  final bool? toggleValue;

  const Mais({super.key, this.toggleValue});

  @override
  State<Mais> createState() => _MaisState();
}

Color myColor = const Color(0xFF1EA384);

class _MaisState extends State<Mais> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  bool toggleValue = false;

  Widget buildNavigationOption(String title, IconData icon, VoidCallback onTap,
      {Widget? trailing}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: myColor, size: 30),
            const SizedBox(width: 20),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const Spacer(),
            trailing ?? const Icon(Icons.arrow_forward_ios, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: myColor,
        automaticallyImplyLeading: false,
        title: const Text(
          'Mais Opções',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          buildNavigationOption('Categorias', Icons.category, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Categoria(userId: uid)),
            );
          }),
          buildNavigationOption(
            'Modo Viagem',
            Icons.airplanemode_active,
            () {},
            trailing: Switch(
              value: toggleValue,
              onChanged: (bool newValue) {
                setState(() {
                  toggleValue = newValue;
                });
              },
              activeColor: Colors.white,
              activeTrackColor: myColor,
              inactiveTrackColor: Colors.grey[300],
              inactiveThumbColor: Colors.white,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          buildNavigationOption('Relatório', Icons.bar_chart, () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Relatorio(
                        userId: uid,
                      )),
            );
          }),
        ],
      ),
    );
  }
}
