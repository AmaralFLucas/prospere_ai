import 'package:avatar_glow/avatar_glow.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prospere_ai/components/customBottomAppBar.dart';
import 'package:prospere_ai/services/gemini.dart';
import 'package:prospere_ai/views/inicio.dart';
import 'package:prospere_ai/views/mais.dart';
import 'package:prospere_ai/views/planejamento.dart';
import 'package:prospere_ai/views/transacoes.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

PageController pageController = PageController();
int initialPosition = 0;
bool mostrarSenha = true;
Color myColor = const Color.fromARGB(255, 30, 163, 132);
Color cardColor = const Color(0xFFF4F4F4);
Color textColor = Colors.black87;
Icon eyeIcon = const Icon(Icons.visibility_off);
var text = "";
var isListening = false;
SpeechToText speechToText = SpeechToText();

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void _onTabSelected(int index) {
    setState(() {
      initialPosition = index;
      pageController.jumpToPage(index);
    });
  }

  void _onFabPressed() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: (index) {
          setState(() {
            initialPosition = index;
          });
        },
        children: [
          Inicio(
            userId: uid,
          ),
          Transacoes(userId: uid),
          Planejamento(userId: uid,),
          const Mais(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showVoice(context);
        },
        backgroundColor: myColor,
        child: Icon(Icons.mic),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomBottomAppBar(
        myColor: myColor,
        selectedIndex: initialPosition,
        onTabSelected: _onTabSelected,
        onFabPressed: _onFabPressed,
      ),
    );
  }

  void _showVoice(BuildContext context) async {
    bool available = await speechToText.initialize(
      onStatus: (status) {
        if (status == 'done') {
          setState(() {
            isListening = false;
          });
          speechToText.stop();
          Navigator.of(context).pop();
        }
      },
      onError: (error) {
        print('Erro no reconhecimento: $error');
      },
    );

    if (available) {
      setState(() {
        isListening = true;
      });

      speechToText.listen(
        onResult: (result) async {
          setState(() {
            text = result.recognizedWords;
          });
          if (result.finalResult) {
            await generateResponse(context, text);
          }
        },
        pauseFor: const Duration(seconds: 3),
        localeId: 'pt_BR',
        partialResults: true,
      );
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            width: 300,
            height: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: AvatarGlow(
                    animate: isListening,
                    glowColor: myColor,
                    child: CircleAvatar(
                      backgroundColor: myColor,
                      radius: 35,
                      child:
                          const Icon(Icons.mic, size: 50, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
