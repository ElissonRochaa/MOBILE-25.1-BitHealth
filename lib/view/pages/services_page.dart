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
  Set<String> availableServiceTypes = {'Todos'};

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

      final types = _allServices.map((s) => _extractServiceType(s.nome)).toSet();
      availableServiceTypes = {'Todos', ...types};

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
    final searchText = _serviceController.text.toLowerCase();
    final selectedType = _serviceType;

    setState(() {
      _filteredServices = _allServices.where((service) {
        final matchesName = service.nome.toLowerCase().contains(searchText);
        final serviceType = _extractServiceType(service.nome);
        final matchesType = selectedType == 'Todos' || serviceType == selectedType;

        return matchesName && matchesType;
      }).toList();
    });
  }

  void _onSearchChanged(String value) {
    _applyFilters();
  }

  String _extractServiceType(String nome) {
    final lower = nome.toLowerCase();
    if (lower.contains('consulta')) return 'Consultas';
    if (lower.contains('exame')) return 'Exames';
    return 'Outros';
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
              options: availableServiceTypes.toList(),
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
    final colorScheme = Theme.of(context).colorScheme;

    String serviceTypeDisplay;
    if (service.nome.toLowerCase().contains('consulta')) {
      serviceTypeDisplay = 'Consultas';
    } else if (service.nome.toLowerCase().contains('exame')) {
      serviceTypeDisplay = 'Exames';
    } else {
      serviceTypeDisplay = 'Outros';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              service.nome,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Chip(
              label: Text(
                serviceTypeDisplay,
                style: TextStyle(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              backgroundColor: colorScheme.primary.withOpacity(0.1),
            ),
            const SizedBox(height: 8),
            Text(
              service.descricao,
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurface.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.location_on, size: 20, color: colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "${service.nomeUnidade}: ${service.horarioInicio} às ${service.horarioFim}",
                    style: TextStyle(
                      color: colorScheme.onSurface.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
