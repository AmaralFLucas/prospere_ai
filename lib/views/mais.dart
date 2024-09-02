import 'package:flutter/material.dart';

class Mais extends StatefulWidget {
  const Mais({super.key});

  @override
  State<Mais> createState() => _MaisState();
}

Color myColor = Color.fromARGB(255, 30, 163, 132);

class _MaisState extends State<Mais> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: myColor,
        automaticallyImplyLeading: false,
        title: Text('Mais Opções'),
      ),
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 212, 217, 221),
                  borderRadius: BorderRadius.circular(12)),
              height: 70,
              width: double.infinity,
              child: Center(
                child: Text('Contas'),
              ),
            ),
            // SizedBox(height: 10),
            Container(
              color: Colors.black,
              height: 2,
              width: double.infinity,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 212, 217, 221),
                  borderRadius: BorderRadius.circular(12)),
              height: 70,
              width: double.infinity,
              child: Center(
                child: Text('Categorias'),
              ),
            ),
            // SizedBox(height: 10),
            Container(
              color: Colors.black,
              height: 2,
              width: double.infinity,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 212, 217, 221),
                  borderRadius: BorderRadius.circular(12)),
              height: 70,
              width: double.infinity,
              child: Center(
                child: Text('Modo Viagem'),
              ),
            ),
            // SizedBox(height: 10),
            Container(
              color: Colors.black,
              height: 2,
              width: double.infinity,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 212, 217, 221),
                  borderRadius: BorderRadius.circular(12)),
              height: 70,
              width: double.infinity,
              child: Center(
                child: Text('Esportar Relatório'),
              ),
            ),
            // SizedBox(height: 10),
            Container(
              color: Colors.black,
              height: 2,
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}
