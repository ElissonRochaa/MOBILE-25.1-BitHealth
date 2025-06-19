import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bithealth_front_end/provider/theme_provider.dart';

class ThemeSwitch extends StatelessWidget {
  const ThemeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Switch(
          value: themeProvider.isDarkMode,
          onChanged: (value) {
            themeProvider.toggleTheme();
          },
          activeColor: Colors.blue,
        ); 
      },
    );
  }
}