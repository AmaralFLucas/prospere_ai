import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color backgroundColor;
  final VoidCallback? onBackButtonPressed;
  final bool showBackButton;
  final bool showPersonIcon;

  CustomAppBar({
    Key? key,
    required this.title,
    this.backgroundColor = const Color.fromARGB(255, 30, 163, 132),
    this.onBackButtonPressed,
    this.showBackButton = true,
    this.showPersonIcon = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onBackButtonPressed ?? () => Navigator.of(context).pop(),
            )
          : (showPersonIcon
              ? IconButton(
                  icon: const Icon(Icons.person),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                )
              : null),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          Row(
            children: [
              const Text(
                "Prospere",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Transform.translate(
                offset: const Offset(0, -4),
                child: const Text(
                  "IA",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Image.asset(
                'assets/images/iaporco.png', // Corrigido o caminho da imagem
                height: 24,
                width: 24,
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
