// ignore_for_file: public_member_api_docs, sort_constructors_first
class Produto {
  String objectId;
  num preco;
  String nome;
  Category categoria;
  num quantidade;
  bool favorito;

  Produto({
    required this.objectId,
    required this.preco,
    required this.nome,
    required this.categoria,
    this.quantidade = 0,
    this.favorito = false,
  });

  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      objectId: json['objectId'],
      preco: json['preco'],
      nome: json['nome'],
      categoria: Category.fromJson(
        json['categoria'],
      ),
    );
  }
  @override
  String toString() {
    return 'id: $objectId, ';
  }
}

class Category {
  String objectId;
  String nomeCategoria;
  Category({
    required this.objectId,
    required this.nomeCategoria,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      objectId: json['objectId'],
      nomeCategoria: json['nomeCategoria'],
    );
  }
  // @override
  // String toString() {
  //   return 'id: $objectId, categoria: $nomeCategoria';
  // }
}
