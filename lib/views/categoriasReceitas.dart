import 'package:flutter/material.dart';
import 'package:prospere_ai/views/categoriasDespesas.dart';
import 'package:prospere_ai/views/mais.dart';

class categoriaReceita extends StatefulWidget {
  const categoriaReceita({super.key});

  @override
  State<categoriaReceita> createState() => _categoriaReceitaState();
}

Color myColor = Color.fromARGB(255, 30, 163, 132);

class _categoriaReceitaState extends State<categoriaReceita> {
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
            Container(
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
                      onPressed: () {},
                      child: Text('Receita',
                          style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: myColor,
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
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => categoriaDespesas(),
                          ),
                        );
                      },
                      child: Text('Despesas',
                          style: TextStyle(color: Colors.black)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 197, 197, 197),
                        minimumSize: Size(150, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(55),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 50),
            _buildCategoryItem(Icons.trending_up_sharp, 'Investimento'),
            SizedBox(height: 20),
            _buildCategoryItem(Icons.card_giftcard, 'Presentes'),
            SizedBox(height: 20),
            _buildCategoryItem(Icons.more_horiz, 'Outros'),
            SizedBox(height: 20),
            _buildCategoryItem(Icons.monetization_on_outlined, 'Salário'),
            SizedBox(height: 20),
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
