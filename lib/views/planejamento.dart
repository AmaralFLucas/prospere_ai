import 'package:flutter/material.dart';

class Planejamento extends StatefulWidget {
  const Planejamento({super.key});

  @override
  State<Planejamento> createState() => _PlanejamentoState();
}

Color myColor = const Color.fromARGB(255, 30, 163, 132);
Color cardColor = const Color(0xFFF4F4F4);
Color textColor = Colors.black87;

class _PlanejamentoState extends State<Planejamento> {
  List<Map<String, dynamic>> planList = [];
  int? selectedPlanIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: myColor,
        automaticallyImplyLeading: false,
        title: const Text(
          'Planejamento',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildBalanceCard(),
            const SizedBox(height: 20),
            _buildChartCard(),
            const SizedBox(height: 20),
            _buildAddPlanButton(),
            const SizedBox(height: 20),
            _buildPlanList(),
          ],
        ),
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
            'R\$ 433,15',
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
              _buildBalanceDetail('Receitas', 'R\$ 1.958,15'),
              Container(
                height: 40,
                width: 1,
                color: Colors.black26,
              ),
              _buildBalanceDetail('Despesas', 'R\$ 1.525,00'),
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
          style: TextStyle(
            fontSize: 16,
            color: textColor.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildChartCard() {
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
      height: 250,
      child: Center(
        child: Text(
          'Gráfico',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }

  Widget _buildAddPlanButton() {
    return ElevatedButton(
      onPressed: () {
        _showAddPlanDialog(context);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: myColor,
        minimumSize: const Size(double.infinity, 60),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: Text(
        'Adicionar Planejamento',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPlanList() {
    return Container(
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
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        shrinkWrap: true,
        itemCount: planList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedPlanIndex = index;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: selectedPlanIndex == index ? myColor : cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    planList[index]['name'],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color:
                          selectedPlanIndex == index ? Colors.white : textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'R\$: ${planList[index]['value']}',
                    style: TextStyle(
                      fontSize: 16,
                      color: selectedPlanIndex == index
                          ? Colors.white70
                          : textColor.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showAddPlanDialog(BuildContext context) {
    String planName = '';
    String planValue = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Adicionar Planejamento'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Nome do Planejamento',
                  labelStyle: TextStyle(color: textColor),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: myColor),
                  ),
                ),
                onChanged: (value) {
                  planName = value;
                },
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Valor',
                  labelStyle: TextStyle(color: textColor),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: myColor),
                  ),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  planValue = value;
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancelar',
                style: TextStyle(color: myColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Adicionar',
                style: TextStyle(color: myColor),
              ),
              onPressed: () {
                setState(() {
                  planList.add({'name': planName, 'value': planValue});
                  selectedPlanIndex = planList.length - 1;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}