import 'package:flutter/material.dart';

class CustomBottomAppBar extends StatelessWidget {
  final Color myColor;
  final int selectedIndex;
  final Function(int) onTabSelected;
  final Function onFabPressed;

  const CustomBottomAppBar({
    super.key,
    required this.myColor,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.onFabPressed,
  });

  // Método auxiliar para construir um item de nav bar
  Widget buildNavBarItem(IconData icon, String label, int index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon),
          color: selectedIndex == index ? myColor : Colors.black,
          onPressed: () => onTabSelected(index),
        ),
        Text(
          label,
          style: TextStyle(
            color: selectedIndex == index ? myColor : Colors.black,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: 60,
      notchMargin: 5,
      shape: CircularNotchedRectangle(),
      color: Color.fromARGB(255, 230, 234, 236),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          buildNavBarItem(Icons.home, 'Inicio', 0),
          buildNavBarItem(Icons.currency_exchange, 'Transações', 1),
          SizedBox(width: 48), // Espaço para o FAB
          buildNavBarItem(Icons.flag, 'Planejamento', 2),
          buildNavBarItem(Icons.more_horiz, 'Mais', 3),
        ],
      ),
    );
  }
}
