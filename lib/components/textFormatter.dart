import 'package:flutter/services.dart';

class CurrencyTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Se o novo texto estiver vazio, retorna um valor vazio
    if (newValue.text.isEmpty) {
      return const TextEditingValue(text: '');
    }

    // Remove todos os caracteres que não são dígitos
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d.]'), '');

    // Se a string estiver vazia, retorna
    if (digitsOnly.isEmpty) {
      return const TextEditingValue(text: '');
    }

    // Adiciona as casas decimais
    String formattedValue;
    if (digitsOnly.length > 2) {
      String wholePart = digitsOnly.substring(0, digitsOnly.length - 2);
      String decimalPart =
          digitsOnly.substring(digitsOnly.length - 2).padLeft(2);
      formattedValue = '$wholePart,$decimalPart';
    } else if (digitsOnly.length == 2) {
      formattedValue = ',$digitsOnly';
    } else {
      formattedValue = ',${digitsOnly.padLeft(2)}';
    }

    // Formata para adicionar separadores de milhar
    formattedValue = formatToCurrency(formattedValue);

    // Ajusta o cursor na posição correta
    return TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );
  }

  String formatToCurrency(String value) {
    // Separa a parte inteira e a decimal
    List<String> parts = value.split(',');
    String wholePart = parts[0].replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match match) => '${match[1]}.',
    );

    // Adiciona o símbolo de moeda e formata centavos
    String formattedValue =
        'R\$ $wholePart${parts.length > 1 ? ',' + parts[1] : ''}';

    return formattedValue;
  }
}
