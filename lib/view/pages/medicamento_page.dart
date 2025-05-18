import 'package:bithealth_front_end/view/components/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:bithealth_front_end/services/medicamento_service.dart';
import 'package:bithealth_front_end/model/medicamentos_model.dart';

class MedicamentosPage extends StatefulWidget {
  const MedicamentosPage({super.key});

  @override
  _MedicamentosPageState createState() => _MedicamentosPageState();
}

class _MedicamentosPageState extends State<MedicamentosPage> {
  String searchQuery = '';
  String selectedFilter = 'Todos';

  List<MedicamentosModel> medicamentos = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    carregarMedicamentos();
  }

  Future<void> carregarMedicamentos() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final service = MedicamentoService();
      final lista = await service.fetchMedicamentos();
      setState(() {
        medicamentos = lista;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Erro ao carregar medicamentos: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  List<MedicamentosModel> get filteredMedicamentos {
    return medicamentos.where((med) {
      final tipoMatch = selectedFilter == 'Todos' || med.tipoMedicamento == selectedFilter;
      final nomeMatch = searchQuery.isEmpty || med.nome.toLowerCase().contains(searchQuery.toLowerCase());
      return tipoMatch && nomeMatch;
    }).toList();
  }

  final filtros = ['Todos', 'ORIGINAL', 'GENERICO'];

  @override
  Widget build(BuildContext context) {
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
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: filtros.map((filtro) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(filtro),
                      selected: selectedFilter == filtro,
                      onSelected: (bool selected) {
                        setState(() {
                          selectedFilter = filtro;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
            if (isLoading)
              const Expanded(child: Center(child: CircularProgressIndicator())),
            if (errorMessage != null)
              Expanded(
                child: Center(
                  child: Text(errorMessage!, style: const TextStyle(color: Colors.red)),
                ),
              ),
            if (!isLoading && errorMessage == null)
              Expanded(
                child: filteredMedicamentos.isEmpty
                    ? const Center(child: Text('Nenhum medicamento encontrado'))
                    : ListView.builder(
                        itemCount: filteredMedicamentos.length,
                        itemBuilder: (context, index) {
                          final med = filteredMedicamentos[index];
                          return _MedicamentoCard(
                            nome: med.nome,
                            tipo: med.tipoMedicamento,
                            disponivel: med.disponibilidade != null
                                ? {med.disponibilidade!: 0} 
                                : {},
                          );
                        },
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
            if (disponivel.isEmpty)
              Text('Sem informações', style: TextStyle(color: Colors.grey.shade600)),
            ...disponivel.entries.map(
              (entry) => Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.blue),
                  const SizedBox(width: 4),
                  Text(
                    "${entry.key}${entry.value > 0 ? ': ${entry.value} un.' : ''}",
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
