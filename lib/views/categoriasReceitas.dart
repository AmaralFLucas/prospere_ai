import 'package:flutter/material.dart';
import 'package:prospere_ai/views/categoriasDespesas.dart';
import 'package:prospere_ai/views/homePage.dart';

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
        body: PageView(
      children: [
        Scaffold(
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(25),
                  width: double.infinity,
                  decoration: BoxDecoration(color: myColor, boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(67, 0, 0, 0),
                      spreadRadius: 6,
                      blurRadius: 3,
                      offset: Offset(0, 1), // changes position of shadow
                    ),
                  ]),
                  height: 100,
                  child: Column(
                    children: [
                      Row(children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back),
                          color: Color.fromARGB(255, 255, 255, 255),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const HomePage()));
                          },
                        ),
                        Text(
                          'Categorias',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ]),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, right: 10),
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 221, 221, 221),
                      borderRadius: BorderRadius.circular(55)),
                  height: 60,
                  width: 310,
                  child: Column(children: [
                    Row(
                      children: [
                        Padding(padding: EdgeInsets.only(right: 2.5)),
                        Container(
                          margin: EdgeInsets.only(right: 1),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(55)),
                          height: 60,
                          width: 150,
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
                        Padding(padding: EdgeInsets.symmetric(horizontal: 3)),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(55)),
                          height: 60,
                          width: 150,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      const categoriaDespesas()));
                            },
                            child: Text('Despesas',
                                style: TextStyle(color: Colors.black)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Color.fromARGB(255, 197, 197, 197),
                              minimumSize: Size(150, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(55),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ]),
                ),
                Container(
                  padding: EdgeInsets.only(top: 50),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.trending_up_sharp, size: 60),
                          SizedBox(
                              width:
                                  50), // Adiciona espaço entre o ícone e o texto
                          Text(
                            'Investimento',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.card_giftcard, size: 60),
                          SizedBox(
                              width:
                                  50), // Adiciona espaço entre o ícone e o texto
                          Text(
                            'Presentes',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.more_horiz, size: 60),
                          SizedBox(
                              width:
                                  50), // Adiciona espaço entre o ícone e o texto
                          Text(
                            'Outros',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.monetization_on_outlined, size: 60),
                          SizedBox(
                              width:
                                  50), // Adiciona espaço entre o ícone e o texto
                          Text(
                            'Sálario',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.workspace_premium, size: 60),
                          SizedBox(
                              width:
                                  50), // Adiciona espaço entre o ícone e o texto
                          Text(
                            'Prêmio',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
