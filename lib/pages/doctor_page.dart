import 'package:flutter/material.dart';
import '../components/bottom_nav_bar.dart';

class DoctorsPage extends StatefulWidget {
  const DoctorsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DoctorsPageState createState() => _DoctorsPageState();
}

class _DoctorsPageState extends State<DoctorsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedSpecialty = '';
  bool _isSpecialtyDropdownOpen = false;
  
  // Lista de especialidades disponíveis
  final List<String> _specialties = [
    'Todas',
    'Cardiologia',
    'Dermatologia',
    'Ginecologia',
    'Ortopedia',
    'Pediatria',
    'Clínica Geral',
  ];

  // Dados mockados de médicos
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
      // Filtro por nome
      final nameMatch = doctor['name'].toLowerCase().contains(_searchController.text.toLowerCase());
      
      // Filtro por especialidade
      final specialtyMatch = _selectedSpecialty.isEmpty || 
                           _selectedSpecialty == 'Todas' || 
                           doctor['specialty'] == _selectedSpecialty;
      
      return nameMatch && specialtyMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.blue),
          onPressed: () {},
        ),
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
            // Título da página de médicos
            Container(
              padding: const EdgeInsets.all(4),
              child: const Text(
                "Médicos",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
            ),
            const SizedBox(height: 10),
            // Container do buscador (REDUZIDO)
            _buildSearchContainer(),
            const SizedBox(height: 10),
            // Lista de médicos
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

  Widget _buildSearchContainer() {
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
              const Icon(Icons.search, color: Colors.blue, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Buscar Médicos",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                    Text(
                      "Por nome ou especialidade",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Campo de busca por nome
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                hintText: 'Nome do médico...',
                hintStyle: const TextStyle(fontSize: 14),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                prefixIconConstraints: const BoxConstraints(minWidth: 30, maxWidth: 30),
                prefixIcon: const Icon(Icons.search, color: Colors.blue, size: 20),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey, size: 18),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                          });
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          const SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isSpecialtyDropdownOpen = !_isSpecialtyDropdownOpen;
                  });
                },
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedSpecialty.isEmpty ? 'Especialidade' : _selectedSpecialty,
                        style: TextStyle(
                          fontSize: 14,
                          color: _selectedSpecialty.isEmpty ? Colors.grey : Colors.black,
                        ),
                      ),
                      Icon(
                        _isSpecialtyDropdownOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                        color: Colors.grey,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
              if (_isSpecialtyDropdownOpen)
                Container(
                  constraints: const BoxConstraints(maxHeight: 150),
                  margin: const EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [BoxShadow(color: Colors.grey.shade300, spreadRadius: 1, blurRadius: 5)],
                  ),
                  child: ListView(
                    shrinkWrap: true,
                    children: _specialties.map((specialty) => 
                      InkWell(
                        onTap: () {
                          setState(() {
                            _selectedSpecialty = specialty;
                            _isSpecialtyDropdownOpen = false;
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          decoration: BoxDecoration(
                            color: _selectedSpecialty == specialty ? Colors.blue.shade50 : Colors.white,
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey.shade200,
                                width: 1,
                              ),
                            ),
                          ),
                          child: Text(
                            specialty,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    ).toList(),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // Função auxiliar para criar o cartão de informações do médico
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