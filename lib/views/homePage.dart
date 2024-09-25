import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prospere_ai/components/customBottomAppBar.dart';
import 'package:prospere_ai/services/autenticacao.dart';
import 'package:prospere_ai/views/configuracoes.dart';
import 'package:prospere_ai/views/login.dart';
import 'package:prospere_ai/views/mais.dart';
import 'package:prospere_ai/views/meuCadastro.dart';
import 'package:prospere_ai/views/planejamento.dart';
import 'package:prospere_ai/views/transacoes.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, this.title, required this.userId})
      : super(key: key);
  final String? title;
  final String userId;

  @override
  State<HomePage> createState() => _HomePageState();
}

late PageController pageController = PageController();
int initialPosition = 0;
bool mostrarSenha = true;
Color myColor = Color.fromARGB(255, 30, 163, 132);
Color cardColor = Color(0xFFF4F4F4);
Color textColor = Colors.black87;
Icon eyeIcon = Icon(Icons.visibility_off);

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  AutenticacaoServico _autenServico = AutenticacaoServico();
  String uid = FirebaseAuth.instance.currentUser!.uid;
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
    pageController = PageController();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    // Buscar dados do banco de dados
    _loadData();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void _onTabSelected(int index) {
    setState(() {
      initialPosition = index;
      pageController.jumpToPage(index);
    });
  }

  void _onFabPressed() {}

  Future<void> _loadData() async {
    List<Map<String, dynamic>> fetchedReceitas =
        await getReceitas(widget.userId);
    List<Map<String, dynamic>> fetchedDespesas =
        await getDespesas(widget.userId);

    // Somar receitas e despesas
    double receitasSum =
        fetchedReceitas.fold(0.0, (sum, item) => sum + (item['valor'] ?? 0.0));
    double despesasSum =
        fetchedDespesas.fold(0.0, (sum, item) => sum + (item['valor'] ?? 0.0));

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
      body: PageView(
        controller: pageController,
        onPageChanged: (index) {
          setState(() {
            initialPosition = index;
          });
        },
        children: [
          Scaffold(
            drawer: Drawer(
              child: ListView(
                children: <Widget>[
                  DrawerHeader(
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.people,
                              size: 100, color: Colors.white),
                          IconButton(
                            padding: EdgeInsets.only(left: 135, bottom: 100),
                            icon: const Icon(
                              Icons.settings,
                              size: 25,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const Configuracoes()));
                            },
                          ),
                        ],
                      )),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const MeuCadastro()));
                    },
                    child: const Text(
                      'Meu Cadastro',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(220, 255, 255, 255),
                      minimumSize: Size(50, 80),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        await _autenServico.deslogarUsuario();
                        // Navigator.of(context).pushReplacement(MaterialPageRoute(
                        //   builder: (context) => Login(),
                        // ));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(220, 255, 255, 255),
                        minimumSize: Size(50, 80),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Sair',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          Icon(
                            Icons.exit_to_app,
                            color: Colors.red,
                          ),
                        ],
                      )),
                ],
              ),
            ),
            appBar: AppBar(
              backgroundColor: myColor,
              leading: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: Icon(Icons.person),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  );
                },
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildBalanceCard(),
                  SizedBox(height: 20),
                  _buildTransactionList(),
                ],
              ),
            ),
          ),
          Transacoes(userId: uid),
          Planejamento(),
          Mais(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.mic),
        backgroundColor: myColor,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomBottomAppBar(
        myColor: myColor,
        selectedIndex: initialPosition,
        onTabSelected: _onTabSelected,
        onFabPressed: _onFabPressed,
      ),
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
              _buildBalanceDetail(
                  'Receitas', 'R\$ ${totalReceitas.toStringAsFixed(2)}'),
              Container(
                height: 40,
                width: 1,
                color: Colors.black26,
              ),
              _buildBalanceDetail(
                  'Despesas', 'R\$ ${totalDespesas.toStringAsFixed(2)}'),
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

    transactionItems.addAll(despesas.map((despesa) {
      return Column(
        children: [
          _buildTransactionItem(
            'Despesa: ${despesa['categoria']}',
            'R\$ ${despesa['valor']}',
            Colors.red,
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
