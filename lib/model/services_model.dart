// ignore_for_file: non_constant_identifier_names

class ServicesModel {
  final String nome;
  final String descricao;
  final String horarioInicio;
  final String horarioFim;
  final String nomeUnidade;

  ServicesModel({
    required this.nome,
    required this.descricao,
    required this.horarioInicio,
    required this.horarioFim,
    required this.nomeUnidade,
  });
  factory ServicesModel.fromJson(Map<String, dynamic> json) {
    return ServicesModel(
      nome: json['nome'],
      descricao: json['descricao'],
      horarioInicio: json['horarioInicio'],
      horarioFim: json['horarioFim'],
      nomeUnidade: json['nomeUnidade'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'descricao': descricao,
      'horarioInicio': horarioInicio,
      'horarioFim': horarioFim,
      'nomeUnidade': nomeUnidade,
    };
  }
}