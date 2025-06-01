import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final List<Widget>? actions;

  const CustomAppBar({
    super.key,
    required this.title,
    this.centerTitle = false,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: backgroundColor ?? theme.appBarTheme.backgroundColor,
      foregroundColor: foregroundColor ?? theme.appBarTheme.foregroundColor,
      elevation: elevation,
      actions: actions,
      iconTheme: IconThemeData(
        color: foregroundColor ?? theme.appBarTheme.foregroundColor,
      ),
      centerTitle: centerTitle,
      title: Row(
        children: [
          Image.asset(
            'images/logo-ico.png',
            height: 32,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              color: foregroundColor ?? theme.appBarTheme.foregroundColor,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
