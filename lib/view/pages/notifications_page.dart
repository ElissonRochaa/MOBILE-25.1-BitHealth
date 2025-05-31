import 'package:flutter/material.dart';
import '../components/bottom_nav_bar.dart';
import '../components/app_bar.dart';
import '../components/SearchFilterWidget.dart'; 

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final TextEditingController _notificationController = TextEditingController();
  String _notificationCategory = 'Todas';
  List<String> notificationCategories = ['Todas', 'Consulta', 'Vacina', 'Geral'];

  List<Map<String, dynamic>> _allNotifications = [
    {
      "title": "Campanha de Vacinação",
      "category": "Vacina",
      "date": "25/03/2023",
      "description": "A Campanha de Vacinação contra a Gripe começa na próxima semana. Não se esqueça de se vacinar!"
    },
    {
      "title": "Horário de Atendimento",
      "category": "Geral",
      "date": "20/03/2023",
      "description": "O horário de atendimento da UBS Centro será alterado a partir da próxima semana. Novo horário: 8h às 17h."
    },
    {
      "title": "Consulta Agendada",
      "category": "Consulta",
      "date": "15/03/2023",
      "description": "Você tem uma consulta agendada com Dr. João Silva (Cardiologia) no dia 05/04/2023 às 14h no Hospital Municipal."
    },
    {
      "title": "Vacina Pendente",
      "category": "Vacina",
      "date": "10/03/2023",
      "description": "Você tem uma vacina pendente. Não se esqueça de tomar!"
    },
  ];

  List<Map<String, dynamic>> _filteredNotifications = [];

  @override
  void initState() {
    super.initState();
    _filteredNotifications = List.from(_allNotifications);
    _notificationController.addListener(_applyFilters);
  }

  void _applyFilters() {
    String searchText = _notificationController.text.toLowerCase();
    String selectedCategory = _notificationCategory;

    setState(() {
      _filteredNotifications = _allNotifications.where((notification) {
        final matchesName = notification['title'].toLowerCase().contains(searchText);
        final matchesCategory = selectedCategory == 'Todas' || notification['category'] == selectedCategory;
        return matchesName && matchesCategory;
      }).toList();
    });
  }

  void _onSearchChanged(String value) {
    _applyFilters();
  }

  void _onOptionSelected(String option) {
    setState(() {
      _notificationCategory = option;
      _applyFilters();
    });
  }

  @override
  void dispose() {
    _notificationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Notificações"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            SearchFilterWidget(
              title: "Buscar Notificações",
              subtitle: "Por título ou categoria",
              searchHint: "Título da notificação...",
              options: notificationCategories,
              selectedOption: _notificationCategory,
              searchController: _notificationController,
              onSearchChanged: _onSearchChanged,
              onOptionSelected: _onOptionSelected,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: _filteredNotifications.isEmpty
                  ? const Center(child: Text("Nenhuma notificação encontrada."))
                  : ListView.builder(
                      itemCount: _filteredNotifications.length,
                      itemBuilder: (context, index) {
                        final notification = _filteredNotifications[index];
                        return NotificationCard(
                          title: notification['title'],
                          category: notification['category'],
                          date: notification['date'],
                          description: notification['description'],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(selectedIndex: 4),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final String title;
  final String category;
  final String date;
  final String description;

  const NotificationCard({
    super.key,
    required this.title,
    required this.category,
    required this.date,
    required this.description,
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
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 8),
            Chip(
              label: Text(category),
              backgroundColor: Colors.blue.shade100,
            ),
            const SizedBox(height: 8),
            Text("Data: $date"),
            const SizedBox(height: 8),
            Text(description),
          ],
        ),
      ),
    );
  }
}