// ignore_for_file: library_private_types_in_public_api

import 'package:bithealth_front_end/pages/home_page.dart';
import 'package:bithealth_front_end/pages/medicamento_page.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  final int selectedIndex;

  const BottomNavBar({super.key, required this.selectedIndex});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  void _onItemTapped(int index) {
    if (index == widget.selectedIndex) return; // evita recriar mesma página

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MedicamentosPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.selectedIndex,
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
      onTap: _onItemTapped,
    );
  }
}
