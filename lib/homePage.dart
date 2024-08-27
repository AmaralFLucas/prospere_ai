import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PageController pageController;
  int initialPosition = 0;
  bool mostrarSenha = true;
  Color myColor = Color.fromARGB(255, 30, 163, 132);
  Icon eyeIcon = Icon(Icons.visibility_off);

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
          Scaffold(
            drawer: Drawer(
              child: ListView(
                children: const <Widget>[
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                    child: Text('Drawer Header'),
                  ),
                  ListTile(
                    title: Text('Item 1'),
                    onTap: null,
                  ),
                  ListTile(
                    title: Text('Item 2'),
                    onTap: null,
                  ),
                ],
              ),
            ),
            appBar: AppBar(
              backgroundColor: myColor,
              leading: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: Icon(Icons.person),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  );
                },
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 221, 221, 221),
                        borderRadius: BorderRadius.circular(12)),
                    height: 200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('Saldo Atual'),
                        Text(
                          'RS 433,15',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text(
                                  'RS 1.958,15',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('Receitas')
                              ],
                            ),
                            Container(
                              height: 50,
                              width: 2,
                              color: Colors.black,
                            ),
                            Column(
                              children: [
                                Text(
                                  'RS 1525,00',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('Despesas')
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 221, 221, 221),
                        borderRadius: BorderRadius.circular(12)),
                    height: 500,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 12,
                                height: 12,
                              ),
                              Text(
                                'Despesas',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: myColor,
                                borderRadius: BorderRadius.circular(12)),
                            height: 70,
                            width: 650,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: myColor,
                                borderRadius: BorderRadius.circular(12)),
                            height: 70,
                            width: 650,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: myColor,
                                borderRadius: BorderRadius.circular(12)),
                            height: 70,
                            width: 650,
                          ),
                        ]
                      ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 221, 221, 221),
                        borderRadius: BorderRadius.circular(12)),
                    height: 500,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 12,
                                height: 12,
                              ),
                              Text(
                                'Planejamento',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: myColor,
                                borderRadius: BorderRadius.circular(12)),
                            height: 70,
                            width: 650,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: myColor,
                                borderRadius: BorderRadius.circular(12)),
                            height: 70,
                            width: 650,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: myColor,
                                borderRadius: BorderRadius.circular(12)),
                            height: 70,
                            width: 650,
                          ),
                        ]),
                  ),
                ],
              ),
            ),
          ),
          Scaffold(
              appBar: AppBar(
                backgroundColor: myColor,
                automaticallyImplyLeading: false,
                title: Text('Transações'),
              ),
              body: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 221, 221, 221),
                        borderRadius: BorderRadius.circular(12)),
                    height: 200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('Saldo Atual'),
                        Text(
                          'RS 433,15',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text(
                                  'RS 1.958,15',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('Receitas')
                              ],
                            ),
                            Container(
                              height: 50,
                              width: 2,
                              color: Colors.black,
                            ),
                            Column(
                              children: [
                                Text(
                                  'RS 1525,00',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('Despesas')
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                    Container(
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 221, 221, 221),
                          borderRadius: BorderRadius.circular(12)),
                      height: 500,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: myColor,
                                  borderRadius: BorderRadius.circular(12)),
                              height: 70,
                              width: 650,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: myColor,
                                  borderRadius: BorderRadius.circular(12)),
                              height: 70,
                              width: 650,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: myColor,
                                  borderRadius: BorderRadius.circular(12)),
                              height: 70,
                              width: 650,
                            ),
                          ]),
                    ),
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {},
                child: Icon(Icons.plus_one),
                backgroundColor: myColor,
              ),
              floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
              ),
          Scaffold(
            appBar: AppBar(
              backgroundColor: myColor,
                automaticallyImplyLeading: false,
                title: Text('Planejamento'),
              ),
              body: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 12),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 221, 221, 221),
                        borderRadius: BorderRadius.circular(12)),
                    height: 200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('Saldo Atual'),
                        Text(
                          'RS 433,15',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text(
                                  'RS 1.958,15',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('Receitas')
                              ],
                            ),
                            Container(
                              height: 50,
                              width: 2,
                              color: Colors.black,
                            ),
                            Column(
                              children: [
                                Text(
                                  'RS 1525,00',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('Despesas')
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                    Container(
                      margin: EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 221, 221, 221),
                        borderRadius: BorderRadius.circular(12)
                      ),
                      height: 300,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                            Text('Grafico',
                            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                          )
                        ]
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ElevatedButton(
                        onPressed: () {

                        },
                        child: Text('Adicionar Planejamento',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: myColor,
                          minimumSize: Size(700, 70),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 221, 221, 221),
                          borderRadius: BorderRadius.circular(12)),
                      height: 500,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: myColor,
                                  borderRadius: BorderRadius.circular(12)),
                              height: 70,
                              width: 650,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: myColor,
                                  borderRadius: BorderRadius.circular(12)),
                              height: 70,
                              width: 650,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: myColor,
                                  borderRadius: BorderRadius.circular(12)),
                              height: 70,
                              width: 650,
                            ),
                          ]),
                    ),
                  ],
                ),
              )
          ),
          Scaffold(
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
                    decoration: 
                    BoxDecoration(
                      color: Color.fromARGB(255, 212, 217, 221),
                      borderRadius: BorderRadius.circular(12)
                    ),
                    height: 70,
                    width: MediaQuery.of(context).size.width,
                    
                    child: Center(
                      child: Text('Contas'),
                    ),
                  ),
                  // SizedBox(height: 10),
                  Container(
                    color: Colors.black,
                    height: 2,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Container(
                    decoration: 
                      BoxDecoration(
                        color: Color.fromARGB(255, 212, 217, 221),
                        borderRadius: BorderRadius.circular(12)
                      ),
                    height: 70,
                    width: MediaQuery.of(context).size.width,
                    
                    child: Center(
                      child: Text('Categorias'),
                    ),
                  ),
                  // SizedBox(height: 10),
                  Container(
                    color: Colors.black,
                    height: 2,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Container(
                    decoration: 
                      BoxDecoration(
                        color: Color.fromARGB(255, 212, 217, 221),
                        borderRadius: BorderRadius.circular(12)
                      ),
                    height: 70,
                    width: MediaQuery.of(context).size.width,
                    
                    child: Center(
                      child: Text('Modo Viagem'),
                    ),
                  ),
                  // SizedBox(height: 10),
                  Container(
                    color: Colors.black,
                    height: 2,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Container(
                    decoration: 
                      BoxDecoration(
                        color: Color.fromARGB(255, 212, 217, 221),
                        borderRadius: BorderRadius.circular(12)
                      ),
                    height: 70,
                    width: MediaQuery.of(context).size.width,
                    
                    child: Center(
                      child: Text('Esportar Relatório'),
                    ),
                  ),
                  // SizedBox(height: 10),
                  Container(
                    color: Colors.black,
                    height: 2,
                    width: MediaQuery.of(context).size.width,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.mic),
        backgroundColor: myColor,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        height: 60,
        notchMargin: 5,
        shape: CircularNotchedRectangle(),
        color: Color.fromARGB(255, 212, 217, 221),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.home),
              color: initialPosition == 0 ? myColor : Colors.black,
              onPressed: () {
                pageController.animateToPage(0,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeIn);
              },
            ),
            IconButton(
              icon: Icon(Icons.currency_exchange),
              color: initialPosition == 1 ? myColor : Colors.black,
              onPressed: () {
                pageController.animateToPage(1,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeIn);
              },
            ),
            IconButton(
              icon: Icon(Icons.flag),
              color: initialPosition == 2 ? myColor : Colors.black,
              onPressed: () {
                pageController.animateToPage(2,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeIn);
              },
            ),
            IconButton(
              icon: Icon(Icons.more_horiz),
              color: initialPosition == 3 ? myColor : Colors.black,
              onPressed: () {
                pageController.animateToPage(3,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeIn);
              },
            ),
          ],
        ),
      ),
    );
  }
}
