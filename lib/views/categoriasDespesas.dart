import 'package:flutter/material.dart';
import 'package:prospere_ai/views/categoriasReceitas.dart';


class categoriaDespesas extends StatefulWidget {
  const categoriaDespesas({super.key});

  @override
  State<categoriaDespesas> createState() => _categoriaDespesasState();
}

Color myColor = const Color.fromARGB(255, 178, 0, 0);

class _categoriaDespesasState extends State<categoriaDespesas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: myColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Categorias',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildCategoryButtons(),
            const SizedBox(height: 50),
            _buildCategoryItem(Icons.home, 'Casa'),
            const SizedBox(height: 20),
            _buildCategoryItem(Icons.menu_book_sharp, 'Educação'),
            const SizedBox(height: 20),
            _buildCategoryItem(Icons.more_horiz, 'Outros'),
            const SizedBox(height: 20),
            _buildCategoryItem(Icons.computer, 'Eletrônicos'),
            const SizedBox(height: 20),
            _buildCategoryItem(Icons.shopping_cart, 'Supermercados'),
            const SizedBox(height: 20),
            _buildCategoryItem(Icons.directions_car, 'Transporte'),
            const SizedBox(height: 20),
            _buildCategoryItem(Icons.shopping_bag_rounded, 'Viagem'),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButtons() {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 221, 221, 221),
        borderRadius: BorderRadius.circular(55),
      ),
      height: 60,
      width: 310,
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const categoriaReceita(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 197, 197, 197),
                minimumSize: const Size(150, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(55),
                ),
              ),
              child: Text('Receita', style: TextStyle(color: Colors.white)),
            ),
          ),
          const SizedBox(width: 3),
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: myColor,
                minimumSize: const Size(150, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(55),
                ),
              ),
              child: Text('Despesas', style: TextStyle(color: Colors.black)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(IconData icon, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 60),
        const SizedBox(width: 50),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
