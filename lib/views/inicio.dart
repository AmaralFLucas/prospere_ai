import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:prospere_ai/services/autenticacao.dart';
import 'package:prospere_ai/services/bancoDeDados.dart';
import 'package:prospere_ai/views/configuracoes.dart';
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

  List<Map<String, dynamic>> receitas = [];
  List<Map<String, dynamic>> despesas = [];

  double totalReceitas = 0.0;
  double totalDespesas = 0.0;
  double saldoAtual = 0.0;

  int initialPosition = 0;
  final Color myColor = const Color.fromARGB(255, 30, 163, 132);
  final Color cardColor = const Color(0xFFF4F4F4);
  final Color textColor = Colors.black87;

  String? profileImageUrl;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    _loadData();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    List<Map<String, dynamic>> fetchedReceitas =
        await getReceitas(widget.userId);
    List<Map<String, dynamic>> fetchedDespesas =
        await getDespesas(widget.userId);

    double receitasSum =
        fetchedReceitas.fold(0.0, (sum, item) => sum + (item['valor'] ?? 0.0));
    double despesasSum =
        fetchedDespesas.fold(0.0, (sum, item) => sum + (item['valor'] ?? 0.0));

    setState(() {
      receitas = fetchedReceitas;
      despesas = fetchedDespesas;
      totalReceitas = receitasSum;
      totalDespesas = despesasSum;
      saldoAtual = totalReceitas - totalDespesas;
    });
  }

  Future<void> _chooseImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      String url = await _uploadImageToFirebase(image.path);
      setState(() {
        profileImageUrl = url;
      });
    }
  }

  Future<String> _uploadImageToFirebase(String filePath) async {
    File file = File(filePath);
    String fileName = 'profile_${widget.userId}.jpg';
    Reference storageRef =
        FirebaseStorage.instance.ref().child('profile_images/$fileName');
    await storageRef.putFile(file);
    String downloadUrl = await storageRef.getDownloadURL();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .update({'profileImageUrl': downloadUrl});
    return downloadUrl;
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
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: _chooseImage,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: profileImageUrl != null
                                ? NetworkImage(profileImageUrl!)
                                : const AssetImage(
                                    'assets/default_profile.png'),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Nome do Usuário', // Substitua pelo nome do usuário
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const MeuCadastro(),
                        ),
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
                        color: Colors.black,
                      ),
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
                            color: Colors.black,
                          ),
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
              leading: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: const Icon(Icons.person),
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
                  const SizedBox(height: 20),
                  _buildBalanceCard(),
                  const SizedBox(height: 20),
                  _buildTransactionList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard() {
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
              color: myColor,
            ),
          ),
          const SizedBox(height: 20),
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
        const SizedBox(height: 10),
        Text(
          title,
          style: TextStyle(fontSize: 16, color: textColor.withOpacity(0.7)),
        ),
      ],
    );
  }

  Widget _buildTransactionList() {
    return Container(
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ..._buildTransactionItems(),
        ],
      ),
    );
  }

  List<Widget> _buildTransactionItems() {
    despesas.sort(
        (a, b) => (b['data'] as Timestamp).compareTo(a['data'] as Timestamp));

    List<Widget> transactionItems = [];

    transactionItems.addAll(despesas.map((despesa) {
      return Column(
        children: [
          _buildTransactionItem(
            '${despesa['categoria']}',
            'R\$ ${despesa['valor']}',
          ),
          const SizedBox(height: 10),
        ],
      );
    }).toList());

    return transactionItems;
  }

  Widget _buildTransactionItem(String title, String value) {
    return Container(
      decoration: BoxDecoration(
        color: myColor,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
