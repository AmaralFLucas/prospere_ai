import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prospere_ai/services/autenticacao.dart';
import 'package:prospere_ai/services/bancoDeDados.dart';
import 'package:prospere_ai/views/configuracoes.dart';
import 'package:prospere_ai/views/inteligenciaArtificial.dart';
import 'package:prospere_ai/views/meuCadastro.dart';

class Inicio extends StatefulWidget {
  const Inicio({Key? key, this.title, required this.userId}) : super(key: key);
  final String? title;
  final String userId;

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> with SingleTickerProviderStateMixin {
  late PageController pageController;
  final AutenticacaoServico _autenServico = AutenticacaoServico();
  String uid = FirebaseAuth.instance.currentUser!.uid;

  double totalReceitas = 0.0;
  double totalDespesas = 0.0;
  double saldoAtual = 0.0;
  double totalGasto = 0;
  String selectedFilter = 'Todos';
  double totalGastosPlanejado = 0;
  double totalObjetivosPlanejado = 0;
  double totalObjetivo = 0;

  List<Map<String, dynamic>> categoriasReceitas = [];
  List<Map<String, dynamic>> categoriasDespesas = [];
  List<Map<String, dynamic>> planList = [];

  int initialPosition = 0;
  Color myColor = const Color.fromARGB(255, 30, 163, 132);
  Color myColor2 = const Color.fromARGB(255, 178, 0, 0);
  Color cardColor = const Color(0xFFF4F4F4);
  Color textColor = Colors.black87;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    loadCategorias();
    _loadMetas();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  Future<void> loadCategorias() async {
    categoriasReceitas = await getCategorias(widget.userId, 'receita');
    categoriasDespesas = await getCategorias(widget.userId, 'despesa');
    setState(() {});
  }

  String formatCurrency(dynamic value) {
    // Tenta converter o valor para double, suportando diferentes formatos
    try {
      double parsedValue;

      if (value is String) {
        // Substitui separadores de milhar/decimal se necessário
        String normalizedValue = value.replaceAll('.', '').replaceAll(',', '.');
        parsedValue = double.parse(normalizedValue);
      } else if (value is num) {
        parsedValue = value.toDouble();
      } else {
        throw FormatException("Formato inválido: $value");
      }

      // Formata para o padrão brasileiro de moeda
      final format = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
      return format.format(parsedValue);
    } catch (e) {
      // Retorna um valor padrão ou mensagem de erro em caso de falha
      return 'Valor inválido';
    }
  }

  Future<void> _loadMetas() async {
  String userId = widget.userId; // Certifique-se de que userId está correto

  Stream<QuerySnapshot> metasStream = FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('metasFinanceiras')
      .snapshots();

  metasStream.listen((snapshot) {
    setState(() {
      planList = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final value = data['valorMeta'];
        final spent = (data['valorAtual'] > value) ? value : data['valorAtual'];
        return {
          'id': doc.id,
          'name': data['descricao'],
          'value': value,
          'spent': spent,
          'category': data['categoria'],
          'isExpense': data['tipoMeta'] == 'gastoMensal',
        };
      }).toList();

      // Log para depuração
      print('planList atualizada: ${planList.length}');
    });
  });
}

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredList = planList;
    if (selectedFilter == 'Objetivos') {
      filteredList = planList.where((item) => !item['isExpense']).toList();
    } else if (selectedFilter == 'Gastos') {
      filteredList = planList.where((item) => item['isExpense']).toList();
    }

    // Recalcula os totais baseados na lista filtrada
    double filteredTotalObjetivosPlanejado = filteredList
        .where((item) => !item['isExpense']) // Apenas metas de "objetivo"
        .fold(
            0,
            (sum, item) =>
                sum + item['value']); // Soma os valores das metas de objetivo

    double filteredTotalObjetivo = filteredList
        .where((item) => !item['isExpense']) // Apenas metas de "objetivo"
        .fold(
            0,
            (sum, item) =>
                sum +
                item['spent']); // Soma os valores gastos de metas de objetivo

    double filteredTotalGastosPlanejado = filteredList
        .where((item) => item['isExpense']) // Apenas metas de "gastoMensal"
        .fold(
            0,
            (sum, item) =>
                sum + item['value']); // Soma os valores das metas de gasto

    double filteredTotalGasto = filteredList
        .where((item) => item['isExpense']) // Apenas metas de "gastoMensal"
        .fold(0, (sum, item) => sum + item['spent']); //

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.people, size: 100, color: Colors.white),
                  IconButton(
                    padding: const EdgeInsets.only(left: 135, bottom: 100),
                    icon: const Icon(Icons.settings,
                        size: 25, color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const Configuracoes()),
                      );
                    },
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => MeuCadastro(userId: uid)),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(220, 255, 255, 255),
                minimumSize: const Size(50, 80),
              ),
              child: const Text(
                'Meu Cadastro',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await _autenServico.deslogarUsuario();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(220, 255, 255, 255),
                minimumSize: const Size(50, 80),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Sair',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  Icon(Icons.exit_to_app, color: Colors.red),
                ],
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: myColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.title ?? 'Inicio',
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            Stack(
              children: [
                IconButton(
                  iconSize: 45,
                  splashRadius: 30,
                  icon: Image.asset(
                    'assets/images/porcoia2.png',
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const InteligenciaArtificial(),
                      ),
                    );
                  },
                ),
                Positioned(
                  top: 15,
                  right: 1,
                  child: CircleAvatar(
                    child: Text(
                      "1",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 10, color: Colors.white),
                    ),
                    radius: 8,
                    backgroundColor: Colors.red,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userId)
            .collection('receitas')
            .where('data',
                isGreaterThanOrEqualTo: Timestamp.fromDate(
                    DateTime.now().subtract(const Duration(days: 7))))
            .snapshots(),
        builder: (context, receitasSnapshot) {
          if (!receitasSnapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(widget.userId)
                .collection('despesas')
                .where('data',
                    isGreaterThanOrEqualTo: Timestamp.fromDate(
                        DateTime.now().subtract(const Duration(days: 7))))
                .snapshots(),
            builder: (context, despesasSnapshot) {
              if (!despesasSnapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              List<Map<String, dynamic>> receitas = receitasSnapshot.data!.docs
                  .map((doc) => doc.data() as Map<String, dynamic>)
                  .toList();
              List<Map<String, dynamic>> despesas = despesasSnapshot.data!.docs
                  .map((doc) => doc.data() as Map<String, dynamic>)
                  .toList();

              totalReceitas = receitas.fold(
                  0.0, (sum, item) => sum + (item['valor'] ?? 0.0));
              totalDespesas = despesas.fold(
                  0.0, (sum, item) => sum + (item['valor'] ?? 0.0));
              saldoAtual = totalReceitas - totalDespesas;

              List<Map<String, dynamic>> transacoes =
                  despesas.map((d) => {...d, 'tipo': 'despesa'}).toList();

              transacoes.sort((a, b) =>
                  (b['data'] as Timestamp).compareTo(a['data'] as Timestamp));

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildBalanceCard(),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (selectedFilter !=
                            'Gastos') // Mostra apenas para "Todos" ou "Objetivos"
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(16),
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
                              child: _buildFilteredObjectiveChart(
                                filteredTotalObjetivo,
                                filteredTotalObjetivosPlanejado,
                              ),
                            ),
                          ),
                        if (selectedFilter !=
                            'Objetivos') // Mostra apenas para "Todos" ou "Gastos"
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: cardColor,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color.fromARGB(31, 32, 32, 32),
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: _buildFilteredExpenseChart(
                                filteredTotalGasto,
                                filteredTotalGastosPlanejado,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildTransactionList(transacoes),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
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
            '${formatCurrency(saldoAtual)}',
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
                '${formatCurrency(totalReceitas)}',
                myColor, // Verde para receitas
              ),
              Container(
                height: 40,
                width: 1,
                color: Colors.black26,
              ),
              _buildBalanceDetail(
                'Despesas',
                '${formatCurrency(totalDespesas)}',
                myColor2, // Vermelho para despesas
              ),
            ],
          ),
        ],
      ),
    );
  }

   Widget _buildFilteredObjectiveChart(double totalSpent, double totalPlanned) {
    double spentPercentage = totalPlanned > 0 ? (totalSpent / totalPlanned) * 100 : 0;
    double remainingPercentage = 100 - spentPercentage;

    return Center(
      child: Column(
        children: [
          const Text(
            'Planejamento de Objetivos',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 25),
          SizedBox(
            width: 150,
            height: 150,
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    color: const Color.fromARGB(255, 30, 163, 132),
                    value: spentPercentage,
                    title: '${spentPercentage.toStringAsFixed(1)}%',
                  ),
                  PieChartSectionData(
                    color: Colors.grey,
                    value: remainingPercentage,
                    title: '${remainingPercentage.toStringAsFixed(1)}%',
                  ),
                ],
                borderData: FlBorderData(show: false),
                sectionsSpace: 0,
                centerSpaceRadius: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilteredExpenseChart(double totalSpent, double totalPlanned) {
    double spentPercentage = totalPlanned > 0 ? (totalSpent / totalPlanned) * 100 : 0;
    double remainingPercentage = 100 - spentPercentage;

    return Center(
      child: Column(
        children: [
          const Text(
            'Planejamento de Gastos Mensais',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 25),
          SizedBox(
            width: 150,
            height: 150,
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    color: Colors.red,
                    value: spentPercentage,
                    title: '${spentPercentage.toStringAsFixed(1)}%',
                  ),
                  PieChartSectionData(
                    color: const Color.fromARGB(255, 30, 163, 132),
                    value: remainingPercentage,
                    title: '${remainingPercentage.toStringAsFixed(1)}%',
                  ),
                ],
                borderData: FlBorderData(show: false),
                sectionsSpace: 0,
                centerSpaceRadius: 40,
              ),
            ),
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
            color: valueColor,
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

  Widget _buildTransactionList(List<Map<String, dynamic>> transacoes) {
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
          ..._buildTransactionItems(transacoes),
        ],
      ),
    );
  }

  List<Widget> _buildTransactionItems(List<Map<String, dynamic>> transacoes) {
    List<Widget> transactionItems = [];

    transactionItems.addAll(transacoes.map((transacao) {
      Color cor = transacao['tipo'] == 'receita' ? myColor : myColor2;
      Timestamp timestamp = transacao['data'] as Timestamp;
      DateTime dateTime = timestamp.toDate();
      String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);

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

      bool isTravelMode = transacao['modoViagem'] ?? false;

      return Column(
        children: [
          _buildTransactionItem(
            '${transacao['categoria']}',
            '${formatCurrency(transacao['valor'])}',
            'Data: $formattedDate',
            cor,
            iconeCategoria,
            isTravelMode,
          ),
          const SizedBox(height: 10),
        ],
      );
    }).toList());

    return transactionItems;
  }

  Widget _buildTransactionItem(String title, String value, String data,
      Color textColor, IconData icone, bool isTravelMode) {
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
              if (isTravelMode)
                Icon(Icons.airplanemode_active,
                    color: myColor2, size: 16), // Ícone menor do avião
              const SizedBox(width: 5),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  color: textColor,
                ),
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
}

Future<List<Map<String, dynamic>>> getReceitas(String userId) async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('receitas')
      .get();

  return snapshot.docs
      .map((doc) => doc.data() as Map<String, dynamic>)
      .toList();
}

Future<List<Map<String, dynamic>>> getDespesas(String userId) async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('despesas')
      .get();

  return snapshot.docs
      .map((doc) => doc.data() as Map<String, dynamic>)
      .toList();
}
