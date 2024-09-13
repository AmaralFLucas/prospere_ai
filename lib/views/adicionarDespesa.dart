import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

List<Widget> data = <Widget>[Text('Hoje'), Text('Ontem'), Text('Outros')];

class AdicionarDespesa extends StatefulWidget {
  const AdicionarDespesa({super.key});

  @override
  State<AdicionarDespesa> createState() => _AdicionarreceitaState();
}

Color myColor = Color.fromARGB(255, 30, 163, 132);
Color myColorGray = Color.fromARGB(255, 121, 108, 108);

class _AdicionarreceitaState extends State<AdicionarDespesa> {
  bool toggleValue = false;
  String pago = "Não Pago";
  List<bool> isSelected = [true, false, false];
  bool vertical = false;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  // Controllers para capturar o valor e a categoria
  final TextEditingController _valorController = TextEditingController();
  final TextEditingController _categoriaController = TextEditingController();
  Timestamp? _dataSelecionada;

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
                    padding: EdgeInsets.all(15),
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
                              Navigator.pop(context);
                            },
                          ),
                          Padding(padding: EdgeInsets.only(left: 10)),
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
                            Expanded(
                              child: TextField(
                                controller: _valorController,
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                                decoration: InputDecoration(
                                  prefixText: "R\$ ",
                                  prefixStyle: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  hintText: "0,00",
                                  hintStyle: TextStyle(color: Colors.white70),
                                  border: InputBorder.none,
                                ),
                              ),
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
                    child: Column(
                      children: [
                        // Campos adicionais aqui...
                        Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.bookmark_border, size: 40),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20)),
                            Expanded(
                              child: TextField(
                                controller: _categoriaController,
                                decoration: InputDecoration(
                                  hintText: "Categoria",
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                        ElevatedButton(
                          onPressed: () {
                            // Função para selecionar data
                            showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            ).then((date) {
                              if (date != null) {
                                setState(() {
                                  _dataSelecionada = Timestamp.fromDate(date);
                                });
                              }
                            });
                          },
                          child: Text('Selecione uma Data'),
                        ),
                        Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check_circle_outline_outlined,
                              size: 40,
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10)),
                            Text(
                              pago,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 30)),
                            AnimatedContainer(
                              duration: Duration(milliseconds: 350),
                              height: 40,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: toggleValue
                                    ? myColor.withOpacity(0.5)
                                    : myColorGray.withOpacity(0.5),
                              ),
                              child: GestureDetector(
                                onTap: toggleButton,
                                child: Stack(
                                  children: <Widget>[
                                    AnimatedPositioned(
                                      duration: Duration(milliseconds: 350),
                                      top: 3,
                                      left: toggleValue ? 60 : 0,
                                      right: toggleValue ? 0 : 60,
                                      child: AnimatedSwitcher(
                                        duration: Duration(milliseconds: 350),
                                        child: toggleValue
                                            ? Icon(Icons.circle,
                                                color: myColor,
                                                size: 35,
                                                key: UniqueKey())
                                            : Icon(Icons.circle,
                                                color: myColorGray,
                                                size: 35,
                                                key: UniqueKey()),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 20),
                              height: 50,
                              width: 150,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Cancelar',
                                    style: TextStyle(color: Colors.black)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(55),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15)),
                            Container(
                              height: 50,
                              width: 150,
                              child: ElevatedButton(
                                onPressed: () {
                                  _salvarReceita();
                                  Navigator.of(context).pop();
                                },
                                child: Text('Salvar'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: myColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(55),
                                  ),
                                ),
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
      ),
    );
  }

  void _salvarReceita() {
    double? valor = double.tryParse(_valorController.text);
    String categoria = _categoriaController.text;
    Timestamp data = _dataSelecionada ?? Timestamp.now();

    if (valor != null && categoria.isNotEmpty) {
      // Substitua 'userId' pelo ID real do usuário
      String userId = uid;

      FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('despesas')
          .add({
        'valor': valor,
        'categoria': categoria,
        'data': data,
        'tipo': toggleValue ? "Realizado" : "Previsto",
      }).then((_) {
        print("Despesa adicionada com sucesso");
      }).catchError((error) {
        print("Falha ao adicionar despesa: $error");
      });
    } else {
      print("Por favor, insira todos os campos corretamente.");
    }
  }

  toggleButton() {
    setState(() {
      toggleValue = !toggleValue;
      pago = toggleValue ? "Pago" : "Não Pago";
    });
  }
}
