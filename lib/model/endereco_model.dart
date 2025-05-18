// ignore_for_file: non_constant_identifier_names

class EnderecoUnidadeModel {
  final String enderecoUnidadeId;
  final String logradouro;
  final String numero;
  final String complemento;
  final String bairro;
  final String cidade;
  final String estado;
  final String latitude;
  final String longitude;
  final String cep;

  EnderecoUnidadeModel({
    required this.enderecoUnidadeId,
    required this.logradouro,
    required this.numero,
    required this.complemento,
    required this.bairro,
    required this.cidade,
    required this.estado,
    required this.latitude,
    required this.longitude,
    required this.cep,
  });

  factory EnderecoUnidadeModel.fromJson(Map<String, dynamic> json) {
    return EnderecoUnidadeModel(
      enderecoUnidadeId: json['enderecoUnidadeId'] ?? '',
      logradouro: json['logradouro'] ?? '',
      numero: json['numero'] ?? '',
      complemento: json['complemento'] ?? '',
      bairro: json['bairro'] ?? '',
      cidade: json['cidade'] ?? '',
      estado: json['estado'] ?? '',
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
      cep: json['cep'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enderecoUnidadeId': enderecoUnidadeId,
      'logradouro': logradouro,
      'numero': numero,
      'complemento': complemento,
      'bairro': bairro,
      'cidade': cidade,
      'estado': estado,
      'latitude': latitude,
      'longitude': longitude,
      'cep': cep,
    };
  }
}
