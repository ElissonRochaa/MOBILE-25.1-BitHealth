import 'package:flutter/material.dart';

class ActionButtonGrid extends StatelessWidget {
  const ActionButtonGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final buttons = [
      _ButtonData("Médicos", Icons.person, () {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/medicos',
          (Route<dynamic> route) => false,
        );
      }),
      _ButtonData("Plantões", Icons.access_time, () {}),
      _ButtonData("Medicamentos", Icons.medication, () {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/medicamentos',
          (Route<dynamic> route) => false,
        );
      }),
      _ButtonData("Vacinação", Icons.vaccines, () {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/vacinacao',
          (Route<dynamic> route) => false,
        );
      }),
      _ButtonData("Serviços", Icons.list, () {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/servicos',
          (Route<dynamic> route) => false,
        );
      }),
      _ButtonData("Notícias", Icons.article, () {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/noticias',
          (Route<dynamic> route) => false,
        );
      }),
      _ButtonData("Notificações", Icons.notifications, () {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/notificacoes',
          (Route<dynamic> route) => false,
        );
      }),
      _ButtonData("Mapa", Icons.map, () {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/mapa',
          (Route<dynamic> route) => false,
        );
      }),];

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