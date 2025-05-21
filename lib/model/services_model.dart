// ignore_for_file: non_constant_identifier_names

class ServicesModel {
  final String nome;
  final String descricao;
  final String horarioInicio;
  final String horarioFim;

  ServicesModel({
    required this.nome,
    required this.descricao,
    required this.horarioInicio,
    required this.horarioFim,
  });
  factory ServicesModel.fromJson(Map<String, dynamic> json) {
    return ServicesModel(
      nome: json['nome'],
      descricao: json['descricao'],
      horarioInicio: json['horarioInicio'],
      horarioFim: json['horarioFim'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'descricao': descricao,
      'horarioInicio': horarioInicio,
      'horarioFim': horarioFim,
    };
  }
}