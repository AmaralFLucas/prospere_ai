import 'package:flutter/material.dart';
import 'package:prospere_ai/services/bancoDeDados.dart';
import 'package:prospere_ai/views/adicionarDespesa.dart';
import 'package:prospere_ai/views/adicionarReceita.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Transacoes extends StatefulWidget {
  const Transacoes({Key? key, this.title, required this.userId})
      : super(key: key);
  final String? title;
  final String userId;

  @override
  State<Transacoes> createState() => _TransacoesState();
}

Color myColor = const Color.fromARGB(255, 30, 163, 132);
Color myColor2 = const Color.fromARGB(255, 178, 0, 0);
Color cardColor = const Color(0xFFF4F4F4);
Color textColor = Colors.black87;

class _TransacoesState extends State<Transacoes>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;
  String? selectedPeriodo;
  String? selectedTipo;
  List<Map<String, dynamic>> transactions = [];
  DateTimeRange? selectedDateRange;
  double totalReceitas = 0.0;
  double totalDespesas = 0.0;
  double saldoAtual = 0.0;

  List<Map<String, dynamic>> categoriasReceitas = [];
  List<Map<String, dynamic>> categoriasDespesas = [];

  @override
  void initState() {
    super.initState();
    loadCategorias();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    _fetchTransactions();
  }

  Future<void> loadCategorias() async {
    categoriasReceitas = await getCategorias(widget.userId, 'receita');
    categoriasDespesas = await getCategorias(widget.userId, 'despesa');
    setState(
        () {}); // Atualizar o estado para garantir que os ícones sejam carregados
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: myColor,
        automaticallyImplyLeading: false,
        title: const Text(
          'Transações',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userId)
            .collection('receitas')
            .snapshots(),
        builder: (context, receitasSnapshot) {
          if (!receitasSnapshot.hasData)
            return Center(child: CircularProgressIndicator());
          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(widget.userId)
                .collection('despesas')
                .snapshots(),
            builder: (context, despesasSnapshot) {
              if (!despesasSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              // Obter dados das coleções
              List<Map<String, dynamic>> receitas = receitasSnapshot.data!.docs
                  .map((doc) => doc.data() as Map<String, dynamic>)
                  .toList();
              List<Map<String, dynamic>> despesas = despesasSnapshot.data!.docs
                  .map((doc) => doc.data() as Map<String, dynamic>)
                  .toList();

              // Calcular totais
              totalReceitas = receitas.fold(
                  0.0, (sum, item) => sum + (item['valor'] ?? 0.0));
              totalDespesas = despesas.fold(
                  0.0, (sum, item) => sum + (item['valor'] ?? 0.0));
              saldoAtual = totalReceitas - totalDespesas;

              // Combinar transações e aplicar filtros
              // Combinar transações e aplicar filtros
              List<Map<String, dynamic>> transacoes = [
                ...receitasSnapshot.data!.docs.map((doc) => {
                      ...doc.data() as Map<String, dynamic>,
                      'docId': doc.id,
                      'tipo': 'receita',
                    }),
                ...despesasSnapshot.data!.docs.map((doc) => {
                      ...doc.data() as Map<String, dynamic>,
                      'docId': doc.id,
                      'tipo': 'despesa',
                    }),
              ];
              print(transacoes);
              // Ordenar e filtrar
              transacoes.sort((a, b) =>
                  (b['data'] as Timestamp).compareTo(a['data'] as Timestamp));
              List<Map<String, dynamic>> transacoesFiltradas =
                  _filterTransactions(transacoes);

              // Construir o layout
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildBalanceCard(),
                    const SizedBox(height: 20),
                    _buildTransactionList(transacoesFiltradas, widget.userId),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: FloatingActionBubble(
          items: <Bubble>[
            Bubble(
              title: "Adicionar Receita",
              iconColor: Colors.white,
              bubbleColor: myColor,
              icon: Icons.trending_up,
              titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
              onPress: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          const AdicionarReceita()),
                );
                _animationController.reverse();
              },
            ),
            Bubble(
              title: "Adicionar Despesa",
              iconColor: Colors.white,
              bubbleColor: myColor2,
              icon: Icons.trending_down,
              titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
              onPress: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          const AdicionarDespesa()),
                );
                _animationController.reverse();
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  List<Map<String, dynamic>> _filterTransactions(
      List<Map<String, dynamic>> transacoes) {
    DateTime now = DateTime.now();

    return transacoes.where((transaction) {
      DateTime transactionDate = (transaction['data'] as Timestamp).toDate();

      bool dateMatch = selectedPeriodo == 'Hoje'
          ? isSameDay(transactionDate, now)
          : selectedPeriodo == 'Semana'
              ? transactionDate
                  .isAfter(now.subtract(Duration(days: now.weekday)))
              : selectedPeriodo == 'Mês'
                  ? transactionDate.month == now.month &&
                      transactionDate.year == now.year
                  : selectedPeriodo == 'Período' && selectedDateRange != null
                      ? transactionDate.isAfter(selectedDateRange!.start) &&
                          transactionDate.isBefore(selectedDateRange!.end
                              .add(const Duration(days: 1)))
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
                              selectedDateRange = null;
                            });
                          },
                        ),
                        _buildToggleButton(
                          label: 'Semana',
                          isSelected: tempSelectedPeriodo == 'Semana',
                          onTap: () {
                            setState(() {
                              tempSelectedPeriodo = 'Semana';
                              selectedDateRange = null;
                            });
                          },
                        ),
                        _buildToggleButton(
                          label: 'Mês',
                          isSelected: tempSelectedPeriodo == 'Mês',
                          onTap: () {
                            setState(() {
                              tempSelectedPeriodo = 'Mês';
                              selectedDateRange = null;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        DateTimeRange? range = await showDateRangePicker(
                          context: context,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                          initialDateRange: selectedDateRange,
                          builder: (BuildContext context, Widget? child) {
                            return Theme(
                              data: ThemeData(
                                primaryColor: Colors.black,
                                colorScheme: ColorScheme.light(
                                  primary: myColor,
                                  onPrimary: Colors.white,
                                  onSurface: myColor,
                                ),
                                textButtonTheme: TextButtonThemeData(
                                  style: TextButton.styleFrom(
                                    foregroundColor: myColor,
                                    textStyle: TextStyle(color: Colors.white),
                                  ),
                                ),
                                iconButtonTheme: IconButtonThemeData(
                                  style: IconButton.styleFrom(
                                      foregroundColor: myColor),
                                ),
                                appBarTheme: AppBarTheme(
                                  backgroundColor: myColor, // Cor do cabeçalho
                                  iconTheme: IconThemeData(
                                      color:
                                          Colors.white), // Ícones no cabeçalho
                                  titleTextStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ), // Estilo do texto do título
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (range != null) {
                          setState(() {
                            selectedDateRange = range;
                            tempSelectedPeriodo = 'Período';
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        selectedDateRange == null
                            ? 'Selecionar Período'
                            : '${DateFormat('dd/MM/yyyy').format(selectedDateRange!.start)} - ${DateFormat('dd/MM/yyyy').format(selectedDateRange!.end)}',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
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
                        selectedDateRange = null;
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

  Widget _buildBalanceCard() {
    Color saldoColor = saldoAtual >= 0 ? myColor : myColor2;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'Saldo Atual',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'R\$ ${saldoAtual.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: saldoColor, // Usar a cor dinâmica do saldo
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildBalanceDetail(
                'Receitas',
                'R\$ ${totalReceitas.toStringAsFixed(2)}',
                myColor, // Verde para receitas
              ),
              Container(
                height: 40,
                width: 1,
                color: Colors.black26,
              ),
              _buildBalanceDetail(
                'Despesas',
                'R\$ ${totalDespesas.toStringAsFixed(2)}',
                myColor2, // Vermelho para despesas
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceDetail(String title, String value, Color valueColor) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: valueColor, // Usar a cor dinâmica para valores
          ),
        ),
        const SizedBox(height: 10),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: textColor.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionList(
      List<Map<String, dynamic>> transacoes, String userId) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ..._buildTransactionItems(transacoes, userId),
        ],
      ),
    );
  }

  List<Widget> _buildTransactionItems(
      List<Map<String, dynamic>> transacoes, String userId) {
    List<Widget> transactionItems = [];

    transactionItems.addAll(transacoes.map((transacao) {
      Color cor = transacao['tipo'] == 'receita' ? myColor : myColor2;
      Timestamp timestamp = transacao['data'] as Timestamp;
      DateTime dateTime = timestamp.toDate();
      String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);

      // Obter o ícone correspondente à categoria
      Map<String, dynamic>? categoria = (transacao['tipo'] == 'receita')
          ? categoriasReceitas.firstWhere(
              (cat) => cat['nome'] == transacao['categoria'],
              orElse: () => {'icone': Icons.category.codePoint})
          : categoriasDespesas.firstWhere(
              (cat) => cat['nome'] == transacao['categoria'],
              orElse: () => {'icone': Icons.category.codePoint});

      IconData iconeCategoria;
      if (categoria['icone'] != null) {
        iconeCategoria =
            IconData(categoria['icone'], fontFamily: 'MaterialIcons');
      } else {
        iconeCategoria = Icons.category;
      }

      return Column(
        children: [
          _buildTransactionItem(
            userId,
            transacao['docId'], // Passa o ID do documento para exclusão
            transacao['tipo'],
            '${transacao['categoria']}',
            'R\$ ${transacao['valor']}',
            'Data: $formattedDate',
            cor,
            iconeCategoria,
          ),
          const SizedBox(height: 10),
        ],
      );
    }).toList());

    return transactionItems;
  }

  Widget _buildTransactionItem(
      String userId,
      String docId,
      String tipo,
      String title,
      String value,
      String data,
      Color textColor,
      IconData icone) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icone, color: textColor),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: textColor,
                ),
              ),
              Spacer(),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  color: textColor,
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete_forever_outlined, color: myColor2),
                onPressed: () {
                  _confirmarExclusao(userId, docId, tipo);
                },
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            data,
            style: TextStyle(
              fontSize: 14,
              color: const Color.fromARGB(255, 105, 105, 105),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmarExclusao(String userId, String docId, String tipo) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmar Exclusão'),
          content: Text('Tem certeza de que deseja excluir esta transação?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _excluirTransacao(userId, docId, tipo);
              },
              child: Text('Excluir'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _excluirTransacao(
      String userId, String docId, String tipo) async {
    try {
      if (tipo == 'receita') {
        await excluirReceita(userId, docId);
      } else {
        await excluirDespesa(userId, docId);
      }
      // Atualizar a lista de transações após a exclusão (depende da sua lógica de estado)
      // Exemplo: setState(() => _fetchTransacoes());
    } catch (e) {
      print('Erro ao excluir transação: $e');
    }
  }
}
