import 'package:flutter/material.dart';
import 'package:prospere_ai/views/categoriasReceitas.dart';
import 'package:prospere_ai/views/homePage.dart';

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
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const categoriaReceita()));
                            },
                            child: Text('Receita',
                                style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 197, 197, 197),
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
                            onPressed: () {},
                            child: Text('Despesas',
                                style: TextStyle(color: Colors.black)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  myColor,
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
                          Icon(Icons.home, size: 60),
                          SizedBox(width:50), // Adiciona espaço entre o ícone e o texto
                          Text(
                            'Casa',
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
                          Icon(Icons.menu_book_sharp, size: 60),
                          SizedBox(width:50), // Adiciona espaço entre o ícone e o texto
                          Text(
                            'Educação',
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
                          SizedBox(width:50), // Adiciona espaço entre o ícone e o texto
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
                          Icon(Icons.computer, size: 60),
                          SizedBox(width:50), // Adiciona espaço entre o ícone e o texto
                          Text(
                            'Eletrônicos',
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
                          Icon(Icons.shopping_cart, size: 60),
                          SizedBox(width:50), // Adiciona espaço entre o ícone e o texto
                          Text(
                            'Supermercados',
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
                          Icon(Icons.directions_car, size: 60),
                          SizedBox(width:50), // Adiciona espaço entre o ícone e o texto
                          Text(
                            'Transporte',
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
                          Icon(Icons.shopping_bag_rounded, size: 60),
                          SizedBox(width:50), // Adiciona espaço entre o ícone e o texto
                          Text(
                            'Viagem',
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
                Container(padding: EdgeInsets.only(top: 20))
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
