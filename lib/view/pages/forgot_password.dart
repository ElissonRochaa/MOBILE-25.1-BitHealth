import 'package:bithealth_front_end/services/user_service.dart';
import 'package:flutter/material.dart';
import '../components/bottom_nav_bar.dart';
import '../components/app_bar.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  int _selectedIndex = 0;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _navegarParaLogin() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/login',
      (Route<dynamic> route) => false,
    );
  }

  Future<void> _enviarEmailRecuperacao() async {
    if (_emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira seu e-mail.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final success = await UsuarioService.recuperarSenha(_emailController.text.trim());

      setState(() {
        _isLoading = false;
      });

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('E-mail de recuperação enviado com sucesso! Verifique sua caixa de entrada.'),
            backgroundColor: Colors.green,
          ),
        );
        _emailController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao enviar e-mail de recuperação. Verifique o e-mail informado.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Saúde Correntes"),
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
                    Icon(
                      Icons.lock_reset,
                      color: Colors.white,
                      size: 32,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Recuperar Senha',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Informe seu e-mail para receber as instruções',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

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
                  prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF3366CC)),
                ),
                keyboardType: TextInputType.emailAddress,
                enabled: !_isLoading,
              ),
              const SizedBox(height: 24),
              
              ElevatedButton(
                onPressed: _isLoading ? null : _enviarEmailRecuperacao,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3366CC),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Enviar E-mail de Recuperação',
                        style: TextStyle(fontSize: 16),
                      ),
              ),
              
              const SizedBox(height: 16),
              
              OutlinedButton(
                onPressed: _isLoading ? null : _navegarParaLogin,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF3366CC)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Voltar ao Login',
                  style: TextStyle(
                    color: Color(0xFF3366CC),
                    fontSize: 16,
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF3366CC).withOpacity(0.2)),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Color(0xFF3366CC),
                      size: 20,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Você receberá um e-mail com instruções para redefinir sua senha. Verifique também sua caixa de spam.',
                        style: TextStyle(
                          color: Color(0xFF3366CC),
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
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