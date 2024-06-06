class Favorito {
  late String objectId;
  late Product produtoId;
  late bool favorito;

  Favorito({
    required this.objectId,
    required this.produtoId,
    this.favorito = true,
  });

  Favorito.fromJson(Map<String, dynamic> json) {
    objectId = json['objectId'];
    favorito = json['favorito'] ?? true;
    produtoId = Product.fromJson(json['produtoId']);
  }
}

class Product {
  late String objectId;
  late num preco;
  late String nome;
  late Categoria categoria;
  late num quantidade;

  Product({
    required this.objectId,
    required this.preco,
    required this.nome,
    required this.categoria,
    required this.quantidade,
  });

  Product.fromJson(
    Map<String, dynamic> json,
  ) {
    objectId = json['objectId'];
    preco = json['preco'];
    nome = json['nome'];
    quantidade = 0;
    categoria = Categoria.fromJson(
      json['categoria'],
    );
  }
}

class Categoria {
  late String objectId;

  Categoria({
    required this.objectId,
  });

  Categoria.fromJson(Map<String, dynamic> json) {
    objectId = json['objectId'];
  }
}
