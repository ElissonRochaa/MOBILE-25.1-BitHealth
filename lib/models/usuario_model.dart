class Usuario {
  final String nome;
  final String sobrenome;
  final String cpf;
  final String email;
  final String senha;
  final String tipoUsuario;
  final String numeroTelefone;
  final Endereco endereco;

  Usuario({
    required this.nome,
    required this.sobrenome,
    required this.cpf,
    required this.email,
    required this.senha,
    this.tipoUsuario = 'CIDADAO',
    required this.numeroTelefone,
    required this.endereco,
  });

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'sobrenome': sobrenome,
      'cpf': cpf,
      'email': email,
      'senha': senha,
      'tipoUsuario': tipoUsuario,
      'numeroTelefone': numeroTelefone,
      'endereco': endereco.toJson(),
    };
  }

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      nome: json['nome'],
      sobrenome: json['sobrenome'],
      cpf: json['cpf'],
      email: json['email'],
      senha: json['senha'],
      tipoUsuario: json['tipoUsuario'] ?? 'CIDADAO',
      numeroTelefone: json['numeroTelefone'],
      endereco: Endereco.fromJson(json['endereco']),
    );
  }
}

class Endereco {
  final String logradouro;
  final String numero;
  final String complemento;
  final String bairro;
  final String cidade;
  final String estado;
  final String cep;

  Endereco({
    required this.logradouro,
    required this.numero,
    required this.complemento,
    required this.bairro,
    required this.cidade,
    required this.estado,
    required this.cep,
  });

  Map<String, dynamic> toJson() {
    return {
      'logradouro': logradouro,
      'numero': numero,
      'complemento': complemento,
      'bairro': bairro,
      'cidade': cidade,
      'estado': estado,
      'cep': cep,
    };
  }

  factory Endereco.fromJson(Map<String, dynamic> json) {
    return Endereco(
      logradouro: json['logradouro'],
      numero: json['numero'],
      complemento: json['complemento'],
      bairro: json['bairro'],
      cidade: json['cidade'],
      estado: json['estado'],
      cep: json['cep'],
    );
  }
}