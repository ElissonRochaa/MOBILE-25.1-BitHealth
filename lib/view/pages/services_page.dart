import 'package:bithealth_front_end/controller/services_controller.dart';
import 'package:bithealth_front_end/model/services_model.dart';
import 'package:flutter/material.dart';
import '../components/bottom_nav_bar.dart';
import '../components/app_bar.dart';
import '../components/SearchFilterWidget.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  _ServicesPageState createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  final TextEditingController _serviceController = TextEditingController();
  String _serviceType = 'Todos';
  List<String> serviceTypes = ['Todos', 'Exames Laboratoriais', 'Consulta Clínica Geral'];

  late final ServicesController _servicesController;

  List<ServicesModel> _allServices = [];
  List<ServicesModel> _filteredServices = [];

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _servicesController = ServicesController();
    _servicesController.addListener(_onControllerChange);
    _loadServices(); 
    _serviceController.addListener(_applyFilters);
  }

  void _onControllerChange() {
    setState(() {
      _isLoading = _servicesController.isLoading;
      _allServices = _servicesController.servicesList;

      _applyFilters();
    });
  }

  Future<void> _loadServices() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _servicesController.loadServices();

    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = "Falha ao carregar serviços: ${e.toString()}";
        _isLoading = false;
        _allServices = [];
        _filteredServices = [];
      });
    }
  }

  void _applyFilters() {
    String searchText = _serviceController.text.toLowerCase();
    String selectedType = _serviceType;

    setState(() {
      _filteredServices = _allServices.where((service) {
        final matchesName = service.nome.toLowerCase().contains(searchText);
        bool matchesType = selectedType == 'Todos';
        if (selectedType == 'Consultas' && service.nome.toLowerCase().contains('consulta')) {
          matchesType = true;
        } else if (selectedType == 'Exames' && service.nome.toLowerCase().contains('exame')) {
          matchesType = true;
        } else if (selectedType == service.nome) {
          matchesType = true;
        }
        return matchesName && matchesType;
      }).toList();
    });
  }

  void _onSearchChanged(String value) {
    _applyFilters();
  }

  void _onOptionSelected(String option) {
    setState(() {
      _serviceType = option;
      _applyFilters();
    });
  }

  @override
  void dispose() {
    _serviceController.dispose();
    _servicesController.removeListener(_onControllerChange);
    _servicesController.dispose(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Serviços"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            SearchFilterWidget(
              title: "Buscar Serviços",
              subtitle: "Por nome ou tipo",
              searchHint: "Nome do serviço...",
              options: serviceTypes,
              selectedOption: _serviceType,
              searchController: _serviceController,
              onSearchChanged: _onSearchChanged,
              onOptionSelected: _onOptionSelected,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: _buildServiceListContent(), 
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(selectedIndex: 0),
    );
  }

  Widget _buildServiceListContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            _errorMessage!,
            style: const TextStyle(color: Colors.red, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (_filteredServices.isEmpty) {
      return const Center(child: Text("Nenhum serviço encontrado."));
    }

    return ListView.builder(
      itemCount: _filteredServices.length,
      itemBuilder: (context, index) {
        final service = _filteredServices[index];
        return ServiceCard(
          service: service,
        );
      },
    );
  }
}

class ServiceCard extends StatelessWidget {
  final ServicesModel service;

  const ServiceCard({
    super.key,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    String serviceTypeDisplay;
    if (service.nome.toLowerCase().contains('consulta')) {
      serviceTypeDisplay = 'Consultas';
    } else if (service.nome.toLowerCase().contains('exame')) {
      serviceTypeDisplay = 'Exames';
    } else {
      serviceTypeDisplay = 'Outros';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              service.nome,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 8),
            Chip(
              label: Text(serviceTypeDisplay),
              backgroundColor: Colors.blue.shade100,
            ),
            const SizedBox(height: 8),
            Text(
              service.descricao,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            const Text("Disponível em:"),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.location_on, size: 20),
              title: Text(
                "${service.nomeUnidade}: ${service.horarioInicio} às ${service.horarioFim}",
              ),
            ),
          ],
        ),
      ),
    );
  }
}