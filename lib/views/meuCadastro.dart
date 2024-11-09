import 'package:flutter/material.dart';
import 'package:prospere_ai/views/homePage.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

class MeuCadastro extends StatefulWidget {
  const MeuCadastro({super.key});

  @override
  State<MeuCadastro> createState() => _MeuCadastroState();
}

Color myColor = const Color.fromARGB(255, 30, 163, 132);

class _MeuCadastroState extends State<MeuCadastro> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = MaskedTextController(mask: '(00) 0000-0000');
  final _cpfController = MaskedTextController(mask: '000.000.000-00');
  final _cepController = MaskedTextController(mask: '00000-000');
  final _cidadeController = TextEditingController();
  final _estadoController = TextEditingController();
  final _objetivoFinanceiroController = TextEditingController();
  final TextEditingController _dataNascimentoController =
      TextEditingController(); // Controlador para a data de nascimento

  DateTime? _dataNascimento;
  String? _sexo;

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _cpfController.dispose();
    _cepController.dispose();
    _cidadeController.dispose();
    _estadoController.dispose();
    _objetivoFinanceiroController.dispose();
    _dataNascimentoController
        .dispose(); // Descartar o controlador da data de nascimento
    super.dispose();
  }

  Future<void> _selecionarDataNascimento(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dataNascimento = picked;
        _dataNascimentoController.text =
            '${picked.day}/${picked.month}/${picked.year}'; // Atualiza o controlador com a data escolhida
      });
    }
  }

  void _salvarCadastro() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cadastro salvo com sucesso!')),
      );
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: myColor,
        title: const Text(
          'Meu Cadastro',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        automaticallyImplyLeading: true, // Remove o botão de voltar
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildTextLabel('Nome Completo'),
                    _buildTextField(
                        _nomeController, 'Digite o seu Nome Completo'),
                    _buildTextLabel('Email'),
                    _buildTextField(_emailController, 'Digite o seu E-mail',
                        keyboardType: TextInputType.emailAddress),
                    _buildTextLabel('Data de Nascimento'),
                    _buildDateField(context), // Campo de data
                    _buildTextLabel('Telefone'),
                    _buildTextField(
                        _telefoneController, 'Digite o seu Número do Telefone',
                        keyboardType: TextInputType.phone),
                    _buildTextLabel('Sexo'),
                    _buildSexoDropdown(),
                    _buildTextLabel('Nacionalidade'),
                    _buildTextField(
                        _cidadeController, 'Digite a sua Nacionalidade'),
                    _buildTextLabel('CPF'),
                    _buildTextField(_cpfController, 'Digite o seu CPF'),
                    _buildTextLabel('CEP'),
                    _buildTextField(_cepController, 'Digite o seu CEP'),
                    _buildTextLabel('Cidade'),
                    _buildTextField(_cidadeController, 'Digite a sua Cidade'),
                    _buildTextLabel('Estado'),
                    _buildTextField(_estadoController, 'Digite o seu Estado'),
                    _buildTextLabel('Objetivo Financeiro'),
                    _buildTextField(_objetivoFinanceiroController,
                        'Digite qual o seu Objetivo Financeiro'),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildActionButton(
                          label: 'Cancelar',
                          color: Colors.white,
                          textColor: Colors.black,
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => const HomePage()),
                            );
                          },
                        ),
                        const SizedBox(width: 15),
                        _buildActionButton(
                          label: 'Salvar',
                          color: myColor,
                          onPressed: _salvarCadastro,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextLabel(String label) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(top: 20),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hintText, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return SizedBox(
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: hintText,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor, insira $hintText';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDateField(BuildContext context) {
    return SizedBox(
      child: TextFormField(
        textAlign: TextAlign.center,
        controller:
            _dataNascimentoController, // Controlador para a data de nascimento
        readOnly: true, // Torna o campo somente leitura
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: 'Escolha a sua Data de Nascimento',
        ),
        onTap: () => _selecionarDataNascimento(context),
        validator: (value) {
          if (_dataNascimento == null) {
            return 'Por favor, selecione a data de nascimento';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildSexoDropdown() {
    return SizedBox(
      child: DropdownButtonFormField<String>(
        value: _sexo,
        items: const [
          DropdownMenuItem(value: 'Masculino', child: Text('Masculino')),
          DropdownMenuItem(value: 'Feminino', child: Text('Feminino')),
          DropdownMenuItem(
              value: 'Prefiro não especificar',
              child: Text('Prefiro não especificar')),
        ],
        onChanged: (value) {
          setState(() {
            _sexo = value;
          });
        },
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Escolha o Sexo',
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor, selecione uma opção';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required Color color,
    Color textColor = Colors.white,
    required VoidCallback onPressed,
  }) {
    return Container(
      height: 50,
      width: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(55),
        boxShadow: [
          BoxShadow(
            color: myColor,
            spreadRadius: 3,
            blurRadius: 0,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(55),
          ),
        ),
        child: Text(label, style: TextStyle(color: textColor)),
      ),
    );
  }
}
