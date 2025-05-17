import 'package:dio/dio.dart';
import '../model/medicamentos_model.dart';
import '../core/api_client.dart';

class MedicamentoService {
  final ApiClient _apiClient = ApiClient();

  Future<List<MedicamentosModel>> fetchMedicamentos() async {
    try {
      Response response = await _apiClient.get('receitas');
      return (response.data as List).map((json) => MedicamentosModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('1Erro ao buscar receitas');
    }
  }
}
