// ignore_for_file: non_constant_identifier_names

class VaccinationModel {
  final String vacina;
  final String idade;
  final String doses;
  final String doencasEvitadas;
  final String faixaEtaria;

  VaccinationModel({
    required this.vacina,
    required this.idade,
    required this.doses,
    required this.doencasEvitadas,
    required this.faixaEtaria,
  });
  factory VaccinationModel.fromJson(Map<String, dynamic> json) {
    return VaccinationModel(
      vacina: json['vacina'],
      idade: json['idade'],
      doses: json['doses'],
      doencasEvitadas: json['doencasEvitadas'],
      faixaEtaria: json['faixaEtaria'],

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vacina': vacina,
      'idade': idade,
      'doses': doses,
      'doencasEvitadas': doencasEvitadas,
      'faixaEtaria': faixaEtaria,
    };
  }
}