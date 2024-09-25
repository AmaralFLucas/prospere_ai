import 'package:flutter/material.dart';
import 'package:prospere_ai/views/adicionarDespesa.dart';
import 'package:prospere_ai/views/adicionarReceita.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Transacoes extends StatefulWidget {
  Transacoes({Key? key, this.title, required this.userId}) : super(key: key);
  final String? title;
  final String userId;

  @override
  State<Transacoes> createState() => _TransacoesState();
}

Color myColor = Color.fromARGB(255, 30, 163, 132);
Color cardColor = Color(0xFFF4F4F4);
Color textColor = Colors.black87;

class _TransacoesState extends State<Transacoes> with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;

  List<Map<String, dynamic>> receitas = [];
  List<Map<String, dynamic>> despesas = [];

  double totalReceitas = 0.0;
  double totalDespesas = 0.0;
  double saldoAtual = 0.0;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );

    final curvedAnimation = CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    // Buscar dados do banco de dados
    _loadData();
  }

  Future<void> _loadData() async {
    List<Map<String, dynamic>> fetchedReceitas = await getReceitas(widget.userId);
    List<Map<String, dynamic>> fetchedDespesas = await getDespesas(widget.userId);

    // Somar receitas e despesas
    double receitasSum = fetchedReceitas.fold(0.0, (sum, item) => sum + (item['valor'] ?? 0.0));
    double despesasSum = fetchedDespesas.fold(0.0, (sum, item) => sum + (item['valor'] ?? 0.0));
    
    // Atualizar o estado com os valores calculados
    setState(() {
      receitas = fetchedReceitas;
      despesas = fetchedDespesas;
      totalReceitas = receitasSum;
      totalDespesas = despesasSum;
      saldoAtual = totalReceitas - totalDespesas;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: myColor,
        automaticallyImplyLeading: false,
        title: Text(
          'Transações',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildBalanceCard(),
            SizedBox(height: 20),
            _buildTransactionList(),
          ],
        ),
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.all(10),
        child: FloatingActionBubble(
          items: <Bubble>[
            Bubble(
              title: "Adicionar Receita",
              iconColor: Colors.white,
              bubbleColor: myColor,
              icon: Icons.trending_up,
              titleStyle: TextStyle(fontSize: 16, color: Colors.white),
              onPress: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => AdicionarReceita()),
                );
                _animationController.reverse();
              },
            ),
            Bubble(
              title: "Adicionar Despesa",
              iconColor: Colors.white,
              bubbleColor: myColor,
              icon: Icons.trending_down,
              titleStyle: TextStyle(fontSize: 16, color: Colors.white),
              onPress: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => AdicionarDespesa()),
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
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
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
          SizedBox(height: 10),
          Text(
            'R\$ ${saldoAtual.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: myColor,
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildBalanceDetail('Receitas', 'R\$ ${totalReceitas.toStringAsFixed(2)}'),
              Container(
                height: 40,
                width: 1,
                color: Colors.black26,
              ),
              _buildBalanceDetail('Despesas', 'R\$ ${totalDespesas.toStringAsFixed(2)}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceDetail(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        SizedBox(height: 10),
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

  Widget _buildTransactionList() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
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
          ..._buildTransactionItems(),
        ],
      ),
    );
  }

  List<Widget> _buildTransactionItems() {
    List<Widget> transactionItems = [];

    // Adicionar as receitas
    transactionItems.addAll(receitas.map((receita) {
      return Column(
        children: [
          _buildTransactionItem(
            'Receita: ${receita['categoria']}', 
            'R\$ ${receita['valor']}', 
            Colors.white, // Texto das receitas permanece branco
          ),
          SizedBox(height: 10),
        ],
      );
    }).toList());

    // Adicionar as despesas
    transactionItems.addAll(despesas.map((despesa) {
      return Column(
        children: [
          _buildTransactionItem(
            'Despesa: ${despesa['categoria']}', 
            'R\$ ${despesa['valor']}', 
            Colors.red, // Texto das despesas será vermelho
          ),
          SizedBox(height: 10),
        ],
      );
    }).toList());

    return transactionItems;
  }

  Widget _buildTransactionItem(String title, String value, Color textColor) {
    return Container(
      decoration: BoxDecoration(
        color: myColor,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: textColor,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: textColor,
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
  
  return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
}

Future<List<Map<String, dynamic>>> getDespesas(String userId) async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('despesas')
      .get();
  
  return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
}
