import 'package:flutter/material.dart';
import 'package:prospere_ai/views/adicionarDespesa.dart';
import 'package:prospere_ai/views/adicionarReceita.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';

class Transacoes extends StatefulWidget {
  Transacoes({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  State<Transacoes> createState() => _TransacoesState();
}

Color myColor = Color.fromARGB(255, 30, 163, 132);

class _TransacoesState extends State<Transacoes> with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: myColor,
        automaticallyImplyLeading: false,
        title: Text('Transações'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 221, 221, 221),
                borderRadius: BorderRadius.circular(12),
              ),
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Saldo Atual'),
                  Text(
                    'RS 433,15',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text(
                            'RS 1.958,15',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Text('Receitas'),
                        ],
                      ),
                      Container(
                        height: 50,
                        width: 2,
                        color: Colors.black,
                      ),
                      Column(
                        children: [
                          Text(
                            'RS 1.525,00',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Text('Despesas'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 221, 221, 221),
                borderRadius: BorderRadius.circular(12),
              ),
              height: 500,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: myColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    height: 70,
                    width: 650,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: myColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    height: 70,
                    width: 650,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: myColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    height: 70,
                    width: 650,
                  ),
                ],
              ),
            ),
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
                  MaterialPageRoute(builder: (BuildContext context) => Adicionarreceita()),
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
                  MaterialPageRoute(builder: (BuildContext context) => Adicionardespesa()),
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
}
