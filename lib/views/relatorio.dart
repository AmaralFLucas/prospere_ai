import 'package:flutter/material.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';

class Relatorio extends StatefulWidget {
  Relatorio({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  State<Relatorio> createState() => _RelatorioState();
}

Color myColor = Color.fromARGB(255, 30, 163, 132);
Color cardColor = Color(0xFFF4F4F4);
Color textColor = Colors.black87;

class _RelatorioState extends State<Relatorio> with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;
  List<Map<String, String>> filtro = [];

  String? selectedPeriodo;
  String? selectedTipo;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );

    final curvedAnimation = CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
  }

  void _showFilterDialog(BuildContext context) {
    String? tempSelectedPeriodo = selectedPeriodo;
    String? tempSelectedTipo = selectedTipo;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Filtrar Relatório', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Selecione o período do relatório', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
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
                    SizedBox(height: 20),
                    Text('Selecione o tipo de relatório', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
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
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  selectedPeriodo = tempSelectedPeriodo;
                  selectedTipo = tempSelectedTipo;
                });
                Navigator.of(context).pop();
              },
              child: Text('Salvar'),
              style: ElevatedButton.styleFrom(backgroundColor: myColor),
            ),
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
          padding: EdgeInsets.symmetric(vertical: 10),
          margin: EdgeInsets.symmetric(horizontal: 4),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Relatório'),
        backgroundColor: myColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_alt_outlined),
            onPressed: () {
              _showFilterDialog(context);
            },
          ),
        ],
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
      floatingActionButton:Container(
        margin: EdgeInsets.all(10),
        child: FloatingActionBubble(
        items: <Bubble>[
          Bubble(
            title: "PDF",
            iconColor: Colors.white,
            bubbleColor:Color.fromARGB(255, 178, 0, 0),
            icon: Icons.article_outlined,
            titleStyle: TextStyle(fontSize: 16, color: Colors.white),
            onPress: () {
              _animationController.reverse();
            },
          ),
          Bubble(
            title: "EXCEL",
            iconColor: Colors.white,
            bubbleColor: myColor,
            icon: Icons.article_outlined,
            titleStyle: TextStyle(fontSize: 16, color: Colors.white),
            onPress: () {
              _animationController.reverse();
            },
          ),
        ],
        animation: _animation,
        onPress: () => _animationController.isCompleted
            ? _animationController.reverse()
            : _animationController.forward(),
        iconColor: Colors.white,
        iconData: Icons.download,
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
      width: 500,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'Relatório',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Mês',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: myColor,
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
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
          _buildTransactionItem('Transação 1', 'R\$ 150,00'),
          SizedBox(height: 10),
          _buildTransactionItem('Transação 2', 'R\$ 200,00'),
          SizedBox(height: 10),
          _buildTransactionItem('Transação 3', 'R\$ 250,00'),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(String title, String value) {
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
              color: Colors.white,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
