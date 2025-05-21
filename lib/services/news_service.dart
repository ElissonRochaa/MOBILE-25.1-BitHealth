import 'package:bithealth_front_end/core/url.dart';
import 'package:bithealth_front_end/model/news_model.dart';
import 'package:dio/dio.dart';

class NewsService {
  final ApiClient _apiClient = ApiClient();
  Future<List<NewsModel>> fetchNews() async {
    try {
      Response response = await _apiClient.get('/news/');
      return (response.data as List)
          .map((json) => NewsModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar notícias: $e');
    }
  }
}