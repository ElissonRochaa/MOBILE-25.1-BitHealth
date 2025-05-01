import 'dart:convert';
import 'package:bithealth_front_end/utils/url.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../dtos/user_dto.dart';

class UsuarioService {
  static const String baseUrl = url;
  
  static Future<bool> cadastrarUsuario(Usuario usuario) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/registro'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(usuario.toJson()),
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
  
  static Future<String> login(String email, String senha) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'senha': senha}),
    );
    
    if (response.statusCode == 200) {
       return response.body;
    } else {
      throw Exception('Falha no login: ${response.body}');
    }
  }
  
  static Future<void> salvarToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
   }
  
  static Future<String?> obterToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}