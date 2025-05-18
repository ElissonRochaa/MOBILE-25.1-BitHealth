class MedicamentosModel {
  final String? tokenId;
  final String nome;
  final String descricao;
  final int quantidade;
  final String tipoMedicamento;
  final String? disponibilidade;  

  MedicamentosModel({
    this.tokenId,
    required this.nome,
    required this.descricao,
    required this.quantidade,
    required this.tipoMedicamento,
    this.disponibilidade,
  });

  factory MedicamentosModel.fromJson(Map<String, dynamic> json) {
    return MedicamentosModel(
      tokenId: json['user_token_id'],
      nome: json['nome'],
      descricao: json['descricao'],
      quantidade: json['quantidade'],
      tipoMedicamento: json['tipoMedicamento'],
      disponibilidade: json['disponibilidade'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_token_id': tokenId,
      'nome': nome,
      'descricao': descricao,
      'quantidade': quantidade,
      'tipoMedicamento': tipoMedicamento,
      'disponibilidade': disponibilidade,
    };
  }
}