import 'package:bithealth_front_end/core/url.dart';
import 'package:bithealth_front_end/model/services_model.dart';
import 'package:dio/dio.dart';

class ServicesService {
  final ApiClient _apiClient = ApiClient();
  Future<List<ServicesModel>> fetchServices() async {
    try {
      Response response = await _apiClient.get('/servicos-saude/');
      return (response.data as List)
          .map((json) => ServicesModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar notícias: $e');
    }
  }
}