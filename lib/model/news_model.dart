// ignore_for_file: non_constant_identifier_names

class NewsModel {
  final String titulo;
  final String conteudo;
  final String dataPublicacao;

  NewsModel({
    required this.titulo,
    required this.conteudo,
    required this.dataPublicacao,
  });
  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      titulo: json['titulo'],
      conteudo: json['conteudo'],
      dataPublicacao: json['dataPublicacao'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'conteudo': conteudo,
      'data_publicacao': dataPublicacao,
    };
  }
}