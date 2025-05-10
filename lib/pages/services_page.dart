import 'package:flutter/material.dart';
import '../components/bottom_nav_bar.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  _ServicesPageState createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  final TextEditingController _serviceController = TextEditingController();
  String? _serviceType = 'Todos';
  List<String> serviceTypes = ['Todos', 'Exames', 'Consultas', 'Procedimentos', 'Terapias'];

  List<Map<String, dynamic>> _allServices = [
    {
      "title": "Consulta Médica - Clínica Geral",
      "type": "Consultas",
      "locations": [
        "Hospital Municipal: Segunda a Sexta: 8h às 17h",
        "UBS Centro: Segunda a Sexta: 7h às 16h",
        "UPA 24h: 24 horas"
      ],
    },
    {
      "title": "Consulta Médica - Pediatria",
      "type": "Consultas",
      "locations": [
        "Hospital Municipal: Segunda a Sexta: 8h às 17h",
        "UBS Centro: Segunda, Quarta e Sexta: 8h às 12h"
      ],
    },
    {
      "title": "Exame de Sangue",
      "type": "Exames",
      "locations": [
        "Hospital Municipal: Segunda a Sexta: 7h às 10h"
      ],
    },
  ];

  List<Map<String, dynamic>> _filteredServices = [];

  @override
  void initState() {
    super.initState();
    _filteredServices = List.from(_allServices);
    _serviceController.addListener(_applyFilters);
  }

  void _applyFilters() {
    String searchText = _serviceController.text.toLowerCase();
    String selectedType = _serviceType ?? 'Todos';

    setState(() {
      _filteredServices = _allServices.where((service) {
        final matchesName = service['title'].toLowerCase().contains(searchText);
        final matchesType = selectedType == 'Todos' || service['type'] == selectedType;
        return matchesName && matchesType;
      }).toList();
    });
  }

  @override
  void dispose() {
    _serviceController.dispose();
    super.dispose();
  }

  Widget _buildServiceSearchContainer() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.shade300, spreadRadius: 1, blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // const Icon(Icons.search, color: Colors.blue, size: 20),
              const SizedBox(width: 8),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Buscar Serviços",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                    Text(
                      "Por nome ou tipo",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              controller: _serviceController,
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                hintText: 'Nome do serviço...',
                hintStyle: const TextStyle(fontSize: 14),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10,horizontal: 8),
                prefixIconConstraints: const BoxConstraints(minWidth: 30, maxWidth: 30),
                prefixIcon: const Icon(Icons.search, color: Colors.blue, size: 20),
                suffixIcon: _serviceController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey, size: 18),
                        onPressed: () {
                          setState(() {
                            _serviceController.clear();
                            _applyFilters();
                          });
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                _applyFilters();
              },
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButton<String>(
              value: _serviceType,
              onChanged: (String? newValue) {
                setState(() {
                  _serviceType = newValue!;
                  _applyFilters();
                });
              },
              underline: const SizedBox(),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
              isExpanded: true,
              items: serviceTypes.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(
                    type,
                    style: const TextStyle(fontSize: 14),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Serviços",
        style: TextStyle(
        fontWeight: FontWeight.bold,
          ),
        ),
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
            _buildServiceSearchContainer(),
            const SizedBox(height: 24),
            Expanded(
              child: _filteredServices.isEmpty
                  ? const Center(child: Text("Nenhum serviço encontrado."))
                  : ListView.builder(
                      itemCount: _filteredServices.length,
                      itemBuilder: (context, index) {
                        final service = _filteredServices[index];
                        return ServiceCard(
                          title: service['title'],
                          type: service['type'],
                          locations: List<String>.from(service['locations']),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(selectedIndex: 0),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final String title;
  final String type;
  final List<String> locations;

  const ServiceCard({
    super.key,
    required this.title,
    required this.type,
    required this.locations,
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
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 8),
            Chip(
              label: Text(type),
              backgroundColor: Colors.blue.shade100,
            ),
            const SizedBox(height: 8),
            const Text("Disponível em:"),
            for (var location in locations)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.location_on, size: 20),
                title: Text(location),
              ),
          ],
        ),
      ),
    );
  }
}
