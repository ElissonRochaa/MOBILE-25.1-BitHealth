import 'package:dio/dio.dart';

class ApiClient {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:8080/api'));

  Future<Response> get(String endpoint) async {
    final fullUrl = _dio.options.baseUrl + endpoint;
    return await _dio.get(endpoint);
  }

  Future<Response> post(String endpoint, Map<String, dynamic> data) async {
    return await _dio.post(endpoint, data: data);
  }
}