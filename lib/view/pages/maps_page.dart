import 'package:bithealth_front_end/model/unidade_saude_model.dart';
import 'package:bithealth_front_end/services/unidade_saude_service.dart';
import 'package:bithealth_front_end/view/components/SearchFilterWidget.dart';
import 'package:bithealth_front_end/view/components/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../components/app_bar.dart';

class MapaPage extends StatefulWidget {
  const MapaPage({super.key});

  @override
  State<MapaPage> createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  final UnidadeSaudeService _unidadeSaudeService = UnidadeSaudeService();
  List<UnidadeSaudeModel> _unidades = [];
  String _searchQuery = '';
  String _selectedFilter = 'Todos';
  final TextEditingController _searchController = TextEditingController();

  LatLng _mapCenter = LatLng(-8.2735, -36.4933); 
  double _mapZoom = 14.0;

  @override
  void initState() {
    super.initState();
    _fetchUnidades();
  }

  Future<void> _fetchUnidades() async {
    try {
      final unidades = await _unidadeSaudeService.fetchDoctors();
      setState(() {
        _unidades = unidades;
      });
    } catch (e) {
      print('Erro ao carregar unidades: $e');
    }
  }

  List<UnidadeSaudeModel> get _filteredUnidades {
    return _unidades.where((u) {
      final matchTipo = _selectedFilter == 'Todos' || u.tipo.toLowerCase() == _selectedFilter.toLowerCase();
      final matchNome = _searchQuery.isEmpty || u.nome.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchTipo && matchNome;
    }).toList();
  }

  void _updateMapCenter(LatLng newCenter) {
    setState(() {
      _mapCenter = newCenter;
      _mapZoom = 15.0; 
    });
  }

  Color _getColorByTipo(String tipo) {
    switch (tipo.trim().toLowerCase()) {
      case 'hospital':
        return Colors.red;
      case 'ubs':
        return Colors.blue;
      case 'farmacia':
        return Colors.green;
      case 'upa':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Mapa"),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SearchFilterWidget(
              title: 'Unidades de Saúde',
              subtitle: 'Filtre por nome ou tipo',
              searchHint: 'Buscar unidades...',
              options: const ['Todos', 'Hospital', 'UBS', 'Farmacia', 'UPA'],
              selectedOption: _selectedFilter,
              searchController: _searchController,
              onSearchChanged: (query) => setState(() => _searchQuery = query),
              onOptionSelected: (option) => setState(() => _selectedFilter = option),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: FlutterMap(
                options: MapOptions(
                  center: _mapCenter, // Centraliza o mapa com a coordenada inicial em Correntes
                  zoom: _mapZoom,
                ),
                children: [
                  TileLayer(
                    urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c'],
                  ),
                  MarkerLayer(
                    markers: _filteredUnidades.map((unidade) {
                      final lat = double.tryParse(unidade.endereco.latitude) ?? 0;
                      final lng = double.tryParse(unidade.endereco.longitude) ?? 0;
                      return Marker(
                        width: 80,
                        height: 80,
                        point: LatLng(lat, lng),
                        builder: (ctx) => GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(unidade.nome),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Tipo: ${unidade.tipo}'),
                                    Text('Início: ${unidade.horarioInicioAtendimento}'),
                                    Text('Fim: ${unidade.horarioFimAtendimento}'),
                                    const SizedBox(height: 8),
                                    Text('Latitude: ${unidade.endereco.latitude}'),
                                    Text('Longitude: ${unidade.endereco.longitude}'),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: const Text('Fechar'),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: Icon(
                            Icons.location_on,
                            color: _getColorByTipo(unidade.tipo),
                            size: 40,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredUnidades.length,
                itemBuilder: (context, index) {
                  final unidade = _filteredUnidades[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: Icon(
                        Icons.location_on,
                        color: _getColorByTipo(unidade.tipo),
                      ),
                      title: Text(unidade.nome),
                      subtitle: Text(
                        '${unidade.tipo} | ${unidade.horarioInicioAtendimento} - ${unidade.horarioFimAtendimento}',
                      ),
                      onTap: () {
                        final lat = double.tryParse(unidade.endereco.latitude) ?? 0;
                        final lng = double.tryParse(unidade.endereco.longitude) ?? 0;
                        _updateMapCenter(LatLng(lat, lng)); // Centraliza o mapa na unidade
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(selectedIndex: 1),
    );
  }
}
