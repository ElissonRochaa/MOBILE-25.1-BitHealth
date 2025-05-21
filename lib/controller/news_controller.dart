
import 'package:bithealth_front_end/model/news_model.dart';
import 'package:bithealth_front_end/services/news_service.dart';
import 'package:flutter/foundation.dart';

class NewsController extends ChangeNotifier {

  final NewsService _newsService = NewsService();
  List<NewsModel> newsList = [];
  bool isLoading = false;

  Future<void> loadNews() async {
    isLoading = true;
    notifyListeners();

    try {
      newsList = await _newsService.fetchNews();
    } catch (e) {
      newsList = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}