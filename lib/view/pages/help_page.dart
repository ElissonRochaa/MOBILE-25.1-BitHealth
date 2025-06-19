import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ajuda - Funcionalidades do App'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHelpItem(Icons.access_time, 'Plantões', 'Visualize seus plantões médicos e horários de trabalho.'),
                const SizedBox(height: 8),
                _buildHelpItem(Icons.vaccines, 'Vacinação', 'Acompanhe seu calendário de vacinação e histórico de vacinas.'),
                const SizedBox(height: 8),
                _buildHelpItem(Icons.article, 'Notícias', 'Fique por dentro das últimas notícias da área da saúde.'),
                const SizedBox(height: 8),
                _buildHelpItem(Icons.help_outline, 'Ajuda', 'Veja informações sobre como usar o aplicativo.'),
                const Divider(height: 16),
                _buildHelpItem(Icons.home, 'Home', 'Tela inicial com resumo geral das funções do app.'),
                const SizedBox(height: 8),
                _buildHelpItem(Icons.map, 'Mapa', 'Veja unidades de saúde próximas a você no mapa.'),
                const SizedBox(height: 8),
                _buildHelpItem(Icons.medical_services, 'Médicos', 'Visualize e consulte a lista de médicos disponíveis.'),
                const SizedBox(height: 8),
                _buildHelpItem(Icons.medication, 'Medicamentos', 'Veja seus medicamentos e histórico de prescrição.'),
                const SizedBox(height: 8),
                _buildHelpItem(Icons.build, 'Serviços', 'Confira os serviços de saúde oferecidos.'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHelpItem(IconData icon, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 24, color: Colors.blueAccent),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(description, style: const TextStyle(fontSize: 13)),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajuda')),
      body: Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.help_outline),
          label: const Text('Ver Ajuda'),
          onPressed: () => _showHelpDialog(context),
        ),
      ),
    );
  }
}
