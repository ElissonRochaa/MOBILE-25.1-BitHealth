import 'package:bithealth_front_end/core/url.dart';
import 'package:bithealth_front_end/model/doctor_model.dart';
import 'package:dio/dio.dart';

class DoctorService {
  final ApiClient _apiClient = ApiClient();
  Future<List<DoctorModel>> fetchDoctors() async {
    try {
      Response response = await _apiClient.get('/doctors/');
      return (response.data as List)
          .map((json) => DoctorModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar médicos: $e');
    }
  }
}