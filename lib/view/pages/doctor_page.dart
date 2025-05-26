// ignore_for_file: library_private_types_in_public_api

import 'package:bithealth_front_end/model/doctor_model.dart';
import 'package:bithealth_front_end/services/doctor_service.dart';
import 'package:flutter/material.dart';
import '../components/bottom_nav_bar.dart';
import '../components/app_bar.dart';
import '../components/SearchFilterWidget.dart';

class DoctorsPage extends StatefulWidget {
  const DoctorsPage({super.key});

  @override
  _DoctorsPageState createState() => _DoctorsPageState();
}

class _DoctorsPageState extends State<DoctorsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedSpecialty = '';
  List<DoctorModel> _doctors = [];
  List<String> _specialties = ['Todas'];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadDoctors();
  }

  Future<void> _loadDoctors() async {
    try {
      final doctors = await DoctorService().fetchDoctors();

      final extractedSpecialties = doctors
          .map((d) => d.especialidade.trim())
          .where((e) => e.isNotEmpty)
          .toSet()
          .toList()
        ..sort();

      setState(() {
        _doctors = doctors;
        _specialties = ['Todas', ...extractedSpecialties];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  List<DoctorModel> get filteredDoctors {
    return _doctors.where((doctor) {
      final nameMatch = doctor.nome.toLowerCase().contains(_searchController.text.toLowerCase());
      final specialtyMatch = _selectedSpecialty.isEmpty ||
          _selectedSpecialty == 'Todas' ||
          doctor.especialidade == _selectedSpecialty;
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
      appBar: const CustomAppBar(title: "Médicos"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(4),
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
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                      ? Center(
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        )
                      : filteredDoctors.isEmpty
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
                                  nome: doctor.nome,
                                  crm: doctor.crm,
                                  especialidade: doctor.especialidade,
                                  unidade: doctor.unidade_saude_name,
                                  data: doctor.data_plantao,
                                  inicio: doctor.horario_inicio,
                                  fim: doctor.horario_fim,
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
    required String nome,
    required String crm,
    required String especialidade,
    required String unidade,
    required String data,
    required String inicio,
    required String fim,
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
              nome,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            const SizedBox(height: 8),
            Text(
              'CRM: $crm • $especialidade',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.orange),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    unidade,
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
                  '$data - $inicio às $fim',
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
