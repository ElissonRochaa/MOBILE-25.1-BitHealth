import 'package:flutter/material.dart';
import '../components/bottom_nav_bar.dart';
import '../components/SearchFilterWidget.dart';

class DoctorsPage extends StatefulWidget {
  const DoctorsPage({super.key});

  @override
  _DoctorsPageState createState() => _DoctorsPageState();
}

class _DoctorsPageState extends State<DoctorsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedSpecialty = '';
  
  final List<String> _specialties = [
    'Todas',
    'Cardiologia',
    'Dermatologia',
    'Ginecologia',
    'Ortopedia',
    'Pediatria',
    'Clínica Geral',
  ];

  final List<Map<String, dynamic>> _doctors = [
    {
      'name': 'Dra. Maria Santos',
      'crm': '23456-PE',
      'specialty': 'Pediatria',
      'hospital': 'Hospital Municipal de Correntes',
      'schedule': 'Segunda a Sexta: 13h às 18h',
    },
    {
      'name': 'Dr. Carlos Oliveira',
      'crm': '34567-PE',
      'specialty': 'Ortopedia',
      'hospital': 'Hospital Municipal de Correntes',
      'schedule': 'Terça e Quinta: 8h às 17h',
    },
    {
      'name': 'Dra. Ana Pereira',
      'crm': '45678-PE',
      'specialty': 'Clínica Geral',
      'hospital': 'UBS Centro de Correntes',
      'schedule': 'Segunda a Sexta: 8h às 12h',
    },
    {
      'name': 'Dr. João Silva',
      'crm': '12345-PE',
      'specialty': 'Cardiologia',
      'hospital': 'Hospital Municipal de Correntes',
      'schedule': 'Segunda a Sexta: 8h às 14h',
    },
    {
      'name': 'Dra. Patrícia Lima',
      'crm': '56789-PE',
      'specialty': 'Dermatologia',
      'hospital': 'Clínica Santa Isabel',
      'schedule': 'Segunda, Quarta e Sexta: 14h às 18h',
    },
    {
      'name': 'Dr. Roberto Almeida',
      'crm': '67890-PE',
      'specialty': 'Ginecologia',
      'hospital': 'Hospital Municipal de Correntes',
      'schedule': 'Terça e Quinta: 13h às 19h',
    },
  ];

  List<Map<String, dynamic>> get filteredDoctors {
    return _doctors.where((doctor) {
      final nameMatch = doctor['name'].toLowerCase().contains(_searchController.text.toLowerCase());
      final specialtyMatch = _selectedSpecialty.isEmpty || doctor['specialty'] == _selectedSpecialty;
      return nameMatch && specialtyMatch;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Saúde Correntes",
          style: TextStyle(color: Colors.blue, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(4),
              child: const Text(
                "Médicos",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
            ),
            const SizedBox(height: 10),
            SearchFilterWidget(
              title: 'Buscar Médicos',
              subtitle: 'Por nome ou especialidade',
              searchHint: 'Nome do médico...',
              options: _specialties,
              selectedOption: _selectedSpecialty,
              searchController: _searchController,
              onSearchChanged: (value) {
                setState(() {});
              },
              onOptionSelected: (value) {
                setState(() {
                  _selectedSpecialty = value;
                });
              },
            ),
            const SizedBox(height: 10),
            Expanded(
              child: filteredDoctors.isEmpty
                  ? Center(
                      child: Text(
                        'Nenhum médico encontrado',
                        style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredDoctors.length,
                      itemBuilder: (context, index) {
                        final doctor = filteredDoctors[index];
                        return _buildDoctorCard(
                          name: doctor['name'],
                          crm: doctor['crm'],
                          specialty: doctor['specialty'],
                          hospital: doctor['hospital'],
                          schedule: doctor['schedule'],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(selectedIndex: 2),
    );
  }

  Widget _buildDoctorCard({
    required String name,
    required String crm,
    required String specialty,
    required String hospital,
    required String schedule,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            const SizedBox(height: 8),
            Text(
              'CRM: $crm • $specialty',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.orange),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    hospital,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  schedule,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  'Ver Unidade no Mapa',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
