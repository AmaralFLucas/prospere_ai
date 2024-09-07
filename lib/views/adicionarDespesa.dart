import 'package:flutter/material.dart';
import 'package:prospere_ai/views/homePage.dart';

List<Widget> data = <Widget>[Text('Hoje'), Text('Ontem'), Text('Outros')];

class Adicionardespesa extends StatefulWidget {
  const Adicionardespesa({super.key});

  @override
  State<Adicionardespesa> createState() => _AdicionardespesaState();
}

Color myColor = Color.fromARGB(255, 178, 0, 0);
Color myColorGray = Color.fromARGB(255, 121, 108, 108);

class _AdicionardespesaState extends State<Adicionardespesa> {
  bool toggleValue = false;
  String pago = "Não Pago";
  List<bool> isSelected = [true, false, false];
  bool vertical = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
      children: [
        Scaffold(
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                  height: 150,
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
                          'Adicionar Despesa',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ]),
                      Row(
                        children: [
                          Padding(padding: EdgeInsets.only(bottom: 20)),
                          Text(
                            'Valor total Despesa',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "R\$",
                            // "R\$ ${}",
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 0),
                  padding: EdgeInsets.only(top: 20),
                  width: double.infinity,
                  height: 1300,
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle_outline_outlined,
                          size: 40,
                        ),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                        Text(pago,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            )),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 30)),
                        AnimatedContainer(
                          duration: Duration(microseconds: 350),
                          height: 40,
                          width: 100,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: toggleValue
                                  ? myColor.withOpacity(0.5)
                                  : myColorGray.withOpacity(0.5)),
                          child: Stack(
                            children: <Widget>[
                              AnimatedPositioned(
                                duration: Duration(milliseconds: 350),
                                curve: Curves.easeIn,
                                top: 3,
                                left: toggleValue ? 60 : 0,
                                right: toggleValue ? 0 : 60,
                                child: InkWell(
                                  onTap: toggleButton,
                                  child: AnimatedSwitcher(
                                      duration: Duration(milliseconds: 350),
                                      transitionBuilder: (Widget child,
                                          Animation<double> animation) {
                                        return RotationTransition(
                                            child: child, turns: animation);
                                      },
                                      child: toggleValue
                                          ? Icon(Icons.circle,
                                              color: myColor,
                                              size: 35,
                                              key: UniqueKey())
                                          : Icon(
                                              Icons.circle,
                                              color: myColorGray,
                                              size: 35,
                                              key: UniqueKey(),
                                            )),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                    Container(height: 2, width: 400, color: Colors.black),
                    Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(
                        Icons.date_range_outlined,
                        size: 40,
                      ),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 20)),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 350),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const SizedBox(height: 5),
                            ToggleButtons(
                              direction:
                                  vertical ? Axis.vertical : Axis.horizontal,
                              onPressed: (int index) {
                                setState(() {
                                  for (int i = 0; i < isSelected.length; i++) {
                                    isSelected[i] = i == index;
                                  }
                                });
                              },
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                              selectedBorderColor: Color.fromARGB(255, 0, 0, 0),
                              selectedColor: Colors.white,
                              fillColor: myColor,
                              color: Colors.black,
                              constraints: const BoxConstraints(
                                minHeight: 40.0,
                                minWidth: 80.0,
                              ),
                              isSelected: isSelected,
                              children: data,
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ]),
                    Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                    Container(height: 2, width: 400, color: Colors.black),
                    Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.bookmark_border,
                          size: 40,
                        ),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 20)),
                        Text('Adicione uma Categoria',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                            )),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 20)),
                        Icon(
                          Icons.add,
                          size: 40,
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                    Container(height: 2, width: 400, color: Colors.black),
                    Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_outlined,
                          size: 40,
                        ),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 30)),
                        Text('Anexe o Recibo',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                            )),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 40)),
                        Icon(
                          Icons.add,
                          size: 40,
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                    Container(height: 2, width: 400, color: Colors.black),
                    Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(55),
                              boxShadow: [
                                BoxShadow(
                                  color: myColor,
                                  spreadRadius: 3,
                                  blurRadius: 0,
                                  offset: Offset(
                                      0, 0), // changes position of shadow
                                ),
                              ]),
                          height: 50,
                          width: 150,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const HomePage()));
                            },
                            child: Text('Cancelar',
                                style: TextStyle(color: Colors.black)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              minimumSize: Size(150, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(55),
                              ),
                            ),
                          ),
                        ),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 15)),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(55),
                              boxShadow: [
                                BoxShadow(
                                  color: myColor,
                                  spreadRadius: 3,
                                  blurRadius: 0,
                                  offset: Offset(
                                      0, 0), // changes position of shadow
                                ),
                              ]),
                          height: 50,
                          width: 150,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const HomePage()));
                            },
                            child: Text('Salvar'),
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
                    )
                  ]),
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }

  toggleButton() {
    setState(() {
      toggleValue = !toggleValue;
      if (toggleValue) {
        pago = "Pago";
      } else {
        pago = "Não Pago";
      }
    });
  }
}
