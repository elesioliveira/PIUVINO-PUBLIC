class Frete {
  late String objectId;
  late String cidade;
  late int preco;

  Frete({
    required this.objectId,
    required this.cidade,
    required this.preco,
  });

  Frete.fromJson(Map<String, dynamic> json) {
    objectId = json['objectId'];
    cidade = json['cidade'];
    preco = json['preco'];
  }
}
