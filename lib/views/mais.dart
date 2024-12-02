import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Para formatar datas
import 'package:prospere_ai/views/categoriasReceitas.dart';
import 'package:prospere_ai/views/relatorio.dart';

class Mais extends StatefulWidget {
  final bool? toggleValue;

  const Mais({super.key, this.toggleValue});

  @override
  State<Mais> createState() => _MaisState();
}

Color myColor = const Color(0xFF1EA384);

class _MaisState extends State<Mais> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  bool toggleValue = false;

  @override
void initState() {
  super.initState();
  _loadTravelMode();
}

// Carrega o estado do modo viagem e verifica a data final
Future<void> _loadTravelMode() async {
  try {
    CollectionReference meuCadastro = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('meuCadastro');

    final querySnapshot = await meuCadastro.get();

    if (querySnapshot.docs.isNotEmpty) {
      final data = querySnapshot.docs.first.data() as Map<String, dynamic>;

      bool travelMode = data['travelMode'] ?? false;
      String? travelEndDateStr = data['travelEndDate'];
      DateTime? travelEndDate = travelEndDateStr != null
          ? DateTime.parse(travelEndDateStr)
          : null;

      // Verifica se o modo viagem precisa ser desativado
      if (travelMode && travelEndDate != null) {
        if (DateTime.now().isAfter(travelEndDate)) {
          // Desativa automaticamente o modo viagem
          await _updateTravelMode(false);
          travelMode = false;
        }
      }

      setState(() {
        toggleValue = travelMode;
      });
    } else {
      print("Nenhum cadastro encontrado para o usuário.");
    }
  } catch (e) {
    print('Erro ao carregar o modo viagem: $e');
  }
}

// Atualiza o cadastro no Firestore
Future<void> _updateTravelMode(bool value, {DateTime? endDate}) async {
  try {
    CollectionReference meuCadastro = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('meuCadastro');

    final querySnapshot = await meuCadastro.get();

    if (querySnapshot.docs.isNotEmpty) {
      final documentId = querySnapshot.docs.first.id;

      await meuCadastro.doc(documentId).update({
        'travelMode': value,
        'travelEndDate': endDate?.toIso8601String(),
      });
    } else {
      print("Nenhum cadastro encontrado para o usuário.");
    }
  } catch (e) {
    print('Erro ao atualizar o modo viagem: $e');
  }
}

  // Exibe o diálogo para configurar o modo viagem
  Future<void> _showTravelDialog() async {
  DateTime? selectedDate;

  final bool? confirmed = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: const Text('Modo Viagem'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: [
                      const TextSpan(
                        text: 'O modo viagem está ativado! Durante o período informado, todas as despesas serão marcadas com o ícone de ',
                      ),
                      WidgetSpan(
                        child: Icon(
                          Icons.airplanemode_active,
                          color: myColor,
                          size: 20,
                        ),
                      ),
                      const TextSpan(
                        text: '.',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        selectedDate = pickedDate;
                      });
                    }
                  },
                  child: const Text('Escolher Data Final'),
                ),
                if (selectedDate != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      'Data selecionada: ${DateFormat('dd/MM/yyyy').format(selectedDate!)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false); // Retorna "false" ao cancelar
                },
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  if (selectedDate != null) {
                    Navigator.of(context).pop(true); // Retorna "true" ao confirmar
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Por favor, escolha uma data.')),
                    );
                  }
                },
                child: const Text('Confirmar'),
              ),
            ],
          );
        },
      );
    },
  );

  // Confirmar ou cancelar a ativação do modo viagem
  if (confirmed == true && selectedDate != null) {
    await _updateTravelMode(true, endDate: selectedDate);
  } else {
    setState(() {
      toggleValue = false; // Reverte o estado do switch
    });
  }
}

  Widget buildNavigationOption(String title, IconData icon, VoidCallback onTap,
      {Widget? trailing}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: myColor, size: 30),
            const SizedBox(width: 20),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const Spacer(),
            trailing ?? const Icon(Icons.arrow_forward_ios, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: myColor,
        automaticallyImplyLeading: false,
        title: const Text(
          'Mais Opções',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          buildNavigationOption('Categorias', Icons.category, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Categoria(userId: uid)),
            );
          }),
          buildNavigationOption(
            'Modo Viagem',
            Icons.airplanemode_active,
            () {},
            trailing: Switch(
              value: toggleValue,
              onChanged: (bool newValue) {
                setState(() {
                  toggleValue = newValue;
                });
                if (newValue) {
                  _showTravelDialog();
                } else {
                  _updateTravelMode(false);
                }
              },
              activeColor: Colors.white,
              activeTrackColor: myColor,
              inactiveTrackColor: Colors.grey[300],
              inactiveThumbColor: Colors.white,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          buildNavigationOption('Relatório', Icons.bar_chart, () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Relatorio(
                        userId: uid,
                      )),
            );
          }),
        ],
      ),
    );
  }
}
