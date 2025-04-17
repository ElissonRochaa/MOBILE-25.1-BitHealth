import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Início"),
        BottomNavigationBarItem(icon: Icon(Icons.map), label: "Mapa"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Médicos"),
        BottomNavigationBarItem(icon: Icon(Icons.medication), label: "Medicamentos"),
        BottomNavigationBarItem(icon: Icon(Icons.notifications), label: "Notificações"),
      ],
    );
  }
}
