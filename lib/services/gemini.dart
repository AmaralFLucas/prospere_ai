import 'package:google_generative_ai/google_generative_ai.dart';

const apiKey = 'AIzaSyBW_T2tYv3iuhAWylGervuMqjfMPQ1NiQ4';

generateResponse(audio) async {
  final model = GenerativeModel(
    model: 'gemini-1.5-flash-latest',
    apiKey: apiKey,
  );

  final prompt =
      'Com base nas informações a seguir gere um json organizando os elementos destacados: ${audio}';
  final content = [Content.text(prompt)];
  final response = await model.generateContent(content);

  print(response.text);
}
