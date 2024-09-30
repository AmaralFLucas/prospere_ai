import 'package:flutter/material.dart';
import 'package:prospere_ai/views/homePage.dart';

class MeuCadastro extends StatefulWidget {
  const MeuCadastro({super.key});

  @override
  State<MeuCadastro> createState() => _MeuCadastroState();
}

Color myColor = const Color.fromARGB(255, 30, 163, 132);

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
                  padding: const EdgeInsets.all(25),
                  width: double.infinity,
                  decoration: BoxDecoration(color: myColor, boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(67, 0, 0, 0),
                      spreadRadius: 6,
                      blurRadius: 3,
                      offset: Offset(0, 1),
                    ),
                  ]),
                  height: 100,
                  child: Column(
                    children: [
                      Row(children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          color: const Color.fromARGB(255, 255, 255, 255),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        const Text(
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
                  margin: const EdgeInsets.symmetric(vertical: 0),
                  padding: const EdgeInsets.only(top: 20),
                  width: double.infinity,
                  height: 1350,
                  child: Column(children: [
                    Container(
                      padding: const EdgeInsets.only(right: 175),
                      child: const Text(
                        'Nome Completo',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const SizedBox(
                      width: 300,
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Digite o seu Nome Completo',
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(right: 250, top: 20),
                      child: const Text(
                        'Email',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const SizedBox(
                      width: 300,
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Digite o seu E-mail',
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(right: 150, top: 20),
                      child: const Text(
                        'Data de Nascimento',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const SizedBox(
                      width: 300,
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Digite a sua Data de Nascimento',
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(right: 230, top: 20),
                      child: const Text(
                        'Telefone',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const SizedBox(
                      width: 300,
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Digite o seu Número do seu Telefone',
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(right: 250, top: 20),
                      child: const Text(
                        'Sexo',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const SizedBox(
                      width: 300,
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Digite o seu Sexo',
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(right: 190, top: 20),
                      child: const Text(
                        'Nacionalidade',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const SizedBox(
                      width: 300,
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Digite a sua Nacionalidade',
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(right: 255, top: 20),
                      child: const Text(
                        'CPF',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const SizedBox(
                      width: 300,
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Digite o seu CPF',
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(right: 255, top: 20),
                      child: const Text(
                        'CEP',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const SizedBox(
                      width: 300,
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Digite o seu CEP',
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(right: 240, top: 20),
                      child: const Text(
                        'Cidade',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const SizedBox(
                      width: 300,
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Digite a sua Cidade',
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(right: 240, top: 20),
                      child: const Text(
                        'Estado',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const SizedBox(
                      width: 300,
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Digite o seu Estado',
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(right: 160, top: 20),
                      child: const Text(
                        'Objetivo Financeiro',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const SizedBox(
                      width: 300,
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Digite qual o seu Objetivo Financeiro',
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(55),
                              boxShadow: [
                                BoxShadow(
                                  color: myColor,
                                  spreadRadius: 3,
                                  blurRadius: 0,
                                  offset: const Offset(
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
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              minimumSize: const Size(150, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(55),
                              ),
                            ),
                            child: Text('Cancelar',
                                style: TextStyle(color: Colors.black)),
                          ),
                        ),
                        const Padding(padding: EdgeInsets.symmetric(horizontal: 15)),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(55),
                              boxShadow: [
                                BoxShadow(
                                  color: myColor,
                                  spreadRadius: 3,
                                  blurRadius: 0,
                                  offset: const Offset(0, 0),
                                ),
                              ]),
                          height: 50,
                          width: 150,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const HomePage()));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: myColor,
                              minimumSize: const Size(150, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(55),
                              ),
                            ),
                            child: Text('Salvar'),
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
