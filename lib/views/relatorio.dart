import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Relatorio extends StatefulWidget {
  final String? title;
  final String? userId;
  Relatorio({Key? key, this.title, required this.userId}) : super(key: key);

  @override
  State<Relatorio> createState() => _RelatorioState();
}

Color myColor = const Color.fromARGB(255, 30, 163, 132);
Color cardColor = const Color(0xFFF4F4F4);
Color textColor = Colors.black87;

class _RelatorioState extends State<Relatorio>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;
  String? selectedPeriodo;
  String? selectedTipo;
  List<Map<String, dynamic>> transactions = [];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    _fetchTransactions();
  }

  void _fetchTransactions() async {
    QuerySnapshot receitasSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .collection('receitas')
        .get();
    QuerySnapshot despesasSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .collection('despesas')
        .get();

    List<Map<String, dynamic>> receitas = receitasSnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
    List<Map<String, dynamic>> despesas = despesasSnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();

    setState(() {
      transactions = [
        ...receitas.map((r) => {...r, 'tipo': 'receita'}),
        ...despesas.map((d) => {...d, 'tipo': 'despesa'})
      ];
    });
  }

  List<Map<String, dynamic>> _filterTransactions() {
    DateTime now = DateTime.now();
    return transactions.where((transaction) {
      DateTime transactionDate = (transaction['data'] as Timestamp).toDate();

      bool dateMatch = selectedPeriodo == 'Hoje'
          ? isSameDay(transactionDate, now)
          : selectedPeriodo == 'Semana'
              ? transactionDate
                  .isAfter(now.subtract(Duration(days: now.weekday)))
              : selectedPeriodo == 'Mês'
                  ? transactionDate.month == now.month &&
                      transactionDate.year == now.year
                  : true;

      bool typeMatch = selectedTipo == 'Receita'
          ? transaction['tipo'] == 'receita'
          : selectedTipo == 'Despesa'
              ? transaction['tipo'] == 'despesa'
              : true;

      return dateMatch && typeMatch;
    }).toList();
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  void _showFilterDialog(BuildContext context) {
    String? tempSelectedPeriodo = selectedPeriodo;
    String? tempSelectedTipo = selectedTipo;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Filtrar Relatório',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Selecione o período do relatório',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildToggleButton(
                          label: 'Hoje',
                          isSelected: tempSelectedPeriodo == 'Hoje',
                          onTap: () {
                            setState(() {
                              tempSelectedPeriodo = 'Hoje';
                            });
                          },
                        ),
                        _buildToggleButton(
                          label: 'Semana',
                          isSelected: tempSelectedPeriodo == 'Semana',
                          onTap: () {
                            setState(() {
                              tempSelectedPeriodo = 'Semana';
                            });
                          },
                        ),
                        _buildToggleButton(
                          label: 'Mês',
                          isSelected: tempSelectedPeriodo == 'Mês',
                          onTap: () {
                            setState(() {
                              tempSelectedPeriodo = 'Mês';
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text('Selecione o tipo de relatório',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildToggleButton(
                          label: 'Receita',
                          isSelected: tempSelectedTipo == 'Receita',
                          onTap: () {
                            setState(() {
                              tempSelectedTipo = 'Receita';
                            });
                          },
                        ),
                        _buildToggleButton(
                          label: 'Despesa',
                          isSelected: tempSelectedTipo == 'Despesa',
                          onTap: () {
                            setState(() {
                              tempSelectedTipo = 'Despesa';
                            });
                          },
                        ),
                        _buildToggleButton(
                          label: 'Todos',
                          isSelected: tempSelectedTipo == 'Todos',
                          onTap: () {
                            setState(() {
                              tempSelectedTipo = 'Todos';
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: () {
                      setState(() {
                        selectedPeriodo = '';
                        selectedTipo = '';
                      });
                      Navigator.of(context).pop();
                    },
                    child: Text('Limpar')),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancelar',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedPeriodo = tempSelectedPeriodo;
                          selectedTipo = tempSelectedTipo;
                        });
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: myColor),
                      child: const Text('Salvar'),
                    ),
                  ],
                )
              ],
            )
          ],
        );
      },
    );
  }

  Widget _buildToggleButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected ? myColor : Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _exportToExcel() async {
    var excel = Excel.createExcel();

    excel['Relatório'].appendRow(['Descrição', 'Tipo', 'Data', 'Valor']);

    for (var transaction in _filterTransactions()) {
      DateTime transactionDate = (transaction['data'] as Timestamp).toDate();
      excel['Relatório'].appendRow([
        transaction['descricao'] ?? 'Descrição não disponível',
        transaction['tipo'] ?? '',
        DateFormat('dd/MM/yyyy').format(transactionDate),
        transaction['valor'] ?? 0,
      ]);
    }

    var dir = '/storage/emulated/0/Download';
    String filePath = "${dir}/relatorio.xlsx";
    File(filePath)
      ..createSync(recursive: true)
      ..writeAsBytesSync(excel.encode()!);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Relatório Excel salvo em $filePath'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatório'),
        backgroundColor: myColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined),
            onPressed: () {
              _showFilterDialog(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildBalanceCard(),
            const SizedBox(height: 20),
            _buildTransactionList(),
          ],
        ),
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.all(10),
        child: FloatingActionBubble(
          items: <Bubble>[
            Bubble(
              title: "PDF",
              iconColor: Colors.white,
              bubbleColor: const Color.fromARGB(255, 178, 0, 0),
              icon: Icons.article_outlined,
              titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
              onPress: () {
                _animationController.reverse();
              },
            ),
            Bubble(
              title: "EXCEL",
              iconColor: Colors.white,
              bubbleColor: myColor,
              icon: Icons.article_outlined,
              titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
              onPress: () {
                _animationController.reverse();
                _exportToExcel(); // Chama a função de exportação
              },
            ),
          ],
          animation: _animation,
          onPress: () => _animationController.isCompleted
              ? _animationController.reverse()
              : _animationController.forward(),
          iconColor: Colors.white,
          iconData: Icons.add,
          backGroundColor: myColor,
        ),
      ),
    );
  }

  Widget _buildBalanceCard() {
    double totalReceitas = transactions
        .where((t) => t['tipo'] == 'receita')
        .fold(0, (sum, t) => sum + (t['valor'] as num).toDouble());
    double totalDespesas = transactions
        .where((t) => t['tipo'] == 'despesa')
        .fold(0, (sum, t) => sum + (t['valor'] as num).toDouble());
    double saldo = totalReceitas - totalDespesas;

    return Card(
      color: cardColor,
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Saldo',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('R\$ ${saldo.toStringAsFixed(2)}',
                style: TextStyle(
                    fontSize: 20,
                    color: saldo >= 0 ? Colors.green : Colors.red)),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionList() {
    List<Map<String, dynamic>> filteredTransactions = _filterTransactions();

    if (filteredTransactions.isEmpty) {
      return const Center(child: Text('Nenhuma transação encontrada.'));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredTransactions.length,
      itemBuilder: (context, index) {
        final transaction = filteredTransactions[index];
        DateTime transactionDate = (transaction['data'] as Timestamp).toDate();
        print(transactionDate);
        return Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            title: Text(transaction['descricao'] ??
                'Descrição não disponível'), // Garantindo que a descrição não seja nula
            subtitle: Text(DateFormat('dd/MM/yyyy').format(transactionDate)),
            trailing: Text(
                'R\$ ${(transaction['valor'] ?? 0).toStringAsFixed(2)}'), // Garantindo que o valor não seja nulo
          ),
        );
      },
    );
  }
}
