// ignore_for_file: non_constant_identifier_names

class DoctorModel {
  final String nome;
  final String crm;
  final String especialidade;
  final String unidade_saude_name;
  final String data_plantao;
  final String horario_inicio;
  final String horario_fim;
  final String tipo;
  final String criado_em;

  DoctorModel({
    required this.nome,
    required this.crm,
    required this.especialidade,
    required this.unidade_saude_name,
    required this.data_plantao,
    required this.horario_inicio,
    required this.horario_fim,
    required this.tipo,
    required this.criado_em,
  });
  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      nome: json['nome'],
      crm: json['crm'],
      especialidade: json['especialidade'],
      unidade_saude_name: json['unidade_saude_name'],
      data_plantao: json['data_plantao'],
      horario_inicio: json['horario_inicio'],
      horario_fim: json['horario_fim'],
      tipo: json['tipo'],
      criado_em: json['criado_em'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'crm': crm,
      'especialidade': especialidade,
      'unidade_saude_name': unidade_saude_name,
      'data_plantao': data_plantao,
      'horario_inicio': horario_inicio,
      'horario_fim': horario_fim,
      'tipo': tipo,
      'criado_em': criado_em,
    };
  }
}