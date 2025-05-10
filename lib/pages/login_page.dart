
// ignore_for_file: unused_field

import 'dart:convert';

import 'package:bithealth_front_end/dtos/login_dto.dart';
import 'package:bithealth_front_end/services/user_service.dart';
import 'package:flutter/material.dart';
import '../components/bottom_nav_bar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  int _selectedIndex = 0;


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _navegarParaCadastro() {
    setState(() {
      _selectedIndex = 0;
    });
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/cadastro',
      (Route<dynamic> route) => false,
    );
  }

  void _navegarParaHome() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/home',
      (Route<dynamic> route) => false,
    );
  }

  Future<void> _loginUsuario() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final usuarioLogin = LoginDTO(email: _emailController.text,  senha: _passwordController.text);

      final resultado = await UsuarioService.login(usuarioLogin.email, usuarioLogin.senha);

      setState(() {
      _isLoading = false;
    });

    // ignore: unnecessary_type_check
    if (resultado is String) {
      Map<String, dynamic> map = jsonDecode(resultado);
      await UsuarioService.salvarToken(map["token"]);
    }

    if (!mounted) return;

    if (resultado.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login realizado com sucesso!')),
        );
        _navegarParaHome();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao realizar login. Tente novamente.')),
      );
    }

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro $e')),
    );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            const SizedBox(width: 10),
            Text(
              'Saúde Correntes',
              style: TextStyle(
                color: const Color(0xFF3366CC),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF3366CC),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Column(
                  children: [
                    Text(
                      'Portal de Saúde',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Acesse ou crie sua conta',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3366CC),
                        foregroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            bottomLeft: Radius.circular(8),
                          ),
                        ),
                      ),
                      child: const Text('Login'),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _navegarParaCadastro,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE3EAFF),
                        foregroundColor: Colors.black54,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                        ),
                      ),
                      child: const Text('Cadastro'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              const Text(
                'E-mail',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'seu@email.com',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              const Text(
                'Senha',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                obscureText: true,
              ),
              
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Esqueceu sua senha?',
                    style: TextStyle(
                      color: Color(0xFF3366CC),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              
              ElevatedButton(
                onPressed: _loginUsuario,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3366CC),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Entrar',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text('ou', style: TextStyle(color: Colors.grey)),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
              ),
              
              OutlinedButton(
                onPressed: _navegarParaHome,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF3366CC)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Continuar como Visitante',
                  style: TextStyle(
                    color: Color(0xFF3366CC),
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(selectedIndex: _selectedIndex),
    );
  }
}