import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prospere_ai/components/textFormatter.dart';

class AdicionarDespesa extends StatefulWidget {
  final double? valorDespesa;
  final String? valorFormatado;
  final Timestamp? data;

  const AdicionarDespesa(
      {super.key, this.valorDespesa, this.valorFormatado, this.data});

  @override
  State<AdicionarDespesa> createState() => _AdicionarDespesaState();
}

Color myColor = const Color.fromARGB(255, 178, 0, 0);
Color myColorGray = const Color.fromARGB(255, 121, 108, 108);

class _AdicionarDespesaState extends State<AdicionarDespesa> {
  bool toggleValue = false;
  String pago = "Não Pago";
  List<bool> isSelected = [true, false, false];
  bool vertical = false;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  String? categoria;
  List<String> categorias = [];

  final TextEditingController _valorController = TextEditingController();
  final TextEditingController _categoriaController = TextEditingController();
  Timestamp? _dataSelecionada;
  bool outrosSelecionado = false;

  @override
  void initState() {
    super.initState();
    _carregarCategorias();

    if (widget.valorFormatado != null) {
      _valorController.text = widget.valorFormatado!;
    } else if (widget.valorDespesa != null) {
      _valorController.text =
          widget.valorDespesa!.toStringAsFixed(2).replaceAll('.', ',');
    }
    DateTime hoje = DateTime.now();
    DateTime ontem = hoje.subtract(Duration(days: 1));

    if (widget.data != null) {
      DateTime dataAudio = widget.data!.toDate();
      if (dataAudio.year == hoje.year &&
          dataAudio.month == hoje.month &&
          dataAudio.day == hoje.day) {
        isSelected = [true, false, false];
        _dataSelecionada = Timestamp.fromDate(hoje);
      } else if (dataAudio.year == ontem.year &&
          dataAudio.month == ontem.month &&
          dataAudio.day == ontem.day) {
        isSelected = [false, true, false];
        _dataSelecionada = Timestamp.fromDate(ontem);
      } else {
        isSelected = [false, false, true];
        _dataSelecionada = Timestamp.fromDate(dataAudio);
        outrosSelecionado = true;
      }
    }
  }

  Future<void> _carregarCategorias() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('categoriasDespesas')
        .get();

    setState(() {
      categorias = snapshot.docs.map((doc) => doc['nome'] as String).toList();
    });
  }

  Widget _buildDateSelection() {
    String getDataSelecionadaLabel(DateTime dataSelecionada) {
      DateTime hoje = DateTime.now();
      DateTime ontem = hoje.subtract(Duration(days: 1));

      if (dataSelecionada.year == hoje.year &&
          dataSelecionada.month == hoje.month &&
          dataSelecionada.day == hoje.day) {
        return 'index0';
      } else if (dataSelecionada.year == ontem.year &&
          dataSelecionada.month == ontem.month &&
          dataSelecionada.day == ontem.day) {
        return 'index1';
      } else {
        return '${dataSelecionada.day}/${dataSelecionada.month}/${dataSelecionada.year}';
      }
    }

    if (outrosSelecionado && _dataSelecionada != null) {
      return ElevatedButton(
        onPressed: () {
          _selectDate(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: myColor,
        ),
        child: Text(
          getDataSelecionadaLabel(_dataSelecionada!.toDate()),
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
            _dataSelecionada = index == 0
                ? Timestamp.fromDate(DateTime.now())
                : Timestamp.fromDate(
                    DateTime.now().subtract(const Duration(days: 1)),
                  );
            outrosSelecionado = false;
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
        Text('Outra Data'),
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
              // child: Padding(
              // padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                        Row(children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            color: const Color.fromARGB(255, 255, 255, 255),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          const Padding(padding: EdgeInsets.only(left: 10)),
                          const Text(
                            'Adicionar Despesa',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ]),
                        const Row(
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
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                inputFormatters: [CurrencyTextInputFormatter()],
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                decoration: const InputDecoration(
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
                  const SizedBox(height: 20),
                  Center(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.check_circle_outline_outlined,
                                  size: 40,
                                ),
                                Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5)),
                                Text(
                                  pago,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Switch(
                              value: toggleValue,
                              onChanged: (bool newValue) {
                                setState(() {
                                  toggleValue = newValue;
                                  pago = toggleValue ? "Pago" : "Não Pago";
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
                        const Divider(color: Colors.grey),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.bookmark_border, size: 40),
                            const SizedBox(width: 20),
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                decoration: const InputDecoration(
                                    labelText: 'Selecionar Categoria'),
                                items: categorias.isNotEmpty
                                    ? categorias.map((String categoria) {
                                        return DropdownMenuItem<String>(
                                          value: categoria,
                                          child: Text(categoria),
                                        );
                                      }).toList()
                                    : [
                                        const DropdownMenuItem<String>(
                                          value: null,
                                          child: Text(
                                              'Nenhuma categoria disponível'),
                                        ),
                                      ],
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _categoriaController.text = newValue!;
                                    categoria = newValue;
                                  });
                                },
                                value: categoria,
                              ),
                            ),
                          ],
                        ),
                        const Divider(color: Colors.grey),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(Icons.date_range_outlined, size: 40),
                            _buildDateSelection(),
                            SizedBox(
                              width: 50,
                            )
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                fixedSize: Size(150, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              child: Text(
                                'Cancelar',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 15),
                              ),
                            ),
                            const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15)),
                            ElevatedButton(
                              onPressed: () {
                                _salvarDespesa();
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: myColor,
                                fixedSize: Size(150, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              child: Text(
                                'Adicionar',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
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

    if (picked != null) {
      setState(() {
        _dataSelecionada = Timestamp.fromDate(picked);
        outrosSelecionado = true;
      });
    }
  }

  void _salvarDespesa() {
    String valorInserido =
        _valorController.text.replaceAll(RegExp(r'[^\d,]'), '');
    valorInserido = valorInserido.replaceAll(',', '.');

    double? valor = double.tryParse(valorInserido);

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
        'tipo': toggleValue ? "Pago" : "Não Pago",
      }).then((_) {
        print("despesa adicionada com sucesso");
      }).catchError((error) {
        print("Falha ao adicionar despesa: $error");
      });
    } else {
      print("Por favor, insira todos os campos corretamente.");
    }
  }

  void toggleButton() {
    setState(() {
      toggleValue = !toggleValue;
      pago = toggleValue ? "Pago" : "Não Pago";
    });
  }
}
