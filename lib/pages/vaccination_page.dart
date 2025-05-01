import '../components/bottom_nav_bar.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.blue),
          onPressed: () {},
        ),
        title: const Text(
          "Saúde Correntes",
          style: TextStyle(color: Colors.blue, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            // Título da página de vacinação
            Container(
              padding: const EdgeInsets.all(6),
              child: const Text(
                "Vacinação",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
            ),
            const SizedBox(height: 16),
            // Barra de abas para Calendário e Campanhas
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
            // Conteúdo da aba ativa
            if (activeTab == "calendario") ...[
              _buildContainerWithShadow(
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
                    // Botões para selecionar a faixa etária
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildAgeGroupButton("Crianças", "criancas"),
                        _buildAgeGroupButton("Adolescentes", "adolescentes"),
                        _buildAgeGroupButton("Adultos", "adultos"),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Cabeçalho da tabela e conteúdo
                    Table(
                      columnWidths: const {
                        0: FixedColumnWidth(100), // Para "Idade"
                        1: FixedColumnWidth(150), // Para "Vacina"
                        2: FixedColumnWidth(100), // Para "Doses"
                      },
                      border: TableBorder.all(color: Colors.grey.shade400, width: 1),
                      children: [
                        _buildTableRow("Idade", "Vacina", "Doses", isHeader: true),
                        if (activeAgeGroup == "criancas") ...[
                          _buildTableRow("Ao nascer", "BCG", "Dose única"),
                          _buildTableRow("Ao nascer", "Hepatite B", "1ª dose"),
                          _buildTableRow("2 meses", "Pentavalente", "1ª dose"),
                          _buildTableRow("2 meses", "Poliomielite", "1ª dose"),
                        ],
                        if (activeAgeGroup == "adolescentes") ...[
                          _buildTableRow("11 a 14 anos", "HPV", "2 doses"),
                          _buildTableRow("11 a 19 anos", "Hepatite B", "3 doses"),
                          _buildTableRow("11 a 19 anos", "Febre Amarela", "Dose única"),
                        ],
                        if (activeAgeGroup == "adultos") ...[
                          _buildTableRow("20 a 59 anos", "Hepatite B", "3 doses"),
                          _buildTableRow("20 a 59 anos", "Febre Amarela", "Dose única"),
                          _buildTableRow("20 a 59 anos", "Tríplice Viral", "2 doses"),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ] else ...[
              _buildContainerWithShadow(
                child: Column(
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
                    // Cartões de campanhas
                    _buildCampaignCard("Campanha de Vacinação contra a Gripe", "01/04/2023 a 31/05/2023", "Idosos, crianças, gestantes e profissionais de saúde", "Em andamento"),
                    _buildCampaignCard("Campanha de Multivacinação Infantil", "01/06/2023 a 30/06/2023", "Crianças e adolescentes de 0 a 15 anos", "Em breve"),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(selectedIndex: 0),
    );
  }

  // Função auxiliar para criar os botões da barra de abas (Calendário e Campanhas)
  Widget _buildTabButton(String text, String tab) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          activeTab = tab;
        });
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(activeTab == tab ? Colors.white : Colors.grey.shade100),
        foregroundColor: MaterialStateProperty.all(activeTab == tab ? Colors.blue.shade800 : Colors.grey.shade500),
      ),
      child: Text(text),
    );
  }

  // Função auxiliar para criar os botões de seleção da faixa etária
  Widget _buildAgeGroupButton(String text, String group) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          activeAgeGroup = group;
        });
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(activeAgeGroup == group ? Colors.white : Colors.grey.shade100),
        foregroundColor: MaterialStateProperty.all(activeAgeGroup == group ? Colors.blue.shade800 : Colors.grey.shade500),
      ),
      child: Text(text),
    );
  }

  // Função auxiliar para criar um container com bordas arredondadas e sombra
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

  // Função auxiliar para criar as linhas da tabela
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

  // Função auxiliar para criar o cartão de campanhas
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
            Text("Data: $date"),
            const SizedBox(height: 8),
              Text("Público-alvo: $target"),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: status == "Em andamento" ? Colors.green.shade100 : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(status, style: const TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}
