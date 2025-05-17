import 'package:flutter/material.dart';
import '../components/bottom_nav_bar.dart';
import '../../services/dtos/user_dto.dart';
import '../../services/user_service.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _sobrenomeController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _numeroTelefoneController = TextEditingController();
  
  final TextEditingController _logradouroController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();
  final TextEditingController _complementoController = TextEditingController();
  final TextEditingController _bairroController = TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();
  final TextEditingController _estadoController = TextEditingController();
  final TextEditingController _cepController = TextEditingController();
  
  final int _selectedIndex = 0;
  bool _mostrarEnderecoDetalhes = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nomeController.dispose();
    _sobrenomeController.dispose();
    _cpfController.dispose();
    _numeroTelefoneController.dispose();
    _logradouroController.dispose();
    _numeroController.dispose();
    _complementoController.dispose();
    _bairroController.dispose();
    _cidadeController.dispose();
    _estadoController.dispose();
    _cepController.dispose();
    super.dispose();
  }

  void _navegarParaLogin() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/login',
      (Route<dynamic> route) => false,
    );
  }

  void _navegarParaHome() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/home',
      (Route<dynamic> route) => false,
    );
  }

  void _toggleEnderecoDetalhes() {
    setState(() {
      _mostrarEnderecoDetalhes = !_mostrarEnderecoDetalhes;
    });
  }

  Future<void> _cadastrarUsuario() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final endereco = Endereco(
        logradouro: _logradouroController.text,
        numero: _numeroController.text,
        complemento: _complementoController.text,
        bairro: _bairroController.text,
        cidade: _cidadeController.text,
        estado: _estadoController.text,
        cep: _cepController.text,
      );

      final usuario = Usuario(
        nome: _nomeController.text,
        sobrenome: _sobrenomeController.text,
        cpf: _cpfController.text,
        email: _emailController.text,
        senha: _passwordController.text,
        numeroTelefone: _numeroTelefoneController.text,
        endereco: endereco,
      );

      final resultado = await UsuarioService.cadastrarUsuario(usuario);
      
      setState(() {
        _isLoading = false;
      });

      if (!mounted) return;

      if (resultado) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cadastro realizado com sucesso!')),
        );
        _navegarParaLogin();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao realizar cadastro. Tente novamente.')),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $e')),
      );
    }
  }

  Widget _buildTextField(
    String label, 
    TextEditingController controller, 
    {TextInputType keyboardType = TextInputType.text, 
    bool obscureText = false}
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.grey[100],
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          keyboardType: keyboardType,
          obscureText: obscureText,
        ),
        const SizedBox(height: 16),
      ],
    );
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF3366CC)))
          : SingleChildScrollView(
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
                            onPressed: _navegarParaLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE3EAFF),
                              foregroundColor: Colors.black54,
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
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3366CC),
                              foregroundColor: Colors.white,
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
                    const SizedBox(height: 24),

                    const Text(
                      'Dados Pessoais',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF3366CC)),
                    ),
                    const SizedBox(height: 16),
                    
                    _buildTextField('Nome', _nomeController),
                    _buildTextField('Sobrenome', _sobrenomeController),
                    _buildTextField('CPF', _cpfController, keyboardType: TextInputType.number),
                    _buildTextField('Email', _emailController, keyboardType: TextInputType.emailAddress),
                    _buildTextField('Senha', _passwordController, obscureText: true),
                    _buildTextField('Telefone', _numeroTelefoneController, keyboardType: TextInputType.phone),
                    
                    InkWell(
                      onTap: _toggleEnderecoDetalhes,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE3EAFF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Endereço',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF3366CC)),
                            ),
                            Icon(
                              _mostrarEnderecoDetalhes ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                              color: const Color(0xFF3366CC),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    if (_mostrarEnderecoDetalhes) ...[
                      _buildTextField('CEP', _cepController, keyboardType: TextInputType.number),
                      _buildTextField('Logradouro', _logradouroController),
                      _buildTextField('Número', _numeroController, keyboardType: TextInputType.number),
                      _buildTextField('Complemento', _complementoController),
                      _buildTextField('Bairro', _bairroController),
                      _buildTextField('Cidade', _cidadeController),
                      _buildTextField('Estado', _estadoController),
                    ],
                    
                    const SizedBox(height: 16),
                    
                    ElevatedButton(
                      onPressed: _cadastrarUsuario,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3366CC),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Cadastrar',
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