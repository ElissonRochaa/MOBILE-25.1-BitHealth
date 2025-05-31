import 'package:bithealth_front_end/controller/vaccination_controller.dart';
import 'package:bithealth_front_end/view/components/bottom_nav_bar.dart'; // Certifique-se que o caminho está correto
import 'package:flutter/material.dart';
import '../components/app_bar.dart';

void main() {
  runApp(const VaccinationApp());
}

class VaccinationApp extends StatelessWidget {
  const VaccinationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue.shade800,
        scaffoldBackgroundColor: Colors.grey.shade50,
        appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
      ),
      home: const VaccinationPage(),
    );
  }
}

class VaccinationPage extends StatefulWidget {
  const VaccinationPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _VaccinationPageState createState() => _VaccinationPageState();
}

class _VaccinationPageState extends State<VaccinationPage> {
  String activeTab = "calendario";
  String activeAgeGroup = "criancas";

  final VaccinationController _vaccinationController = VaccinationController();

  @override
  void initState() {
    super.initState();
    _vaccinationController.addListener(_onControllerChange);
    if (activeTab == "campanhas") {
      _vaccinationController.loadVaccination();
    }
  }

  @override
  void dispose() {
    _vaccinationController.removeListener(_onControllerChange);
    _vaccinationController.dispose();
    super.dispose();
  }

  void _onControllerChange() {
    setState(() {
      print('DEBUG: _onControllerChange chamado. Lista de vacinas (tamanho): ${_vaccinationController.vaccinationList.length}');
      if (_vaccinationController.vaccinationList.isNotEmpty) {
        print('DEBUG: Primeira vacina na lista: ${_vaccinationController.vaccinationList.first.vacina}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print('DEBUG: build da VaccinationPage reconstruído. Active Tab: $activeTab');
    print('DEBUG: isLoading: ${_vaccinationController.isLoading}');
    print('DEBUG: vaccinationList size in build: ${_vaccinationController.vaccinationList.length}');

    return Scaffold(
      appBar: const CustomAppBar(title: "Saúde Correntes"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(6),
              child: const Text(
                "Vacinação",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.grey.shade300, spreadRadius: 1, blurRadius: 5)],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTabButton("Calendário", "calendario"),
                  _buildTabButton("Campanhas", "campanhas"),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Builder(
                builder: (context) {
                  if (activeTab == "calendario") {
                    return _buildContainerWithShadow(
                      child: Column(
                        children: [
                          const Text(
                            "Calendário Nacional de Vacinação",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                          ),
                          const Text(
                            "Vacinas obrigatórias por faixa etária",
                            style: TextStyle(fontSize: 16, color: Colors.blue),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildAgeGroupButton("Crianças", "criancas"),
                              _buildAgeGroupButton("Adolescentes", "adolescentes"),
                              _buildAgeGroupButton("Adultos", "adultos"),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Table(
                                columnWidths: const {
                                  0: FixedColumnWidth(100),
                                  1: FixedColumnWidth(150),
                                  2: FixedColumnWidth(100),
                                },
                                border: TableBorder.all(color: Colors.grey.shade400, width: 1),
                                children: [
                                  _buildTableRow("Idade", "Vacina", "Doses", isHeader: true),
                                  if (activeAgeGroup == "criancas") ...[
                                    _buildTableRow("Ao nascer", "BCG", "Dose única"),
                                    _buildTableRow("Ao nascer", "Hepatite B", "1ª dose"),
                                    _buildTableRow("2 meses", "Pentavalente", "1ª dose"),
                                    _buildTableRow("2 meses", "Poliomielite", "1ª dose"),
                                    _buildTableRow("2 meses", "Pneumocócica 10-valente", "1ª dose"),
                                    _buildTableRow("2 meses", "Rotavírus humano", "1ª dose"),
                                    _buildTableRow("3 meses", "Meningocócica C", "1ª dose"),
                                    _buildTableRow("4 meses", "Pentavalente", "2ª dose"),
                                    _buildTableRow("4 meses", "Poliomielite", "2ª dose"),
                                    _buildTableRow("4 meses", "Pneumocócica 10-valente", "2ª dose"),
                                    _buildTableRow("4 meses", "Rotavírus humano", "2ª dose"),
                                    _buildTableRow("5 meses", "Meningocócica C", "2ª dose"),
                                    _buildTableRow("6 meses", "Pentavalente", "3ª dose"),
                                    _buildTableRow("6 meses", "Poliomielite", "3ª dose"),
                                    _buildTableRow("6 meses", "Covid-19", "1ª dose"),
                                    _buildTableRow("7 meses", "Covid-19", "2ª dose"),
                                    _buildTableRow("9 meses", "Febre Amarela", "1 dose"),
                                    _buildTableRow("12 meses", "Pneumocócica 10-valente", "Reforço"),
                                    _buildTableRow("12 meses", "Meningocócica C", "Reforço"),
                                    _buildTableRow("12 meses", "Tríplice viral", "1ª dose"),
                                    _buildTableRow("15 meses", "DTP", "1º reforço"),
                                    _buildTableRow("15 meses", "Poliomielite", "Reforço"),
                                    _buildTableRow("15 meses", "Hepatite A", "1 dose"),
                                    _buildTableRow("15 meses", "Tetra viral", "1 dose"),
                                    _buildTableRow("4 anos", "DTP", "2º reforço"),
                                    _buildTableRow("4 anos", "Febre Amarela", "Reforço"),
                                    _buildTableRow("4 anos", "Varicela", "1 dose"),
                                    _buildTableRow("5 anos", "Febre Amarela", "Dose conforme histórico"),
                                    _buildTableRow("5 anos", "Pneumocócica 23-valente", "2 doses (Pop. Indígena)"),
                                    _buildTableRow("7 anos", "Difteria e Tétano (dT)", "Conforme sit. vacinal / Reforços"),
                                    _buildTableRow("9 e 10 anos", "HPV4", "Dose única"),
                                  ],
                                  if (activeAgeGroup == "adolescentes") ...[
                                    _buildTableRow("A qualquer tempo", "Hepatite B", "Iniciar ou completar 3 doses (conforme sit. vacinal)"),
                                    _buildTableRow("A qualquer tempo", "Difteria e Tétano (dT)", "Iniciar ou completar 3 doses | Reforços"),
                                    _buildTableRow("A qualquer tempo", "Febre Amarela", "Dose única ou reforço (conforme histórico)"),
                                    _buildTableRow("A qualquer tempo", "Tríplice viral", "Iniciar ou completar 2 doses (conforme sit. vacinal)"),
                                    _buildTableRow("11 a 14 anos", "HPV4", "Dose única (resgate 15-19a, vide obs.)"),
                                    _buildTableRow("11 a 14 anos", "Meningocócica ACWY", "Uma dose"),
                                  ],
                                  if (activeAgeGroup == "adultos") ...[
                                    _buildTableRow("Adultos (qualquer idade)", "Hepatite B", "3 doses (conforme histórico)"),
                                    _buildTableRow("Adultos (qualquer idade)", "Difteria e Tétano (dT)", "3 doses (conforme histórico) | Reforços"),
                                    _buildTableRow("Adultos (<60 anos)", "Febre Amarela", "Dose conforme histórico"),
                                    _buildTableRow("Adultos (>=60 anos)", "Febre Amarela", "Avaliar risco/benefício (se não vacinado/sem comprovante)"),
                                    _buildTableRow("Adultos (conforme orientação)", "HPV4", "Dose conforme orientação (vide obs.)"),
                                    _buildTableRow("Adultos (>=18 anos)", "dTpa", "1 dose | Reforços (vide obs. prof. saúde)"),
                                    _buildTableRow("20 a 29 anos", "Tríplice viral", "2 doses (verificar histórico)"),
                                    _buildTableRow("30 a 59 anos", "Tríplice viral", "1 dose (verificar histórico)"),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else { // activeTab == "campanhas"
                    return _buildContainerWithShadow(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Campanhas de Vacinação",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                          ),
                          const Text(
                            "Campanhas de vacinação em andamento",
                            style: TextStyle(fontSize: 16, color: Colors.blue),
                          ),
                          const SizedBox(height: 16),
                          _vaccinationController.isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : _vaccinationController.vaccinationList.isEmpty
                                  ? const Center(child: Text("Nenhuma campanha de vacinação encontrada."))
                                  : Expanded(
                                      child: ListView.builder(
                                        itemCount: _vaccinationController.vaccinationList.length,
                                        itemBuilder: (context, index) {
                                          final campaign = _vaccinationController.vaccinationList[index];
                                          return _buildCampaignCard(
                                            campaign.vacina,
                                            "${campaign.dataInicio} a ${campaign.dataFim}",
                                            campaign.descricao,
                                            campaign.status,
                                          );
                                        },
                                      ),
                                    ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(selectedIndex: 0),
    );
  }

  Widget _buildTabButton(String text, String tab) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          activeTab = tab;
        });
        if (tab == "campanhas" && _vaccinationController.vaccinationList.isEmpty) {
          _vaccinationController.loadVaccination();
        }
      },
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(activeTab == tab ? Colors.white : Colors.grey.shade100),
        foregroundColor: WidgetStateProperty.all(activeTab == tab ? Colors.blue.shade800 : Colors.grey.shade500),
      ),
      child: Text(text),
    );
  }

  Widget _buildAgeGroupButton(String text, String group) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          activeAgeGroup = group;
        });
      },
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(activeAgeGroup == group ? Colors.white : Colors.grey.shade100),
        foregroundColor: WidgetStateProperty.all(activeAgeGroup == group ? Colors.blue.shade800 : Colors.grey.shade500),
      ),
      child: Text(text),
    );
  }

  Widget _buildContainerWithShadow({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.shade300, spreadRadius: 1, blurRadius: 5)],
      ),
      child: child,
    );
  }

  TableRow _buildTableRow(String age, String vaccine, String doses, {bool isHeader = false}) {
    return TableRow(
      decoration: isHeader ? const BoxDecoration(color: Colors.blue) : null,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            age,
            style: TextStyle(
              fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
              color: isHeader ? Colors.white : Colors.black,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            vaccine,
            style: TextStyle(
              fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
              color: isHeader ? Colors.white : Colors.black,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            doses,
            style: TextStyle(
              fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
              color: isHeader ? Colors.white : Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCampaignCard(String title, String date, String target, String status) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            const SizedBox(height: 8),
            Text("Período: $date"),
            const SizedBox(height: 8),
            Text("Descrição: $target"),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: status == "Em andamento"
                    ? Colors.green.shade100
                    : status == "Finalizada"
                        ? Colors.red.shade100
                        : status == "EMBREVE"
                            ? Colors.orange.shade100
                            : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: status == "Em andamento"
                      ? Colors.green.shade800
                      : status == "Finalizada"
                          ? Colors.red.shade800
                          : status == "EMBREVE"
                              ? Colors.orange.shade800
                              : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}