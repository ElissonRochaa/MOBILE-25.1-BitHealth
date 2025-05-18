
// ignore_for_file: non_constant_identifier_names

import 'endereco_model.dart';

class UnidadeSaudeModel {
  final String tokenId;
  final String nome;
  final String tipo;
  final String horarioInicioAtendimento;
  final String horarioFimAtendimento;
  final EnderecoUnidadeModel endereco;

  UnidadeSaudeModel({
    required this.tokenId,
    required this.nome,
    required this.tipo,
    required this.horarioInicioAtendimento,
    required this.horarioFimAtendimento,
    required this.endereco,
  });

  factory UnidadeSaudeModel.fromJson(Map<String, dynamic> json) {
    return UnidadeSaudeModel(
      tokenId: json['token_Id'] ?? '',
      nome: json['nome'] ?? '',
      tipo: json['tipo'] ?? '',
      horarioInicioAtendimento: json['horarioInicioAtendimento'] ?? '',
      horarioFimAtendimento: json['horarioFimAtendimento'] ?? '',
      endereco: EnderecoUnidadeModel.fromJson(json['endereco']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token_Id': tokenId,
      'nome': nome,
      'tipo': tipo,
      'horarioInicioAtendimento': horarioInicioAtendimento,
      'horarioFimAtendimento': horarioFimAtendimento,
      'endereco': endereco.toJson(),
    };
  }
}
