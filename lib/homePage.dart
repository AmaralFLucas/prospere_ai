import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

PageController pageController = PageController();
int initialPosition = 0;
bool mostrarSenha = true;
Color myColor = Color.fromARGB(255, 30, 163, 132);
Icon eyeIcon = Icon(Icons.visibility_off);

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
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
            body: 
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 300,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(12)),
                      height: 200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text('Lucas Farias'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text('1111 1111 1111 1111'),
                              Text('09/28'),
                            ],
                          )
                        ],
                      ),
                    )
                  ]
                ),
              ]
            ), 
          ),
          Scaffold(
            appBar: AppBar(
              backgroundColor: myColor,
              automaticallyImplyLeading: false,
            ),
            body: Container(color: Colors.purple)
          ),
          Scaffold(
            appBar: AppBar(
              backgroundColor: myColor,
              automaticallyImplyLeading: false,
            ),
            body:  
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.all(12),
                        padding: EdgeInsets.all(12),
                        width: 200,
                        height: 200,
                        color: Colors.blue,
                        child: Text('Container'),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: 200,
                        height: 200,
                        color: Colors.blue,
                        child: Text('Container'),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: 200,
                        height: 200,
                        color: Colors.blue,
                        child: Text('Container'),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 300,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(12)),
                  height: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('Lucas Farias'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('1111 1111 1111 1111'),
                          Text('09/28'),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          
          
          Container(color: Colors.yellow,),
          
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        
      },
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
                    duration: Duration(milliseconds: 300), curve: Curves.easeIn);

                setState(() {
                  initialPosition = 0;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.list),
              color: initialPosition == 1 ? myColor : Colors.black,
              onPressed: () {
                pageController.animateToPage(1,
                    duration: Duration(milliseconds: 300), curve: Curves.easeIn);

                setState(() {
                  initialPosition = 1;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.flag),
              color: initialPosition == 2 ? myColor : Colors.black,
              onPressed: () {
                pageController.animateToPage(2,
                    duration: Duration(milliseconds: 300), curve: Curves.easeIn);

                setState(() {
                  initialPosition = 2;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.more_horiz),
              color: initialPosition == 3 ? myColor : Colors.black,
              onPressed: () {
                pageController.animateToPage(3,
                    duration: Duration(milliseconds: 300), curve: Curves.easeIn);

                setState(() {
                  initialPosition = 3;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
