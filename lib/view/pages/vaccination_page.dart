import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bithealth_front_end/controller/campaigns_controller.dart';
import 'package:bithealth_front_end/controller/vaccination_controller.dart';
import 'package:bithealth_front_end/view/components/bottom_nav_bar.dart';
import '../components/app_bar.dart';
import 'package:bithealth_front_end/provider/theme_provider.dart';
import 'package:bithealth_front_end/theme/app_themes.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppThemes.lightTheme,
          darkTheme: AppThemes.darkTheme,
          themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: const VaccinationPage(),
        );
      },
    );
  }
}

class VaccinationPage extends StatefulWidget {
  const VaccinationPage({super.key});

  @override
  State<VaccinationPage> createState() => _VaccinationPageState();
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
    setState(() {});
  }

  void _onVaccinationControllerChange() {
    setState(() {});
  }

  List<dynamic> _getVaccinationsByAgeGroup(String ageGroup) {
    return _vaccinationController.vaccinationList.where((vaccination) {
      final faixaEtaria = vaccination.faixaEtaria.toLowerCase();
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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(title: "Vacinação"),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: theme.brightness == Brightness.light ? Colors.grey.shade300 : Colors.black45,
                    spreadRadius: 1,
                    blurRadius: 5,
                  )
                ],
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
              child: activeTab == "calendario" ? _buildCalendarTab() : _buildCampaignsTab(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(selectedIndex: 0),
    );
  }

  Widget _buildCalendarTab() {
    return _buildContainerWithShadow(
      child: Column(
        children: [
          const Text("Calendário Nacional de Vacinação",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
          const Text("Vacinas obrigatórias por faixa etária", style: TextStyle(fontSize: 16, color: Colors.blue)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
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
                            ..._getVaccinationsByAgeGroup(activeAgeGroup).map((v) {
                              return _buildTableRow(v.idade, v.vacina, v.doses);
                            }).toList(),
                          ],
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildCampaignsTab() {
    return _buildContainerWithShadow(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Campanhas de Vacinação",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
          const Text("Campanhas de vacinação em andamento", style: TextStyle(fontSize: 16, color: Colors.blue)),
          const SizedBox(height: 16),
          _campaignsController.isLoading
              ? const Center(child: CircularProgressIndicator())
              : _campaignsController.vaccinationList.isEmpty
                  ? const Center(child: Text("Nenhuma campanha de vacinação encontrada."))
                  : Expanded(
                      child: ListView.builder(
                        itemCount: _campaignsController.vaccinationList.length,
                        itemBuilder: (context, index) {
                          final c = _campaignsController.vaccinationList[index];
                          return _buildCampaignCard(c.vacina, "${c.dataInicio} a ${c.dataFim}", c.descricao, c.status);
                        },
                      ),
                    ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, String value) {
    final theme = Theme.of(context);
    final isSelected = activeTab == value;
    return ElevatedButton(
      onPressed: () {
        setState(() {
          activeTab = value;
        });
        if (value == "campanhas" && _campaignsController.vaccinationList.isEmpty) {
          _campaignsController.loadVaccination();
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? theme.colorScheme.primary : theme.colorScheme.surface,
        foregroundColor: isSelected ? Colors.white : theme.colorScheme.onSurface,
      ),
      child: Text(label),
    );
  }

  Widget _buildAgeGroupButton(String text, String group) {
    final isSelected = activeAgeGroup == group;
    return ElevatedButton(
      onPressed: () {
        setState(() {
          activeAgeGroup = group;
        });
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        backgroundColor: isSelected ? Colors.white : Colors.grey.shade100,
        foregroundColor: isSelected ? Colors.blue : Colors.grey.shade600,
        elevation: 1,
      ),
      child: Text(text, style: const TextStyle(fontSize: 12)),
    );
  }

  Widget _buildContainerWithShadow({required Widget child}) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.brightness == Brightness.light ? Colors.grey.shade300 : Colors.black45,
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: child,
    );
  }

  TableRow _buildTableRow(String age, String vaccine, String doses, {bool isHeader = false}) {
    final theme = Theme.of(context);
    return TableRow(
      decoration: isHeader ? BoxDecoration(color: theme.colorScheme.primary) : null,
      children: [
        _buildTableCell(age, isHeader),
        _buildTableCell(vaccine, isHeader),
        _buildTableCell(doses, isHeader),
      ],
    );
  }

  Widget _buildTableCell(String text, bool isHeader) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          color: isHeader ? Colors.white : theme.colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildCampaignCard(String title, String date, String desc, String status) {
    Color bgColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case "em andamento":
        bgColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
        break;
      case "finalizada":
        bgColor = Colors.red.shade100;
        textColor = Colors.red.shade800;
        break;
      case "embreve":
      case "em breve":
        bgColor = Colors.orange.shade100;
        textColor = Colors.orange.shade800;
        break;
      default:
        bgColor = Colors.grey.shade300;
        textColor = Colors.black;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
          const SizedBox(height: 8),
          Text("Período: $date"),
          const SizedBox(height: 8),
          Text("Descrição: $desc"),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(8)),
            child: Text(status, style: TextStyle(color: textColor)),
          ),
        ]),
      ),
    );
  }
}
