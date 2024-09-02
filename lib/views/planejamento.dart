import 'package:flutter/material.dart';

class Planejamento extends StatefulWidget {
  const Planejamento({super.key});

  @override
  State<Planejamento> createState() => _PlanejamentoState();
}

Color myColor = Color.fromARGB(255, 30, 163, 132);

class _PlanejamentoState extends State<Planejamento> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: myColor,
          automaticallyImplyLeading: false,
          title: Text('Planejamento'),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 12),
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
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
              Container(
                margin: EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 221, 221, 221),
                    borderRadius: BorderRadius.circular(12)),
                height: 300,
                width: double.infinity,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Grafico',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      )
                    ]),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    'Adicionar Planejamento',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: myColor,
                    minimumSize: Size(700, 70),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
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
        ));
  }
}
