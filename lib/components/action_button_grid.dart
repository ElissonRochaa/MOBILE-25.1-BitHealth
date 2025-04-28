import 'package:flutter/material.dart';
import 'package:bithealth_front_end/pages/news_page.dart';

class ActionButtonGrid extends StatelessWidget {
  const ActionButtonGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final buttons = [
      _ButtonData("Unidades de Saúde", Icons.location_on, () {}),
      _ButtonData("Médicos", Icons.person, () {}),
      _ButtonData("Plantões", Icons.access_time, () {}),
      _ButtonData("Medicamentos", Icons.medication, () {}),
      _ButtonData("Vacinação", Icons.vaccines, () {
        Navigator.pushNamed(context, '/vacinacao');
      }),
      _ButtonData("Serviços", Icons.list, () {
        Navigator.pushNamed(context, '/servicos');
      }),
      _ButtonData("Notícias", Icons.article, () {
        Navigator.pushNamed(context, '/noticias');
      }),
      _ButtonData("Notificações", Icons.notifications, () {}),
    ];

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 3.5,
        children: buttons.map((btn) => _GridButton(data: btn)).toList(),
      ),
    );
  }
}

class _ButtonData {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  _ButtonData(this.label, this.icon, this.onPressed);
}

class _GridButton extends StatelessWidget {
  final _ButtonData data;

  const _GridButton({required this.data});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: data.onPressed,
      icon: Icon(data.icon, color: Colors.blue),
      label: Text(
        data.label,
        style: const TextStyle(color: Colors.blue),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue,
        elevation: 0,
        side: const BorderSide(color: Colors.transparent),
        alignment: Alignment.centerLeft,
      ),
    );
  }
}