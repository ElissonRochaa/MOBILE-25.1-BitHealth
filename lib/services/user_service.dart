import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dtos/user_dto.dart';

class UsuarioService {
  static const String baseUrl = 'http://localhost:8080/api';
  
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
    // ignore: avoid_print
    prefs.setString('token', token);
   }
  
  static Future<String?> obterToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
  static Future<bool> recuperarSenha(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/reset/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email}),
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

  static Future<bool> redefinirSenha(String token, String novaSenha) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/reset/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'token': token,
          'newPassword': novaSenha,
        }),
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
}