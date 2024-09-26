import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdicionarDespesa extends StatefulWidget {
  const AdicionarDespesa({super.key});

  @override
  State<AdicionarDespesa> createState() => _AdicionarDespesaState();
}

Color myColor = Color.fromARGB(255, 178, 0, 0);
Color myColorGray = Color.fromARGB(255, 121, 108, 108);

class _AdicionarDespesaState extends State<AdicionarDespesa> {
  bool toggleValue = false;
  String pago = "Não Pago";
  List<bool> isSelected = [true, false, false];
  bool vertical = false;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  String? categoria;

  final TextEditingController _valorController = TextEditingController();
  final TextEditingController _categoriaController = TextEditingController();
  Timestamp? _dataSelecionada;
  bool outrosSelecionado = false;

  Widget _buildDateSelection() {
    if (_dataSelecionada != null) {
      return ElevatedButton(
        onPressed: () {
          _selectDate(context);
        },
        child: Text(
          '${_dataSelecionada!.toDate().day}/${_dataSelecionada!.toDate().month}/${_dataSelecionada!.toDate().year}',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: myColor,
        ),
      );
    }

    return ToggleButtons(
      direction: vertical ? Axis.vertical : Axis.horizontal,
      onPressed: (int index) {
        setState(() {
          for (int i = 0; i < isSelected.length; i++) {
            isSelected[i] = i == index;
          }

          if (index == 2) {
            _selectDate(context);
          } else {
            outrosSelecionado = false;
            _dataSelecionada = index == 0
                ? Timestamp.fromDate(DateTime.now())
                : Timestamp.fromDate(
                    DateTime.now().subtract(Duration(days: 1)));
          }
        });
      },
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      selectedBorderColor: Colors.black,
      selectedColor: Colors.white,
      fillColor: myColor,
      color: Colors.black,
      constraints: const BoxConstraints(
        minHeight: 40.0,
        minWidth: 80.0,
      ),
      isSelected: isSelected,
      children: <Widget>[
        Text('Hoje'),
        Text('Ontem'),
        Text('Outros'),
      ],
    );
  }

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
                        offset: Offset(0, 1),
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
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check_circle_outline_outlined,
                              size: 40,
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10)),
                            Text(pago,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                )),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 30)),
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
                        Container(
                          height: 2,
                          color: myColorGray,
                        ),
                        Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.bookmark_border, size: 40),
                              Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20)),
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                      labelText: 'Selecionar Categoria'),
                                  items: [
                                    'Casa',
                                    'Educação',
                                    'Outros',
                                    'Eletrônicos',
                                    'Supermercados',
                                    'Transporte',
                                    'Viagem',
                                  ].map((String bank) {
                                    return DropdownMenuItem<String>(
                                      value: bank,
                                      child: Text(bank),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    _categoriaController.text = newValue!;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                        Container(
                          height: 2,
                          color: myColorGray,
                        ),
                        Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.date_range_outlined,
                              size: 40,
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20)),
                            _buildDateSelection(),
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
                                  _salvarDespesa();
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'Adicionar',
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: myColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(55),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
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

  void _selectDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      setState(() {
        _dataSelecionada = Timestamp.fromDate(selectedDate);
        outrosSelecionado = true;
      });
    }
  }

  void _salvarDespesa() {
    double? valor = double.tryParse(_valorController.text);
    String categoria = _categoriaController.text;
    Timestamp data = _dataSelecionada ?? Timestamp.now();

    if (valor != null && categoria.isNotEmpty) {
      String userId = uid;

      FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('despesas')
          .add({
        'valor': valor,
        'categoria': categoria,
        'data': data,
        'tipo': toggleValue ? "Pago" : "Previsto",
      }).then((_) {
        print("Despesa adicionada com sucesso");
      }).catchError((error) {
        print("Falha ao adicionar despesa: $error");
      });
    } else {
      print("Por favor, insira todos os campos corretamente.");
    }
    FirebaseFirestore.instance.collection("users").doc(uid).collection("despesas").add({
      'valor': _valorController.text,
      'categoria': _categoriaController.text,
      'data': _dataSelecionada ?? Timestamp.now(),
      'tipo': pago,
    });
  }

  void toggleButton() {
    setState(() {
      toggleValue = !toggleValue;
      pago = toggleValue ? "Pago" : "Não Pago";
    });
  }
}
