import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:bithealth_front_end/components/bottom_nav_bar.dart';

class MapaPage extends StatefulWidget {
  const MapaPage({super.key});

  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  String searchQuery = '';
  String selectedFilter = 'Todos';

  // Lista de unidades de saúde
  List<Map<String, dynamic>> unidades = [
    {
      'nome': 'Hospital Municipal',
      'tipo': 'Hospital',
      'latitude': -8.2761,
      'longitude': -36.4989,
      'cor': Colors.red,
    },
    {
      'nome': 'UBS Centro',
      'tipo': 'UBS',
      'latitude': -8.2721,
      'longitude': -36.4909,
      'cor': Colors.blue,
    },
    {
      'nome': 'Farmácia Municipal',
      'tipo': 'Farmácia',
      'latitude': -8.2755,
      'longitude': -36.4952,
      'cor': Colors.green,
    },
    {
      'nome': 'UPA',
      'tipo': 'UPA',
      'latitude': -8.2734,
      'longitude': -36.4931,
      'cor': Colors.yellow,
    },
  ];

  @override
  Widget build(BuildContext context) {
    var filteredUnidades = unidades.where((unidade) {
      return (selectedFilter == 'Todos' || unidade['tipo'] == selectedFilter) &&
          (searchQuery.isEmpty || unidade['nome']!.toLowerCase().contains(searchQuery.toLowerCase()));
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mapa de Correntes"),
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
                hintText: 'Buscar unidades...',
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
                    label: Text('Hospitais'),
                    selected: selectedFilter == 'Hospitais',
                    onSelected: (bool value) {
                      setState(() {
                        selectedFilter = 'Hospitais';
                      });
                    },
                  ),
                  SizedBox(width: 8),
                  FilterChip(
                    label: Text('Farmácias'),
                    selected: selectedFilter == 'Farmácias',
                    onSelected: (bool value) {
                      setState(() {
                        selectedFilter = 'Farmácias';
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 250,
              child: FlutterMap(
                options: MapOptions(
                  center: LatLng(-8.2744, -36.4949), // Coordenada inicial do mapa
                  zoom: 14,
                ),
                children: [
                  TileLayer(
                    urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c'],
                  ),
                  MarkerLayer(
                    markers: unidades.map((unidade) {
                      return Marker(
                        width: 80.0,
                        height: 80.0,
                        point: LatLng(unidade['latitude'], unidade['longitude']),
                        builder: (ctx) => Container(
                          child: Icon(
                            Icons.location_on,
                            color: unidade['cor'],
                            size: 40.0,
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
              child: ListView(
                children: filteredUnidades.map((unidade) {
                  return _UnidadeCard(
                    nome: unidade['nome']!,
                    tipo: unidade['tipo']!,
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(selectedIndex: 1),
    );
  }
}

class _UnidadeCard extends StatelessWidget {
  final String nome;
  final String tipo;

  const _UnidadeCard({
    required this.nome,
    required this.tipo,
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
          ],
        ),
      ),
    );
  }
}
