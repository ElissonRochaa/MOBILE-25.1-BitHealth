import 'package:bithealth_front_end/core/url.dart';
import 'package:bithealth_front_end/model/campaigns_model.dart';
import 'package:dio/dio.dart';

class CampaignsService {
  final ApiClient _apiClient = ApiClient();
  Future<List<CampaignsModel>> fetchCampaigns() async {
    try {
      Response response = await _apiClient.get('/calendario-vacinacao/');
      return (response.data as List)
          .map((json) => CampaignsModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar campanhas: $e');
    }
  }
}