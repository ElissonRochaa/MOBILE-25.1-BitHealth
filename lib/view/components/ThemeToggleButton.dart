import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bithealth_front_end/provider/theme_provider.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return GestureDetector(
      onTap: () {
        themeProvider.toggleTheme();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.surface, // Cor de fundo do botão (ajusta bem nos dois temas)
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          isDarkMode ? Icons.wb_sunny_rounded : Icons.nightlight_round,
          color: isDarkMode ? Colors.yellow[600] : Colors.blue[600],
          size: 24,
        ),
      ),
    );
  }
}
