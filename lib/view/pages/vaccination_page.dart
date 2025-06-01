import 'package:bithealth_front_end/controller/campaigns_controller.dart';
import 'package:bithealth_front_end/controller/vaccination_controller.dart';
import 'package:bithealth_front_end/view/components/bottom_nav_bar.dart';
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
  
  _VaccinationPageState createState() => _VaccinationPageState();
}

class _VaccinationPageState extends State<VaccinationPage> {
  String activeTab = "calendario";
  String activeAgeGroup = "criancas";

  final CampaignsController _campaignsController = CampaignsController();
  final VaccinationController _vaccinationController = VaccinationController();

  @override
  void initState() {
    super.initState();
    _campaignsController.addListener(_onCampaignsControllerChange);
    _vaccinationController.addListener(_onVaccinationControllerChange);
    
    _vaccinationController.loadVaccination();
  }

  @override
  void dispose() {
    _campaignsController.removeListener(_onCampaignsControllerChange);
    _campaignsController.dispose();
    _vaccinationController.removeListener(_onVaccinationControllerChange);
    _vaccinationController.dispose();
    super.dispose();
  }

  void _onCampaignsControllerChange() {
    setState(() {
      print('DEBUG: _onCampaignsControllerChange chamado. Lista de vacinas (tamanho): ${_campaignsController.vaccinationList.length}');
      if (_campaignsController.vaccinationList.isNotEmpty) {
        print('DEBUG: Primeira vacina na lista: ${_campaignsController.vaccinationList.first.vacina}');
      }
    });
  }

  void _onVaccinationControllerChange() {
    setState(() {
      print('DEBUG: _onVaccinationControllerChange chamado. Lista de vacinas do calendário (tamanho): ${_vaccinationController.vaccinationList.length}');
      if (_vaccinationController.vaccinationList.isNotEmpty) {
        print('DEBUG: Primeira vacina do calendário: ${_vaccinationController.vaccinationList.first.vacina} - Faixa Etária: ${_vaccinationController.vaccinationList.first.faixaEtaria}');
      }
    });
  }

  List<dynamic> _getVaccinationsByAgeGroup(String ageGroup) {
    return _vaccinationController.vaccinationList.where((vaccination) {
      
      String faixaEtaria = vaccination.faixaEtaria.toLowerCase();
      
      switch (ageGroup) {
        case "criancas":
          return faixaEtaria.contains("criança") || faixaEtaria.contains("crianca");
        case "adolescentes":
          return faixaEtaria.contains("adolescente");
        case "adultos":
          return faixaEtaria.contains("adulto");
        case "gestantes":
          return faixaEtaria.contains("gestante");
        default:
          return false;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: const CustomAppBar(title: "Vacinação"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 16),
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
                              _buildAgeGroupButton("Gestantes", "gestantes"),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: _vaccinationController.isLoading
                                ? const Center(child: CircularProgressIndicator())
                                : _vaccinationController.vaccinationList.isEmpty
                                    ? const Center(child: Text("Nenhuma informação de vacinação encontrada."))
                                    : SingleChildScrollView(
                                        child: Table(
                                          columnWidths: const {
                                            0: FixedColumnWidth(100),
                                            1: FixedColumnWidth(150),
                                            2: FixedColumnWidth(100),
                                          },
                                          border: TableBorder.all(color: Colors.grey.shade400, width: 1),
                                          children: [
                                            _buildTableRow("Idade", "Vacina", "Doses", isHeader: true),
                                            ..._getVaccinationsByAgeGroup(activeAgeGroup).map((vaccination) {
                                              return _buildTableRow(
                                                vaccination.idade,
                                                vaccination.vacina,
                                                vaccination.doses,
                                              );
                                            }).toList(),
                                          ],
                                        ),
                                      ),
                          ),
                        ],
                      ),
                    );
                  } else {
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
                          _campaignsController.isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : _campaignsController.vaccinationList.isEmpty
                                  ? const Center(child: Text("Nenhuma campanha de vacinação encontrada."))
                                  : Expanded(
                                      child: ListView.builder(
                                        itemCount: _campaignsController.vaccinationList.length,
                                        itemBuilder: (context, index) {
                                          final campaign = _campaignsController.vaccinationList[index];
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
        if (tab == "campanhas" && _campaignsController.vaccinationList.isEmpty) {
          _campaignsController.loadVaccination();
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
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              activeAgeGroup = group;
            });
          },
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(activeAgeGroup == group ? Colors.white : Colors.grey.shade100),
            foregroundColor: WidgetStateProperty.all(activeAgeGroup == group ? Colors.blue.shade800 : Colors.grey.shade500),
            padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 8, horizontal: 4)),
          ),
          child: Text(
            text,
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ),
      ),
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