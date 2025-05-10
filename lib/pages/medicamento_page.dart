import 'package:bithealth_front_end/components/bottom_nav_bar.dart';
import 'package:flutter/material.dart';

class MedicamentosPage extends StatefulWidget {
  const MedicamentosPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MedicamentosPageState createState() => _MedicamentosPageState();
}

class _MedicamentosPageState extends State<MedicamentosPage> {
  String searchQuery = '';
  String selectedFilter = 'Todos';

  List<Map<String, String>> medicamentos = [
    {'nome': 'Amoxicilina 500mg', 'tipo': 'Antibiótico'},
    {'nome': 'Dipirona 500mg', 'tipo': 'Analgésico'},
  ];

  @override
  Widget build(BuildContext context) {
    var filteredMedicamentos = medicamentos.where((med) {
      return (selectedFilter == 'Todos' || med['tipo'] == selectedFilter) &&
          (searchQuery.isEmpty || med['nome']!.toLowerCase().contains(searchQuery.toLowerCase()));
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Medicamentos"),
        centerTitle: false,
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue.shade800,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            TextField(
              onChanged: (query) {
                setState(() {
                  searchQuery = query;
                });
              },
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
                children: [
                  FilterChip(
                    label: Text('Todos'),
                    selected: selectedFilter == 'Todos',
                    onSelected: (bool value) {
                      setState(() {
                        selectedFilter = 'Todos';
                      });
                    },
                  ),
                  SizedBox(width: 8),
                  FilterChip(
                    label: Text('Antibióticos'),
                    selected: selectedFilter == 'Antibióticos',
                    onSelected: (bool value) {
                      setState(() {
                        selectedFilter = 'Antibióticos';
                      });
                    },
                  ),
                  SizedBox(width: 8),
                  FilterChip(
                    label: Text('Analgésicos'),
                    selected: selectedFilter == 'Analgésicos',
                    onSelected: (bool value) {
                      setState(() {
                        selectedFilter = 'Analgésicos';
                      });
                    },
                  ),
                  SizedBox(width: 8),
                  FilterChip(
                    label: Text('Uso Contínuo'),
                    selected: selectedFilter == 'Uso Contínuo',
                    onSelected: (bool value) {
                      setState(() {
                        selectedFilter = 'Uso Contínuo';
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView(
                children: filteredMedicamentos.map((medicamento) {
                  return _MedicamentoCard(
                    nome: medicamento['nome']!,
                    tipo: medicamento['tipo']!,
                    disponivel: {
                      'Hospital Municipal': 320,
                      'Farmácia Municipal': 150,
                    },
                  );
                }).toList(),
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
