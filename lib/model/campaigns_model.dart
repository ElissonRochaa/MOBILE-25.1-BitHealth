// ignore_for_file: non_constant_identifier_names

class CampaignsModel {
  final String vacina;
  final String idadeMinima;
  final String idadeMaxima;
  final String descricao;
  final String dataInicio;
  final String dataFim;
  final String status;

  CampaignsModel({
    required this.vacina,
    required this.idadeMinima,
    required this.idadeMaxima,
    required this.descricao,
    required this.dataInicio,
    required this.dataFim,
    required this.status,
  });
  factory CampaignsModel.fromJson(Map<String, dynamic> json) {
    return CampaignsModel(
      vacina: json['vacina'],
      idadeMinima: json['idadeMinima']?.toString() ?? '',
      idadeMaxima: json['idadeMaxima']?.toString() ?? '',
      descricao: json['descricao'],
      dataInicio: json['dataInicio'],
      dataFim: json['dataFim'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vacina': vacina,
      'idadeMinima': idadeMinima,
      'idadeMaxima': idadeMaxima,
      'descricao': descricao,
      'dataInicio': dataInicio,
      'dataFim': dataFim,
      'status': status,
    };
  }
}