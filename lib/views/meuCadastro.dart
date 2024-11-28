import 'package:flutter/material.dart';
import 'package:prospere_ai/services/bancoDeDados.dart';
import 'package:prospere_ai/views/homePage.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

class MeuCadastro extends StatefulWidget {
  const MeuCadastro(
      {super.key,
      this.nome,
      this.email,
      this.cpf,
      this.telefone,
      this.nascimento,
      this.objetivo,
      required this.userId});

  final String? nome;
  final String? email;
  final String? cpf;
  final String? telefone;
  final DateTime? nascimento;
  final String? objetivo;
  final String userId;

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
  final _objetivoFinanceiroController = TextEditingController();
  final TextEditingController _dataNascimentoController =
      TextEditingController();
  bool _isEditableNumero = true;
  bool _isEditableDataNascimento = true;
  bool _isEditableObjetivo = true;

  DateTime? _dataNascimento;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCadastro();
  }

  Future<void> _loadCadastro() async {
    final userId = widget.userId;

    try {
      final List<Map<String, dynamic>> data = await getCadastro(userId);

      setState(() {
        if (data.isNotEmpty) {
          final cadastro = data.first;

          _nomeController.text = cadastro['nome'] ?? '';
          _emailController.text = cadastro['email'] ?? '';
          _telefoneController.text = cadastro['telefone'] ?? '';
          _cpfController.text = cadastro['cpf'] ?? '';
          _objetivoFinanceiroController.text = cadastro['objetivo'] ?? '';

          if (cadastro['nascimento'] != null) {
            _dataNascimento = DateTime.parse(cadastro['nascimento']);
            _dataNascimentoController.text =
                '${_dataNascimento!.day}/${_dataNascimento!.month}/${_dataNascimento!.year}';
          }
        } else {
          print("Nenhum cadastro encontrado.");
        }

        _isLoading = false;
      });
    } catch (e) {
      print("Erro ao carregar dados: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _cpfController.dispose();
    _objetivoFinanceiroController.dispose();
    _dataNascimentoController.dispose();
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
            '${picked.day}/${picked.month}/${picked.year}';
      });
    }
  }

  void _salvarCadastro() async {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Dados do MeuCadastro atualizados com sucesso!')),
      );

      await updateCadastro(
        widget.userId,
        _telefoneController.text,
        _dataNascimento!,
        _objetivoFinanceiroController.text,
      );

      setState(() {
        _loadCadastro();
      });

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
        automaticallyImplyLeading: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: _nomeController.text.isEmpty
                  ? const Center(child: Text('Nenhum dado encontrado.'))
                  : Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                _buildTextLabel('Nome'),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: TextFormField(
                                    initialValue: _nomeController.text,
                                    enabled: false,
                                    decoration: InputDecoration(
                                      hintText: 'Digite seu Nome',
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 14.0, horizontal: 10.0),
                                    ),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                                _buildTextLabel('Email'),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: TextFormField(
                                    initialValue: _emailController.text,
                                    enabled: false,
                                    decoration: InputDecoration(
                                      hintText: 'Digite seu Email',
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 14.0, horizontal: 10.0),
                                    ),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                                _buildTextLabel('Data de Nascimento'),
                                _buildDateField(context),
                                _buildTextLabel('Telefone'),
                                _buildTextField(
                                  _telefoneController,
                                  _telefoneController.text.isEmpty
                                      ? 'Digite o seu Número do Telefone'
                                      : '',
                                  keyboardType: TextInputType.phone,
                                ),
                                _buildTextLabel('CPF'),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: TextFormField(
                                    initialValue: _cpfController.text,
                                    enabled: false,
                                    decoration: InputDecoration(
                                      hintText: 'Digite seu CPF',
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 14.0, horizontal: 10.0),
                                    ),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                                _buildTextLabel('Objetivo Financeiro'),
                                _buildTextField(
                                  _objetivoFinanceiroController,
                                  _objetivoFinanceiroController.text.isEmpty
                                      ? 'Digite qual o seu Objetivo Financeiro'
                                      : '',
                                ),
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
                                              builder: (context) =>
                                                  const HomePage()),
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
          labelText: controller.text.isEmpty
              ? hintText
              : null, // Mostra o texto se estiver vazio
        ),
        onChanged: (value) {
          setState(() {}); // Atualiza o estado para refletir a mudança no campo
        },
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
        controller: _dataNascimentoController,
        readOnly: true,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: _dataNascimentoController.text.isEmpty
              ? 'Escolha a sua Data de Nascimento'
              : null, // Exibe o hintText somente se o campo estiver vazio
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
