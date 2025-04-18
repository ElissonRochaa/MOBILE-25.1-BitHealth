import 'package:bithealth_front_end/components/bottom_nav_bar.dart';
import 'package:flutter/material.dart';

class MedicamentosPage extends StatelessWidget {
  const MedicamentosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Medicamentos"),
        centerTitle: false,
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue.shade800,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                hintText: 'Nome do medicamento...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: const [
                  FilterChip(label: Text('Todos'), onSelected: null),
                  SizedBox(width: 8),
                  FilterChip(label: Text('Antibióticos'), onSelected: null),
                  SizedBox(width: 8),
                  FilterChip(label: Text('Analgésicos'), onSelected: null),
                  SizedBox(width: 8),
                  FilterChip(label: Text('Uso Contínuo'), onSelected: null),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView(
                children: [
                  _MedicamentoCard(
                    nome: 'Amoxicilina 500mg',
                    tipo: 'Antibiótico',
                    disponivel: {
                      'Hospital Municipal': 320,
                      'Farmácia Municipal': 150,
                    },
                  ),
                  _MedicamentoCard(
                    nome: 'Dipirona 500mg',
                    tipo: 'Analgésico',
                    disponivel: {
                      'Hospital Municipal': 500,
                      'UBS Centro': 200,
                      'Farmácia Municipal': 350,
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(selectedIndex: 3),
    );
  }
}

class _MedicamentoCard extends StatelessWidget {
  final String nome;
  final String tipo;
  final Map<String, int> disponivel;

  const _MedicamentoCard({
    required this.nome,
    required this.tipo,
    required this.disponivel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              nome,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              tipo,
              style: TextStyle(color: Colors.blue.shade800),
            ),
            const SizedBox(height: 8),
            const Text("Disponível em:"),
            ...disponivel.entries.map(
              (entry) => Row(
                children: [
                  Icon(Icons.location_on, color: Colors.blue),
                  const SizedBox(width: 4),
                  Text(
                    "${entry.key}: ${entry.value} un.",
                    style: TextStyle(color: Colors.blue.shade800),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
