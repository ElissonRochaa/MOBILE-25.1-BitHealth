import 'package:flutter/material.dart';
import '../components/bottom_nav_bar.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final TextEditingController _notificationController = TextEditingController();
  String? _notificationCategory = 'Todas';
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
    String selectedCategory = _notificationCategory ?? 'Todas';

    setState(() {
      _filteredNotifications = _allNotifications.where((notification) {
        final matchesName = notification['title'].toLowerCase().contains(searchText);
        final matchesCategory = selectedCategory == 'Todas' || notification['category'] == selectedCategory;
        return matchesName && matchesCategory;
      }).toList();
    });
  }

  @override
  void dispose() {
    _notificationController.dispose();
    super.dispose();
  }

  Widget _buildNotificationSearchContainer() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.shade300, spreadRadius: 1, blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SizedBox(width: 8),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Buscar Notificações",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                    Text(
                      "Por título ou categoria",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              controller: _notificationController,
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                hintText: 'Título da notificação...',
                hintStyle: const TextStyle(fontSize: 14),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                prefixIconConstraints: const BoxConstraints(minWidth: 30, maxWidth: 30),
                prefixIcon: const Icon(Icons.search, color: Colors.blue, size: 20),
                suffixIcon: _notificationController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey, size: 18),
                        onPressed: () {
                          setState(() {
                            _notificationController.clear();
                            _applyFilters();
                          });
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                _applyFilters();
              },
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButton<String>(
              value: _notificationCategory,
              onChanged: (String? newValue) {
                setState(() {
                  _notificationCategory = newValue!;
                  _applyFilters();
                });
              },
              underline: const SizedBox(),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
              isExpanded: true,
              items: notificationCategories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(
                    category,
                    style: const TextStyle(fontSize: 14),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Notificações",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
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
            _buildNotificationSearchContainer(),
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
