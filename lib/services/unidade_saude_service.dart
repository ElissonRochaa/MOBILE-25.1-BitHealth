import 'package:bithealth_front_end/core/url.dart';
import 'package:bithealth_front_end/model/unidade_saude_model.dart';
import 'package:dio/dio.dart';

class UnidadeSaudeService {
  final ApiClient _apiClient = ApiClient();

  Future<List<UnidadeSaudeModel>> fetchDoctors() async {
    try {
      Response response = await _apiClient.get('/unidades-saude/');
      return (response.data as List)
          .map((json) => UnidadeSaudeModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar unidades de saúde: $e');
    }
  }
}