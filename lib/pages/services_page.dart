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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Serviços"),
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
            const Text(
              "Buscar Serviços",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Encontre serviços disponíveis nas unidades",
              style: TextStyle(fontSize: 16, color: Colors.blue),
            ),
            const SizedBox(height: 24),
            // Campo de busca
            TextField(
              controller: _serviceController,
              decoration: InputDecoration(
                labelText: 'Nome do serviço...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Filtro por tipo de serviço
            DropdownButtonFormField<String>(
              value: _serviceType,
              onChanged: (String? newValue) {
                setState(() {
                  _serviceType = newValue!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Tipo de serviço',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items: serviceTypes
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            // Lista de serviços
            Expanded(
              child: ListView(
                children: [
                  ServiceCard(
                    title: "Consulta Médica - Clínica Geral",
                    type: "Consulta",
                    locations: [
                      "Hospital Municipal: Segunda a Sexta: 8h às 17h",
                      "UBS Centro: Segunda a Sexta: 7h às 16h",
                      "UPA 24h: 24 horas"
                    ],
                  ),
                  ServiceCard(
                    title: "Consulta Médica - Pediatria",
                    type: "Consulta",
                    locations: [
                      "Hospital Municipal: Segunda a Sexta: 8h às 17h",
                      "UBS Centro: Segunda, Quarta e Sexta: 8h às 12h"
                    ],
                  ),
                  ServiceCard(
                    title: "Exame de Sangue",
                    type: "Exame",
                    locations: [
                      "Hospital Municipal: Segunda a Sexta: 7h às 10h"
                    ],
                  ),
                ],
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
                  fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            const SizedBox(height: 8),
            Chip(
              label: Text(type),
              backgroundColor: Colors.blue.shade100,
            ),
            const SizedBox(height: 8),
            const Text("Disponível em:"),
            for (var location in locations) ...[
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.location_on, size: 20),
                title: Text(location),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
