// ignore_for_file: non_constant_identifier_names

class VaccinationModel {
  final String vacina;
  final String idadeMinima;
  final String idadeMaxima;
  final String descricao;
  final String dataInicio;
  final String dataFim;
  final String status;

  VaccinationModel({
    required this.vacina,
    required this.idadeMinima,
    required this.idadeMaxima,
    required this.descricao,
    required this.dataInicio,
    required this.dataFim,
    required this.status,
  });
  factory VaccinationModel.fromJson(Map<String, dynamic> json) {
    return VaccinationModel(
      vacina: json['vacina'],
      idadeMinima: json['idadeMinima'],
      idadeMaxima: json['idadeMaxima'],
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