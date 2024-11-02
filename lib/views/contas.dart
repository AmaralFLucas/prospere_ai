import 'package:flutter/material.dart';
import 'package:prospere_ai/components/customAppBar.dart';

Color myColor = const Color.fromARGB(255, 30, 163, 132);

class Contas extends StatefulWidget {
  const Contas({super.key});

  @override
  _ContasState createState() => _ContasState();
}

class _ContasState extends State<Contas> {
  List<Map<String, String>> contas = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Contas',
        onBackButtonPressed: () {
          // Ação ao pressionar o botão "back"
        },
      ),
      body: ListView.builder(
        itemCount: contas.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(contas[index]['banco']!),
            subtitle: Text('Saldo: ${contas[index]['saldo']}'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddAccountDialog(context);
        },
        backgroundColor: myColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddAccountDialog(BuildContext context) {
    String? selectedBank;
    String? balance;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Adicionar Conta'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                decoration:
                    const InputDecoration(labelText: 'Selecionar Banco'),
                items: [
                  '033 - Banco Santander (Brasil) S.A.',
                  '341 - Banco Itaú Unibanco S.A.',
                  '237 - Banco Bradesco S.A.',
                  '260 - (Nubank) Nu Pagamentos S.A.',
                  '077 - Banco Inter S.A.',
                  '104 - Caixa Econômica Federal',
                  '001 - Banco do Brasil S.A. (BB)',
                  '290 - Pagseguro Internet S.A. (Pagbank)',
                  '380 - Picpay Servicos S.A.',
                  '323 - Mercado Pago',
                  '212 - Banco Original S.A.',
                  '748 - Sicredi S.A.',
                  '102 - XP Investimentos S.A.',
                  '335 - Banco Digio S.A.',
                  '637 - Banco Sofisa S.A.',
                  '756 - Bancoob (Banco Cooperativo do Brasil)',
                ].map((String bank) {
                  return DropdownMenuItem<String>(
                    value: bank,
                    child: Text(bank),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  selectedBank = newValue;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Saldo'),
                keyboardType: TextInputType.number,
                onChanged: (String value) {
                  balance = value;
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Adicionar'),
              onPressed: () {
                if (selectedBank != null && balance != null) {
                  setState(() {
                    contas.add({
                      'banco': selectedBank!,
                      'saldo': balance!,
                    });
                  });
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
