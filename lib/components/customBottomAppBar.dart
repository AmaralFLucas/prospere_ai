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

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: 60,
      notchMargin: 5,
      shape: CircularNotchedRectangle(),
      color: Color.fromARGB(255, 212, 217, 221),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(Icons.home),
            color: selectedIndex == 0 ? myColor : Colors.black,
            onPressed: () => onTabSelected(0),
          ),
          IconButton(
            icon: Icon(Icons.currency_exchange),
            color: selectedIndex == 1 ? myColor : Colors.black,
            onPressed: () => onTabSelected(1),
          ),
          SizedBox(width: 48), // Spacer for the FloatingActionButton
          IconButton(
            icon: Icon(Icons.flag),
            color: selectedIndex == 2 ? myColor : Colors.black,
            onPressed: () => onTabSelected(2),
          ),
          IconButton(
            icon: Icon(Icons.more_horiz),
            color: selectedIndex == 3 ? myColor : Colors.black,
            onPressed: () => onTabSelected(3),
          ),
        ],
      ),
    );
  }
}