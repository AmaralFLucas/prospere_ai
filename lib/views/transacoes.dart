import 'package:flutter/material.dart';
import 'package:prospere_ai/views/adicionarReceita.dart';

class Transacoes extends StatefulWidget {
  const Transacoes({super.key});

  @override
  State<Transacoes> createState() => _TransacoesState();
}

Color myColor = Color.fromARGB(255, 30, 163, 132);

class _TransacoesState extends State<Transacoes> {
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
                  borderRadius: BorderRadius.circular(12)),
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
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text('Receitas')
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
                            'RS 1525,00',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text('Despesas')
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 221, 221, 221),
                  borderRadius: BorderRadius.circular(12)),
              height: 500,
              width: double.infinity,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: myColor,
                          borderRadius: BorderRadius.circular(12)),
                      height: 70,
                      width: 650,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: myColor,
                          borderRadius: BorderRadius.circular(12)),
                      height: 70,
                      width: 650,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: myColor,
                          borderRadius: BorderRadius.circular(12)),
                      height: 70,
                      width: 650,
                    ),
                  ]),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const Adicionarreceita()));
          },
          
          child: Text(
            '+',
            style: TextStyle(
                fontSize: 40, fontWeight: FontWeight.normal, color: Colors.white),
          ),
          backgroundColor: myColor,),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
