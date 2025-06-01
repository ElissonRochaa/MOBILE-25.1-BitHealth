import 'package:bithealth_front_end/model/news_model.dart';
import 'package:bithealth_front_end/services/news_service.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../components/bottom_nav_bar.dart';
import '../components/app_bar.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final NewsService _newsService = NewsService();
  List<NewsModel> _newsList = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  Future<void> _loadNews() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final fetchedNews = await _newsService.fetchNews();
      if (!mounted) return;
      setState(() {
        _newsList = fetchedNews;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = "Falha ao carregar notícias: ${e.toString()}";
        _isLoading = false;
        _newsList = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: const CustomAppBar(title: "Saúde Correntes"),
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
          // A TabBar foi removida daqui.
          Expanded(

            child: _buildNewsListContent(),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(selectedIndex: 0),
    );
  }

  Widget _buildNewsListContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            _errorMessage!,
            style: const TextStyle(color: Colors.red, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (_newsList.isEmpty) {
      return const Center(
        child: Text(
          "Nenhuma notícia encontrada no momento.",
          style: TextStyle(fontSize: 16, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _newsList.length,
      itemBuilder: (context, index) {
        final newsItem = _newsList[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: NewsCard(
            newsItem: newsItem,
          ),
        );
      },
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

class NewsCard extends StatelessWidget {
  final NewsModel newsItem;

  const NewsCard({
    super.key,
    required this.newsItem,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              newsItem.titulo,
              style: TextStyle(
                fontSize: 16,
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              newsItem.dataPublicacao,
              style: TextStyle(color: colorScheme.onSurface.withOpacity(0.6)),
            ),
            const SizedBox(height: 8),
            Text(
              newsItem.conteudo,
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 14,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            NewsDetailPage(newsItem: newsItem),
                      ),
                    );
                  },
                  child: Text(
                    "Ler mais",
                    style: TextStyle(color: colorScheme.primary),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.share_outlined, color: colorScheme.primary),
                  onPressed: () {
                    final String shareText =
                        '${newsItem.titulo}\n\n${newsItem.conteudo.substring(0, newsItem.conteudo.length > 150 ? 150 : newsItem.conteudo.length)}...';

                    Share.share(shareText);
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}


// Nova página para exibir os detalhes da notícia
class NewsDetailPage extends StatelessWidget {
  final NewsModel newsItem;

  const NewsDetailPage({super.key, required this.newsItem});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          newsItem.titulo,
          style: TextStyle(
            color: colorScheme.onPrimary,
            fontSize: 18,
          ),
        ),
        backgroundColor: colorScheme.primary,
        iconTheme: IconThemeData(color: colorScheme.onPrimary),
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              newsItem.titulo,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              newsItem.dataPublicacao,
              style: TextStyle(
                color: colorScheme.onBackground.withOpacity(0.6),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              newsItem.conteudo,
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: colorScheme.onBackground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
