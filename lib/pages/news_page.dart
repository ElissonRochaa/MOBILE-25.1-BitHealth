import 'package:flutter/material.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Saúde Correntes"),
          centerTitle: false,
          backgroundColor: Colors.white,
          foregroundColor: Colors.blue.shade800,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {},
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Notícias",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: DengueAlert(),
            ),
            const SizedBox(height: 12),
            const TabBar(
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.blue,
              tabs: [
                Tab(text: "Todas"),
                Tab(text: "Campanhas"),
                Tab(text: "Serviços"),
                Tab(text: "Atualizações"),
              ],
            ),
            const Expanded(
              child: TabBarView(
                children: [
                  NewsList(),
                  Center(child: Text("Campanhas")),
                  Center(child: Text("Serviços")),
                  Center(child: Text("Atualizações")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DengueAlert extends StatelessWidget {
  const DengueAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red.shade300),
        borderRadius: BorderRadius.circular(8),
        color: Colors.red.shade50,
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.red),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: "Alerta de Dengue\n",
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                    fontSize: 16),
                children: const [
                  TextSpan(
                    text:
                    "Aumento de casos de dengue na região. Elimine possíveis criadouros do mosquito em sua residência.",
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.red,
                        fontSize: 14),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NewsList extends StatelessWidget {
  const NewsList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        NewsCard(
          title: "Campanha de Vacinação contra a Gripe começa na próxima semana",
          date: "25/03/2023",
          content:
          "A Secretaria de Saúde inicia na próxima segunda-feira (01/04) a Campanha de Vacinação contra a Gripe. A vacinação é destinada a idosos, crianças, gestantes e...",
        ),
        SizedBox(height: 16),
        NewsCard(
          title: "Novo serviço de telemedicina disponível para a população",
          date: "20/03/2023",
          content:
          "A partir do próximo mês, a Secretaria de Saúde disponibilizará um novo serviço de telemedicina para a população. O serviço permitirá consultas médicas...",
        ),
      ],
    );
  }
}

class NewsCard extends StatelessWidget {
  final String title;
  final String date;
  final String content;

  const NewsCard({
    super.key,
    required this.title,
    required this.date,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: Colors.grey.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(date, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            Text(content,
                style: const TextStyle(color: Colors.black87, fontSize: 14)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Text("Ler mais"),
                ),
                IconButton(
                  icon: const Icon(Icons.share_outlined, color: Colors.blue),
                  onPressed: () {},
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
