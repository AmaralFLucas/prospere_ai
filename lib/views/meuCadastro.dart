import 'package:flutter/material.dart';
import 'package:prospere_ai/views/homePage.dart';

class MeuCadastro extends StatefulWidget {
  const MeuCadastro({super.key});

  @override
  State<MeuCadastro> createState() => _MeuCadastroState();
}

Color myColor = Color.fromARGB(255, 30, 163, 132);

class _MeuCadastroState extends State<MeuCadastro> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
      children: [
        Scaffold(
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(25),
                  width: double.infinity,
                  decoration: BoxDecoration(color: myColor, boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(67, 0, 0, 0),
                      spreadRadius: 6,
                      blurRadius: 3,
                      offset: Offset(0, 1), // changes position of shadow
                    ),
                  ]),
                  height: 100,
                  child: Column(
                    children: [
                      Row(children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back),
                          color: Color.fromARGB(255, 255, 255, 255),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const HomePage()));
                          },
                        ),
                        Text(
                          'Meu Cadastro',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ]),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 0),
                  padding: EdgeInsets.only(top: 20),
                  width: double.infinity,
                  height: 1300,
                  child: Column(children: [
                    Container(
                      padding: EdgeInsets.only(right: 175),
                      child: Text(
                        'Nome Completo',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: 300,
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Digite o seu Nome Completo',
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 250, top: 20),
                      child: Text(
                        'Email',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: 300,
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Digite o seu E-mail',
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 150, top: 20),
                      child: Text(
                        'Data de Nascimento',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: 300,
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Digite a sua Data de Nascimento',
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 230, top: 20),
                      child: Text(
                        'Telefone',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: 300,
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Digite o seu Número do seu Telefone',
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 250, top: 20),
                      child: Text(
                        'Sexo',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: 300,
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Digite o seu Sexo',
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 190, top: 20),
                      child: Text(
                        'Nacionalidade',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: 300,
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Digite a sua Nacionalidade',
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 255, top: 20),
                      child: Text(
                        'CPF',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: 300,
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Digite o seu CPF',
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 255, top: 20),
                      child: Text(
                        'CEP',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: 300,
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Digite o seu CEP',
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 240, top: 20),
                      child: Text(
                        'Cidade',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: 300,
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Digite a sua Cidade',
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 240, top: 20),
                      child: Text(
                        'Estado',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: 300,
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Digite o seu Estado',
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 160, top: 20),
                      child: Text(
                        'Objetivo Financeiro',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: 300,
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Digite qual o seu Objetivo Financeiro',
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Padding(padding: EdgeInsets.symmetric(horizontal: 150)),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(55),
                              boxShadow: [
                                BoxShadow(
                                  color: myColor,
                                  spreadRadius: 3,
                                  blurRadius: 0,
                                  offset: Offset(
                                      0, 0), // changes position of shadow
                                ),
                              ]),
                          height: 50,
                          width: 150,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const HomePage()));
                            },
                            child: Text('Cancelar',
                                style: TextStyle(color: Colors.black)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              minimumSize: Size(150, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(55),
                              ),
                            ),
                          ),
                        ),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 15)),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(55),
                              boxShadow: [
                                BoxShadow(
                                  color: myColor,
                                  spreadRadius: 3,
                                  blurRadius: 0,
                                  offset: Offset(
                                      0, 0), // changes position of shadow
                                ),
                              ]),
                          height: 50,
                          width: 150,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const HomePage()));
                            },
                            child: Text('Salvar'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: myColor,
                              minimumSize: Size(150, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(55),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ]),
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
