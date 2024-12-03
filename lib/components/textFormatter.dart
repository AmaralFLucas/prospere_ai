import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Se o novo texto estiver vazio, retorna um valor vazio
    if (newValue.text.isEmpty) {
      return const TextEditingValue(text: '');
    }

    // Remove caracteres não numéricos
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    // Se estiver vazio, retorna
    if (digitsOnly.isEmpty) {
      return const TextEditingValue(text: '');
    }

    // Formata com casas decimais
    String wholePart = digitsOnly.substring(0, digitsOnly.length - 2);
    String decimalPart = digitsOnly.substring(digitsOnly.length - 2);
    String formattedValue = '$wholePart,$decimalPart';

    // Adiciona separadores de milhar corretamente
    formattedValue = _addThousandSeparator(formattedValue);

    // Retorna o valor formatado com o cursor ajustado
    return TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );
  }

  String _addThousandSeparator(String value) {
    // Separa a parte inteira e decimal
    List<String> parts = value.split(',');
    String wholePart = parts[0].replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match match) => '${match[1]}.',
    );

    // Junta a parte formatada com a decimal
    return 'R\$ $wholePart${parts.length > 1 ? ',' + parts[1] : ''}';
  }

  String formatCurrency(dynamic value) {
    // Tenta converter o valor para double, suportando diferentes formatos
    try {
      double parsedValue;

      if (value is String) {
        // Substitui separadores de milhar/decimal se necessário
        String normalizedValue = value.replaceAll('.', '').replaceAll(',', '.');
        parsedValue = double.parse(normalizedValue);
      } else if (value is num) {
        parsedValue = value.toDouble();
      } else {
        throw FormatException("Formato inválido: $value");
      }

      // Formata para o padrão brasileiro de moeda
      final format = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
      return format.format(parsedValue);
    } catch (e) {
      // Retorna um valor padrão ou mensagem de erro em caso de falha
      return 'Valor inválido';
    }
  }
}
