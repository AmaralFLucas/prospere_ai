import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

List<Widget> data = <Widget>[Text('Hoje'), Text('Ontem'), Text('Outros')];

class AdicionarReceita extends StatefulWidget {
  const AdicionarReceita({super.key});

  @override
  State<AdicionarReceita> createState() => _AdicionarreceitaState();
}

Color myColor = Color.fromARGB(255, 30, 163, 132);
Color myColorGray = Color.fromARGB(255, 121, 108, 108);

class _AdicionarreceitaState extends State<AdicionarReceita> {
  bool toggleValue = false;
  String recebido = "Não Recebido";
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
                            'Adicionar Receita',
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
                              'Valor total Receita',
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
                            Padding(padding: EdgeInsets.symmetric(horizontal: 15)),
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
          .collection('receitas')
          .add({
        'valor': valor,
        'categoria': categoria,
        'data': data,
        'tipo': toggleValue ? "Realizado" : "Previsto",
      }).then((_) {
        print("Receita adicionada com sucesso");
      }).catchError((error) {
        print("Falha ao adicionar receita: $error");
      });
    } else {
      print("Por favor, insira todos os campos corretamente.");
    }
  }

  toggleButton() {
    setState(() {
      toggleValue = !toggleValue;
      recebido = toggleValue ? "Recebido" : "Não Recebido";
    });
  }
}
