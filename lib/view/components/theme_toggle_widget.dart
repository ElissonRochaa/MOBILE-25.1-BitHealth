import 'package:bithealth_front_end/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ThemeToggleWidget extends StatelessWidget {
  final bool showText;
  final double iconSize;
  final EdgeInsets padding;

  const ThemeToggleWidget({
    super.key,
    this.showText = true,
    this.iconSize = 24,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(showText ? 25 : 50),
            color: Theme.of(context).colorScheme.surface,
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(showText ? 25 : 50),
            onTap: () {
              themeProvider.toggleTheme();
              
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    themeProvider.isDarkMode 
                        ? 'Tema escuro ativado' 
                        : 'Tema claro ativado',
                  ),
                  duration: const Duration(milliseconds: 800),
                  behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsets.all(16),
                ),
              );
            },
            child: Padding(
              padding: padding,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(
                        scale: animation,
                        child: RotationTransition(
                          turns: animation,
                          child: child,
                        ),
                      );
                    },
                    child: Icon(
                      themeProvider.isDarkMode 
                          ? Icons.wb_sunny_outlined 
                          : Icons.nightlight_round,
                      key: ValueKey(themeProvider.isDarkMode),
                      color: themeProvider.isDarkMode 
                          ? Colors.amber 
                          : Colors.indigo,
                      size: iconSize,
                    ),
                  ),
                  if (showText) ...[
                    const SizedBox(width: 8),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 300),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      child: Text(
                        themeProvider.isDarkMode 
                            ? 'Modo Claro' 
                            : 'Modo Escuro',
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class CompactThemeToggle extends StatelessWidget {
  const CompactThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemeToggleWidget(
      showText: false,
      iconSize: 22,
      padding: const EdgeInsets.all(8),
    );
  }
}