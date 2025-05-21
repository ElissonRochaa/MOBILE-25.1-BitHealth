import 'package:bithealth_front_end/core/url.dart';
import 'package:bithealth_front_end/model/vaccination_model.dart';
import 'package:dio/dio.dart';

class VaccinationService {
  final ApiClient _apiClient = ApiClient();
  Future<List<VaccinationModel>> fetchVaccination() async {
    try {
      Response response = await _apiClient.get('/calendario-vacinacao/');
      return (response.data as List)
          .map((json) => VaccinationModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar notícias: $e');
    }
  }
}