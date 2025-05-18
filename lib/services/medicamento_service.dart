import 'package:bithealth_front_end/core/url.dart';
import 'package:dio/dio.dart';
import '../model/medicamentos_model.dart';

class MedicamentoService {
  final ApiClient _apiClient = ApiClient();

  Future<List<MedicamentosModel>> fetchMedicamentos() async {
    try {
      Response response = await _apiClient.get('/medicamentos/');
      return (response.data as List).map((json) => MedicamentosModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Erro ao buscar medicamentos: $e');
    }
  }
}
