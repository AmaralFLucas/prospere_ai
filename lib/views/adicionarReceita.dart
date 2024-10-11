import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdicionarReceita extends StatefulWidget {
  const AdicionarReceita({super.key});

  @override
  State<AdicionarReceita> createState() => _AdicionarReceitaState();
}

Color myColor = const Color.fromARGB(255, 30, 163, 132);
Color myColorGray = const Color.fromARGB(255, 121, 108, 108);

class _AdicionarReceitaState extends State<AdicionarReceita> {
  bool toggleValue = false;
  String recebido = "Não Recebido";
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
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: myColor,
        ),
        child: Text(
          '${_dataSelecionada!.toDate().day}/${_dataSelecionada!.toDate().month}/${_dataSelecionada!.toDate().year}',
          style: const TextStyle(fontSize: 16, color: Colors.black),
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
                    DateTime.now().subtract(const Duration(days: 1)),
                  );
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
      children: const <Widget>[
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
                    padding: const EdgeInsets.all(15),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: myColor,
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(67, 0, 0, 0),
                          spreadRadius: 6,
                          blurRadius: 3,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    height: 150,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back),
                              color: const Color.fromARGB(255, 255, 255, 255),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            const Padding(padding: EdgeInsets.only(left: 10)),
                            const Text(
                              'Adicionar Receita',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const Row(
                          children: [
                            Padding(padding: EdgeInsets.only(bottom: 20)),
                            Text(
                              'Valor total Receita',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _valorController,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                decoration: const InputDecoration(
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
                    margin: const EdgeInsets.symmetric(vertical: 0),
                    padding: const EdgeInsets.only(top: 20),
                    width: double.infinity,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.check_circle_outline_outlined,
                              size: 40,
                            ),
                            const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10)),
                            Text(
                              recebido,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 30)),
                            Switch(
                              value: toggleValue,
                              onChanged: (bool newValue) {
                                setState(() {
                                  toggleValue = newValue;
                                  recebido =
                                      toggleValue ? "Recebido" : "Não Recebido";
                                });
                              },
                              activeColor: Colors.white,
                              activeTrackColor: myColor,
                              inactiveTrackColor: Colors.grey[300],
                              inactiveThumbColor: Colors.white,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                          ],
                        ),
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10)),
                        Container(
                          height: 2,
                          color: myColorGray,
                        ),
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.bookmark_border, size: 40),
                              const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20)),
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  decoration: const InputDecoration(
                                      labelText: 'Selecionar Categoria'),
                                  items: [
                                    'Investimento',
                                    'Presentes',
                                    'Outros',
                                    'Salário',
                                    'Prêmio',
                                  ].map((String categoria) {
                                    return DropdownMenuItem<String>(
                                      value: categoria,
                                      child: Text(categoria),
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
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10)),
                        Container(
                          height: 2,
                          color: myColorGray,
                        ),
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.date_range_outlined, size: 40),
                            const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20)),
                            _buildDateSelection(),
                          ],
                        ),
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 20),
                              height: 50,
                              width: 150,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(55),
                                  ),
                                ),
                                child: const Text(
                                  'Cancelar',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                            const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15)),
                            SizedBox(
                              height: 50,
                              width: 150,
                              child: ElevatedButton(
                                onPressed: () {
                                  _salvarDespesa();
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: myColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(55),
                                  ),
                                ),
                                child: const Text(
                                  'Adicionar',
                                  style: TextStyle(
                                    fontSize: 15,
                                    // fontWeight: FontWeight.bold,
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _dataSelecionada?.toDate()) {
      setState(() {
        _dataSelecionada = Timestamp.fromDate(picked);
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
          .collection('receitas')
          .add({
        'valor': valor,
        'categoria': categoria,
        'data': data,
        'tipo': toggleValue ? "Recebido" : "Não Recebido",
      }).then((_) {
        print("receita adicionada com sucesso");
      }).catchError((error) {
        print("Falha ao adicionar receita: $error");
      });
    } else {
      print("Por favor, insira todos os campos corretamente.");
    }
  }

  void toggleButton() {
    setState(() {
      toggleValue = !toggleValue;
      recebido = toggleValue ? "Recebido" : "Não Recebido";
    });
  }
}
