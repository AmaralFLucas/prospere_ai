import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:prospere_ai/components/meu_snackbar.dart';
import 'package:prospere_ai/services/bancoDeDados.dart';
import 'package:string_similarity/string_similarity.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prospere_ai/components/textFormatter.dart';

class AdicionarReceita extends StatefulWidget {
  final double? valorReceita;
  final String? valorFormatado;
  final String? categoriaAudio;
  final Timestamp? data;

  const AdicionarReceita(
      {super.key,
      this.valorReceita,
      this.valorFormatado,
      this.categoriaAudio,
      this.data});

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
  List<String> categorias = [];

  final TextEditingController _valorController = TextEditingController();
  final TextEditingController _categoriaController = TextEditingController();
  Timestamp? _dataSelecionada;
  bool outrosSelecionado = false;

  @override
  void initState() {
    super.initState();
    _carregarCategorias();

    isSelected = [
      false,
      false,
      false
    ]; // Nenhuma opção selecionada inicialmente
    if (widget.valorFormatado != null) {
      _valorController.text = widget.valorFormatado!;
    } else if (widget.valorReceita != null) {
      _valorController.text =
          widget.valorReceita!.toStringAsFixed(2).replaceAll('.', ',');
    }

    if (widget.data != null) {
      DateTime hoje = DateTime.now();
      DateTime ontem = hoje.subtract(Duration(days: 1));
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

  // Função para formatar o valor inserido com vírgulas
  TextInputFormatter _getInputFormatter() {
    return LengthLimitingTextInputFormatter(
        15); // Limita o tamanho total do valor para 12 caracteres
  }

  Future<void> _carregarCategorias() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('categoriasReceitas')
        .get();

    setState(() {
      categorias = snapshot.docs.map((doc) => doc['nome'] as String).toList();
      if (widget.categoriaAudio != null && widget.categoriaAudio!.isNotEmpty) {
        String categoriaAudioNormalizada =
            widget.categoriaAudio!.toLowerCase().trim();
        String? categoriaCorrespondente;
        double melhorSimilaridade = 0.0;

        for (String categoria in categorias) {
          String categoriaNormalizada = categoria.toLowerCase().trim();
          double similaridade =
              categoriaAudioNormalizada.similarityTo(categoriaNormalizada);

          if (similaridade > melhorSimilaridade) {
            melhorSimilaridade = similaridade;
            categoriaCorrespondente = categoria;
          }
        }
        if (melhorSimilaridade > 0.8) {
          categoria = categoriaCorrespondente;
          _categoriaController.text = categoria!;
        }
      }
    });
  }

  Widget _buildDateSelection() {
    String getDataSelecionadaLabel(DateTime dataSelecionada) {
      DateTime hoje = DateTime.now();
      DateTime ontem = hoje.subtract(Duration(days: 1));

      if (dataSelecionada.year == hoje.year &&
          dataSelecionada.month == hoje.month &&
          dataSelecionada.day == hoje.day) {
        return '${dataSelecionada.day}/${dataSelecionada.month}/${dataSelecionada.year}';
      } else if (dataSelecionada.year == ontem.year &&
          dataSelecionada.month == ontem.month &&
          dataSelecionada.day == ontem.day) {
        return '${dataSelecionada.day}/${dataSelecionada.month}/${dataSelecionada.year}';
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
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                        const Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Text(
                              'Valor total Receita',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            )),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _valorController,
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                inputFormatters: [
                                  CurrencyTextInputFormatter(), // Usando a formatação de moeda
                                  _getInputFormatter() // Limitando o número de caracteres
                                ],
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
                                  recebido,
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
                              onPressed: () async {
                                String valorInserido = _valorController.text
                                    .replaceAll(RegExp(r'[^\d,]'), '')
                                    .replaceAll(',', '.');
                                double? valor = double.tryParse(valorInserido);

                                if (valor != null &&
                                    categoria != null &&
                                    _dataSelecionada != null) {
                                  try {
                                    await addReceita(
                                        uid,
                                        valor,
                                        categoria!,
                                        _dataSelecionada!,
                                        toggleValue
                                            ? "Recebido"
                                            : "Não Recebido");
                                    Navigator.of(context).pop();
                                  } catch (error) {
                                    mostrarSnackBar(
                                        context: context,
                                        texto:
                                            "Falha ao adicionar despesa. Tente novamente.");
                                  }
                                } else {
                                  mostrarSnackBar(
                                      context: context,
                                      texto:
                                          "Por favor, preencha todos os campos corretamente.");
                                }
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
          // ),
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
}
