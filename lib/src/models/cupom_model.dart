class Cupom {
  late String objectId;
  late int valor;

  Cupom({
    required this.objectId,
    required this.valor,
  });

  Cupom.fromJson(Map<String, dynamic> json) {
    objectId = json['objectId'];
    valor = json['cupom'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['objectId'] = objectId;
    data['cupom'] = valor;
    return data;
  }
}
