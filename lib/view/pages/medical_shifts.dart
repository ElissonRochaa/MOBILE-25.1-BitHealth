import 'package:bithealth_front_end/view/components/bottom_nav_bar.dart';
import 'package:flutter/material.dart';

class SelecaoPlantaoScreen extends StatefulWidget {
  const SelecaoPlantaoScreen({super.key});

  @override
  State<SelecaoPlantaoScreen> createState() => _SelecaoPlantaoScreenState();
}

class _SelecaoPlantaoScreenState extends State<SelecaoPlantaoScreen> {
  String? _hospitalSelecionado = 'Hospital Municipal';
  DateTime _dataSelecionada = DateTime(2025, 4, 10);
  final int _bottomNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        title: const Text('Saúde Correntes'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Plantões',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 20),
            Card(
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
                      'Selecionar Hospital',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Escolha o hospital para ver a escala de plantão',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                      value: _hospitalSelecionado,
                      icon: Icon(Icons.arrow_drop_down, color: Colors.blue),
                      items: <String>['Hospital Municipal', 'Hospital Regional', 'UPA Central']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: TextStyle(color: Colors.black87)),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _hospitalSelecionado = newValue;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
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
                      'Selecionar Data',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Escolha uma data para ver a escala',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 16),
                    _buildCalendar(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: (){
                  Navigator.pushNamed(context, '/escala_plantao');
                },
                child: const Text('Ver Escala de Plantão'),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(selectedIndex: _bottomNavIndex),
    );
  }

  Widget _buildCalendar() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.chevron_left, color: Colors.blue),
              onPressed: () {
                setState(() {
                  int newMonth = _dataSelecionada.month - 1;
                  int newYear = _dataSelecionada.year;
                  if (newMonth == 0) {
                    newMonth = 12;
                    newYear--;
                  }
                  int daysInNewMonth = DateTime(newYear, newMonth + 1, 0).day;
                  int newDay = _dataSelecionada.day > daysInNewMonth ? daysInNewMonth : _dataSelecionada.day;
                  _dataSelecionada = DateTime(newYear, newMonth, newDay);
                });
              },
            ),
            Text(
              '${_getMonthName(_dataSelecionada.month)} ${_dataSelecionada.year}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            IconButton(
              icon: Icon(Icons.chevron_right, color: Colors.blue),
              onPressed: () {
                 setState(() {
                  int newMonth = _dataSelecionada.month + 1;
                  int newYear = _dataSelecionada.year;
                  if (newMonth == 13) {
                    newMonth = 1;
                    newYear++;
                  }
                  int daysInNewMonth = DateTime(newYear, newMonth + 1, 0).day;
                  int newDay = _dataSelecionada.day > daysInNewMonth ? daysInNewMonth : _dataSelecionada.day;
                  _dataSelecionada = DateTime(newYear, newMonth, newDay);
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 10),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 7,
          children: <String>['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa']
              .map((day) => Center(child: Text(day, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700]))))
              .toList(),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
          itemCount: DateTime(_dataSelecionada.year, _dataSelecionada.month + 1, 0).day + _getInitialEmptyDays(),
          itemBuilder: (context, index) {
            final initialEmptyDays = _getInitialEmptyDays();
            if (index < initialEmptyDays) {
              return Container();
            }
            int dia = index - initialEmptyDays + 1;
            DateTime currentDate = DateTime(_dataSelecionada.year, _dataSelecionada.month, dia);
            bool isSelected = dia == _dataSelecionada.day && currentDate.month == _dataSelecionada.month;


            if (currentDate.month != _dataSelecionada.month) {
                return Container();
            }

            return GestureDetector(
              onTap: () {
                setState(() {
                  _dataSelecionada = DateTime(_dataSelecionada.year, _dataSelecionada.month, dia);
                });
              },
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue : Colors.transparent,
                  borderRadius: BorderRadius.circular(isSelected ? 20 : 8),
                  border: Border.all(
                    color: isSelected ? Colors.blue : Colors.grey[300]!,
                    width: 1
                  )
                ),
                child: Center(
                  child: Text(
                    '$dia',
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  String _getMonthName(int month) {
    const monthNames = ["", "Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho", "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"];
    return monthNames[month];
  }

  int _getInitialEmptyDays() {
    int weekday = DateTime(_dataSelecionada.year, _dataSelecionada.month, 1).weekday;
    return weekday == 7 ? 0 : weekday;
  }
}

