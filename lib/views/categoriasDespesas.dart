import 'package:flutter/material.dart';
import 'package:prospere_ai/views/categoriasReceitas.dart';


class categoriaDespesas extends StatefulWidget {
  const categoriaDespesas({super.key});

  @override
  State<categoriaDespesas> createState() => _categoriaDespesasState();
}

Color myColor = Color.fromARGB(255, 178, 0, 0);

class _categoriaDespesasState extends State<categoriaDespesas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: myColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
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
            SizedBox(height: 20),
            _buildCategoryButtons(),
            SizedBox(height: 50),
            _buildCategoryItem(Icons.home, 'Casa'),
            SizedBox(height: 20),
            _buildCategoryItem(Icons.menu_book_sharp, 'Educação'),
            SizedBox(height: 20),
            _buildCategoryItem(Icons.more_horiz, 'Outros'),
            SizedBox(height: 20),
            _buildCategoryItem(Icons.computer, 'Eletrônicos'),
            SizedBox(height: 20),
            _buildCategoryItem(Icons.shopping_cart, 'Supermercados'),
            SizedBox(height: 20),
            _buildCategoryItem(Icons.directions_car, 'Transporte'),
            SizedBox(height: 20),
            _buildCategoryItem(Icons.shopping_bag_rounded, 'Viagem'),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButtons() {
    return Container(
      margin: EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 221, 221, 221),
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
              child: Text('Receita', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 197, 197, 197),
                minimumSize: Size(150, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(55),
                ),
              ),
            ),
          ),
          SizedBox(width: 3),
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              child: Text('Despesas', style: TextStyle(color: Colors.black)),
              style: ElevatedButton.styleFrom(
                backgroundColor: myColor,
                minimumSize: Size(150, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(55),
                ),
              ),
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
        SizedBox(width: 50),
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
