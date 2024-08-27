import 'package:flutter/material.dart';
import 'package:prospere_ai/customBottomAppBar.dart';
import 'package:prospere_ai/views/mais.dart';
import 'package:prospere_ai/views/planejamento.dart';
import 'package:prospere_ai/views/transacoes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

late PageController pageController;
int initialPosition = 0;
bool mostrarSenha = true;
Color myColor = Color.fromARGB(255, 30, 163, 132);
Icon eyeIcon = Icon(Icons.visibility_off);

class _HomePageState extends State<HomePage> {
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

  void _onTabSelected(int index) {
    setState(() {
      initialPosition = index;
      pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  void _onFabPressed() {}

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
                    margin: EdgeInsets.symmetric(vertical: 15),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(67, 0, 0, 0),
                            spreadRadius: 6,
                            blurRadius: 3,
                            offset: Offset(0, 1), // changes position of shadow
                          ),
                        ],
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
                    margin: EdgeInsets.only(top: 5),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(67, 0, 0, 0),
                            spreadRadius: 6,
                            blurRadius: 3,
                            offset: Offset(0, 1), // changes position of shadow
                          ),
                        ],
                        color: const Color.fromARGB(255, 221, 221, 221),
                        borderRadius: BorderRadius.circular(12)),
                    height: 500,
                    width: double.infinity,
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
                        ]),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(67, 0, 0, 0),
                            spreadRadius: 6,
                            blurRadius: 3,
                            offset: Offset(0, 1), // changes position of shadow
                          ),
                        ],
                        color: const Color.fromARGB(255, 221, 221, 221),
                        borderRadius: BorderRadius.circular(12)),
                    height: 500,
                    width: double.infinity,
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
          Transacoes(),
          Planejamento(),
          Mais(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.mic),
        backgroundColor: myColor,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomBottomAppBar(
        myColor: myColor,
        selectedIndex: initialPosition,
        onTabSelected: _onTabSelected,
        onFabPressed: _onFabPressed,
      ),
    );
  }
}
