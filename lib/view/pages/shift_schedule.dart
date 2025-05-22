import 'package:bithealth_front_end/view/components/bottom_nav_bar.dart';
import 'package:flutter/material.dart';

class EscalaPlantaoScreen extends StatefulWidget {
  const EscalaPlantaoScreen({super.key});

  @override
  State<EscalaPlantaoScreen> createState() => _EscalaPlantaoScreenState();
}

class _EscalaPlantaoScreenState extends State<EscalaPlantaoScreen> {
  int get _bottomNavIndex {
      final currentRoute = ModalRoute.of(context)?.settings.name;
      if (currentRoute == '/home') return 0;
      if (currentRoute == '/mapa') return 1;
      if (currentRoute == '/escala_plantao' || currentRoute == '/medicos') return 2;
      if (currentRoute == '/medicamentos') return 3;
      if (currentRoute == '/notificacoes') return 4;
      return 0;
  }

  int _selectedDateChipIndex = 3;
  bool _isDiurno = true;

  final List<Map<String, String>> _medicosDiurno = [
    {'nome': 'Dr. João Silva', 'especialidade': 'Clínica Geral', 'contato': 'Ramal 101'},
    {'nome': 'Dra. Maria Santos', 'especialidade': 'Pediatria', 'contato': 'Ramal 102'},
    {'nome': 'Dr. Carlos Oliveira', 'especialidade': 'Ortopedia', 'contato': 'Ramal 103'},
    {'nome': 'Dra. Fernanda Lima', 'especialidade': 'Ginecologia', 'contato': 'Ramal 104'},
  ];

  final List<Map<String, String>> _medicosNoturno = [
    {'nome': 'Dr. Pedro Alves', 'especialidade': 'Clínica Geral', 'contato': 'Ramal 105'},
    {'nome': 'Dra. Ana Costa', 'especialidade': 'Emergência', 'contato': 'Ramal 106'},
  ];

  final List<DateTime> _datasReaisChips = List.generate(7, (index) {
    return DateTime.now().subtract(const Duration(days: 3)).add(Duration(days: index));
  });
  late DateTime _dataSelecionadaChip;
  List<String> get _diasSemanaChips => _datasReaisChips.map((date) => date.day.toString()).toList();


 @override
  void initState() {
    super.initState();
    _dataSelecionadaChip = _datasReaisChips[_selectedDateChipIndex];
  }

  @override
  Widget build(BuildContext context) {
    final medicosExibidos = _isDiurno ? _medicosDiurno : _medicosNoturno;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacementNamed(context, '/home');
            }
          },
        ),
        title: const Text('Saúde Correntes'),
      ),
      body: Column(
        children: <Widget>[
          _buildDateChipSelector(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                       Text(
                        'Escala de Plantão',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Hospital Municipal - ${_formatDate(_dataSelecionadaChip)}',
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 16),
                      _buildTurnoSelector(),
                      const SizedBox(height: 16),
                      _buildMedicosTable(medicosExibidos),
                      const SizedBox(height: 20),
                      Center(
                        child: Text(
                          'Para emergências, ligue para o hospital:\n(87) 3333-4444',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 13, color: Colors.grey[800], fontStyle: FontStyle.italic),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(selectedIndex: _bottomNavIndex),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  Widget _buildDateChipSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      color: Colors.white,
      child: SizedBox(
        height: 50,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _diasSemanaChips.length,
          itemBuilder: (context, index) {
            bool isSelected = index == _selectedDateChipIndex;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedDateChipIndex = index;
                  _dataSelecionadaChip = _datasReaisChips[index];
                });
              },
              child: Container(
                width: 60,
                margin: EdgeInsets.only(left: index == 0 ? 16 : 4, right: index == _diasSemanaChips.length -1 ? 16: 4),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.transparent,
                  border: Border.all(color: isSelected ? Colors.blue : Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    _diasSemanaChips[index],
                    style: TextStyle(
                      color: isSelected ? Colors.blue : Colors.black54,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTurnoSelector() {
    Color activeColor = Colors.blue;
    Color inactiveColor = Colors.black54;
    Color activeBgColor = activeColor.withOpacity(0.1);

    return Row(
      children: <Widget>[
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              setState(() {
                _isDiurno = true;
              });
            },
            style: OutlinedButton.styleFrom(
              backgroundColor: _isDiurno ? activeBgColor : Colors.transparent,
              side: BorderSide(color: _isDiurno ? activeColor : Colors.grey),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12)
            ),
            child: Text('Diurno (7h-19h)', style: TextStyle(color: _isDiurno ? activeColor : inactiveColor)),
          ),
        ),
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              setState(() {
                _isDiurno = false;
              });
            },
            style: OutlinedButton.styleFrom(
              backgroundColor: !_isDiurno ? activeBgColor : Colors.transparent,
              side: BorderSide(color: !_isDiurno ? activeColor : Colors.grey),
               shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12)
            ),
            child: Text('Noturno (19h-7h)', style: TextStyle(color: !_isDiurno ? activeColor : inactiveColor)),
          ),
        ),
      ],
    );
  }

  Widget _buildMedicosTable(List<Map<String, String>> medicos) {
    if (medicos.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            'Não há médicos escalados para este turno.',
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
         Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          child: Row(
            children: [
              Expanded(flex: 3, child: Text('Médico', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700]))),
              Expanded(flex: 3, child: Text('Especialidade', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700]))),
              Expanded(flex: 2, child: Text('Contato', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700]))),
            ],
          ),
        ),
        const Divider(),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: medicos.length,
          itemBuilder: (context, index) {
            final medico = medicos[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 4.0),
              child: Row(
                children: <Widget>[
                  Expanded(flex: 3, child: Text(medico['nome']!, style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black87))),
                  Expanded(flex: 3, child: Text(medico['especialidade']!, style: TextStyle(color: Colors.grey[700]))),
                  Expanded(flex: 2, child: Text(medico['contato']!, style: TextStyle(color: Colors.grey[700]))),
                ],
              ),
            );
          },
          separatorBuilder: (context, index) => const Divider(height: 1),
        ),
      ],
    );
  }
}