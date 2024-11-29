import 'package:flutter/material.dart';
import 'package:prospere_ai/services/bancoDeDados.dart';
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

  DateTime? _dataNascimento;
  bool _isLoading = true;
  bool _isEditing = false; // Variável para controlar a edição

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

  void _salvarCadastro() async {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dados do MeuCadastro atualizados com sucesso!')),
      );

      await updateCadastro(
        widget.userId,
        _nomeController.text, // Nome
        _emailController.text, // Email
        _telefoneController.text, // Telefone
        _dataNascimento!, // Data de Nascimento
        _objetivoFinanceiroController.text, // Objetivo Financeiro
        _cpfController.text, // CPF
      );

      setState(() {
        _loadCadastro();
        _isEditing = false; // Volta para o modo de visualização após salvar
      });
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
                                _buildTextField(
                                  _nomeController,
                                  _nomeController.text.isEmpty
                                      ? 'Digite seu Nome'
                                      : '',
                                  enabled: _isEditing,
                                ),
                                _buildTextLabel('Email'),
                                _buildTextField(
                                  _emailController,
                                  _emailController.text.isEmpty
                                      ? 'Digite seu Email'
                                      : '',
                                  enabled: _isEditing,
                                ),
                                _buildTextLabel('Data de Nascimento'),
                                _buildDateField(context, enabled: _isEditing),
                                _buildTextLabel('Telefone'),
                                _buildTextField(
                                  _telefoneController,
                                  _telefoneController.text.isEmpty
                                      ? 'Digite o seu Número do Telefone'
                                      : '',
                                  enabled: _isEditing,
                                  keyboardType: TextInputType.phone,
                                ),
                                _buildTextLabel('CPF'),
                                _buildTextField(
                                  _cpfController,
                                  _cpfController.text.isEmpty
                                      ? 'Digite seu CPF'
                                      : '',
                                  enabled: _isEditing,
                                ),
                                _buildTextLabel('Objetivo Financeiro'),
                                _buildTextField(
                                  _objetivoFinanceiroController,
                                  _objetivoFinanceiroController.text.isEmpty
                                      ? 'Digite qual o seu Objetivo Financeiro'
                                      : '',
                                  enabled: _isEditing,
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _buildActionButton(
                                      label: _isEditing ? 'Cancelar' : 'Editar',
                                      color: Colors.white,
                                      textColor: Colors.black,
                                      onPressed: () {
                                        setState(() {
                                          if (_isEditing) {
                                            _isEditing = false;
                                          } else {
                                            _isEditing = true;
                                          }
                                        });
                                      },
                                    ),
                                    const SizedBox(width: 15),
                                    _buildActionButton(
                                      label: 'Salvar',
                                      color: myColor,
                                      onPressed: _isEditing ? _salvarCadastro : null, // Habilita o salvar somente quando em modo de edição
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
  bool enabled = false,
}) {
  // Se o campo for para email, sempre desabilita
  bool isEmailField = controller == _emailController;

  return SizedBox(
    child: TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      enabled: !isEmailField && enabled, // Desabilita o email permanentemente
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

  Widget _buildDateField(BuildContext context, {bool enabled = false}) {
    return SizedBox(
      child: TextFormField(
        textAlign: TextAlign.center,
        controller: _dataNascimentoController,
        readOnly: !enabled, // Só permite a edição quando estiver em modo de edição
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: _dataNascimentoController.text.isEmpty
              ? 'Escolha a sua Data de Nascimento'
              : null, // Exibe o hintText somente se o campo estiver vazio
        ),
        onTap: enabled ? () => _selecionarDataNascimento(context) : null,
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
    required VoidCallback? onPressed,
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
        child: Text(
          label,
          style: TextStyle(fontSize: 18, color: textColor),
        ),
      ),
    );
  }

  Future<void> _selecionarDataNascimento(BuildContext context) async {
    final DateTime? dataSelecionada = await showDatePicker(
      context: context,
      initialDate: _dataNascimento ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (dataSelecionada != null && dataSelecionada != _dataNascimento) {
      setState(() {
        _dataNascimento = dataSelecionada;
        _dataNascimentoController.text =
            '${_dataNascimento!.day}/${_dataNascimento!.month}/${_dataNascimento!.year}';
      });
    }
  }
}

