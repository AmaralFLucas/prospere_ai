import 'package:flutter/material.dart';
import 'package:prospere_ai/views/categoriasDespesas.dart';


class categoriaReceita extends StatefulWidget {
  const categoriaReceita({super.key});

  @override
  State<categoriaReceita> createState() => _categoriaReceitaState();
}

Color myColor = const Color.fromARGB(255, 30, 163, 132);

class _categoriaReceitaState extends State<categoriaReceita> {
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
            Container(
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
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: myColor,
                        minimumSize: const Size(150, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(55),
                        ),
                      ),
                      child: Text('Receita',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(width: 3),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const categoriaDespesas(),
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
                      child: Text('Despesas',
                          style: TextStyle(color: Colors.black)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            _buildCategoryItem(Icons.trending_up_sharp, 'Investimento'),
            const SizedBox(height: 20),
            _buildCategoryItem(Icons.card_giftcard, 'Presentes'),
            const SizedBox(height: 20),
            _buildCategoryItem(Icons.more_horiz, 'Outros'),
            const SizedBox(height: 20),
            _buildCategoryItem(Icons.monetization_on_outlined, 'Salário'),
            const SizedBox(height: 20),
            _buildCategoryItem(Icons.workspace_premium, 'Prêmio'),
          ],
        ),
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
