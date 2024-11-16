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

  double totalReceitas = 0.0;
  double totalDespesas = 0.0;
  double saldoAtual = 0.0;

  List<Map<String, dynamic>> categoriasReceitas = [];
  List<Map<String, dynamic>> categoriasDespesas = [];

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

    // Carregar categorias de receitas e despesas e atualizar o estado
    loadCategorias();
  }

  Future<void> loadCategorias() async {
    categoriasReceitas = await getCategorias(widget.userId, 'receita');
    categoriasDespesas = await getCategorias(widget.userId, 'despesa');
    setState(
        () {}); // Atualizar o estado para garantir que os ícones sejam carregados
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
              if (!despesasSnapshot.hasData)
                return Center(child: CircularProgressIndicator());

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

              List<Map<String, dynamic>> transacoes = [];
              transacoes.addAll(receitas.map((r) => {...r, 'tipo': 'receita'}));
              transacoes.addAll(despesas.map((d) => {...d, 'tipo': 'despesa'}));

              transacoes.sort((a, b) =>
                  (b['data'] as Timestamp).compareTo(a['data'] as Timestamp));

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildBalanceCard(),
                    const SizedBox(height: 20),
                    _buildTransactionList(transacoes),
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

  Widget _buildBalanceCard() {
  Color saldoColor = saldoAtual >= 0 ? myColor: myColor2;
  
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
            color: valueColor,
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
            '${transacao['categoria']}',
            'R\$ ${transacao['valor']}',
            'Data: $formattedDate',
            cor,
            iconeCategoria, // Passar o ícone da categoria
          ),
          const SizedBox(height: 10),
        ],
      );
    }).toList());

    return transactionItems;
  }

  Widget _buildTransactionItem(String title, String value, String data,
      Color textColor, IconData icone) {
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
              Icon(icone, color: textColor), // Exibir o ícone aqui
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
