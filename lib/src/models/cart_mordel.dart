class Pedido {
  String objectId;
  Produto produto;
  int quantidade;
  bool pago;
  int price;

  Pedido({
    required this.objectId,
    required this.produto,
    required this.quantidade,
    required this.pago,
    required this.price,
  });

  factory Pedido.fromJson(Map<String, dynamic> json) {
    return Pedido(
      objectId: json['objectId'] ?? '',
      produto: Produto.fromJson(json['produto'] ?? {}),
      quantidade: json['quantidade'] ?? 0,
      pago: json['pago'] ?? false,
      price: json['price'],
    );
  }
  @override
  String toString() {
    return 'id: $objectId, produto: $produto, quantidade: $quantidade ';
  }
}

class Produto {
  String objectId;
  num preco;
  String nome;
  Categoria categoria;

  Produto({
    required this.objectId,
    required this.preco,
    required this.nome,
    required this.categoria,
  });

  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      objectId: json['objectId'] ?? '',
      preco: (json['preco'] ?? 0.0).toDouble(),
      nome: json['nome'] ?? '',
      categoria: Categoria.fromJson(json['categoria'] ?? {}),
    );
  }
}

class Categoria {
  String objectId;

  Categoria({required this.objectId});

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      objectId: json['objectId'] ?? '',
    );
  }
}
