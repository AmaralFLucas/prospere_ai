import 'package:flutter/material.dart';
import 'package:prospere_ai/views/categoriasReceitas.dart';
import 'package:prospere_ai/views/homePage.dart';

class CategoriaDespesas extends StatefulWidget {
  const CategoriaDespesas({super.key});

  @override
  State<CategoriaDespesas> createState() => _CategoriaDespesasState();
}

Color myColor = const Color.fromARGB(255, 178, 0, 0);

class _CategoriaDespesasState extends State<CategoriaDespesas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(25),
              width: double.infinity,
              decoration: BoxDecoration(
                color: myColor,
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(67, 0, 0, 0),
                    spreadRadius: 6,
                    blurRadius: 3,
                    offset: const Offset(0, 1), // changes position of shadow
                  ),
                ],
              ),
              height: 100,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const HomePage()));
                    },
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Categorias de Despesas',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20, right: 10),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 221, 221, 221),
                borderRadius: BorderRadius.circular(55),
              ),
              height: 60,
              width: 310,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const CategoriaReceita()));
                    },
                    child: const Text('Receitas',
                        style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 197, 197, 197),
                      minimumSize: const Size(150, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(55),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Despesas',
                        style: TextStyle(color: Colors.black)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: myColor,
                      minimumSize: const Size(150, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(55),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            _buildCategoryItem(Icons.home, 'Casa'),
            _buildCategoryItem(Icons.menu_book_sharp, 'Educação'),
            _buildCategoryItem(Icons.computer, 'Eletrônicos'),
            _buildCategoryItem(Icons.shopping_cart, 'Supermercados'),
            _buildCategoryItem(Icons.directions_car, 'Transporte'),
            _buildCategoryItem(Icons.shopping_bag_rounded, 'Viagem'),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Implementar a funcionalidade de gerenciar categorias aqui
              },
              child: const Text(
                'Gerenciar Categorias',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: myColor,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 80),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(IconData icon, String label) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 240, 240, 240),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 40, color: myColor),
          const SizedBox(width: 20),
          Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
