import 'package:bithealth_front_end/controller/vaccination_controller.dart';
import 'package:bithealth_front_end/view/components/bottom_nav_bar.dart'; // Certifique-se que o caminho está correto
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

  // Instância do controller
  final VaccinationController _vaccinationController = VaccinationController();

  @override
  void initState() {
    super.initState();
    // Adiciona um listener para atualizar a UI quando os dados mudarem
    _vaccinationController.addListener(_onControllerChange);
    // Carrega as vacinações se a aba de campanhas for a ativa inicialmente
    // Removi a condição activeTab == "campanhas" para garantir o carregamento
    // sempre que a página for inicializada e você estiver na aba campanhas.
    // A chamada no _buildTabButton já trata a troca de abas.
    // No entanto, se você quiser que carregue imediatamente se a aba inicial for "campanhas",
    // pode manter a condição if (activeTab == "campanhas")
    // Mas, para fins de depuração, vamos garantir que ele tente carregar.
    if (activeTab == "campanhas") { // Mantenho a condição para evitar carga desnecessária
      _vaccinationController.loadVaccination();
    }
  }

  @override
  void dispose() {
    // Remove o listener para evitar vazamentos de memória
    _vaccinationController.removeListener(_onControllerChange);
    _vaccinationController.dispose(); // Descarta o controller
    super.dispose();
  }

  // Método para reagir às mudanças no controller e atualizar a UI
  void _onControllerChange() {
    setState(() {
      // O setState vazio já garante que a UI será reconstruída
      // com os novos valores do controller (isLoading, vaccinationList)
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
      appBar: AppBar(
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
              // Seção de Campanhas
              Expanded( // Adicionado Expanded para permitir que o ListView ocupe o espaço restante
                child: _buildContainerWithShadow(
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
                      // Indicador de carregamento ou lista de campanhas
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
                                        "${campaign.dataInicio} a ${campaign.dataFim}", // Combina datas
                                        campaign.descricao, // Usando descrição como público-alvo
                                        campaign.status,
                                      );
                                    },
                                  ),
                                ),
                    ],
                  ),
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
        // Carrega os dados APENAS se a aba for 'campanhas'
        // e se a lista de vacinação estiver vazia (evita recarregar desnecessariamente)
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

  // Função auxiliar para criar os botões de seleção da faixa etária
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
            Text("Período: $date"), // Alterado para "Período" para refletir as datas
            const SizedBox(height: 8),
            Text("Descrição: $target"), // Alterado para "Descrição"
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                // Ajusta a cor com base no status
                color: status == "Em andamento"
                    ? Colors.green.shade100
                    : status == "Finalizada"
                        ? Colors.red.shade100
                        : status == "EMBREVE" // Adiciona tratamento para EMBREVE
                            ? Colors.orange.shade100 // Cor para EMBREVE
                            : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                status,
                style: TextStyle(
                  // Ajusta a cor do texto com base no status
                  color: status == "Em andamento"
                      ? Colors.green.shade800
                      : status == "Finalizada"
                          ? Colors.red.shade800
                          : status == "EMBREVE" // Adiciona tratamento para EMBREVE
                              ? Colors.orange.shade800 // Cor do texto para EMBREVE
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