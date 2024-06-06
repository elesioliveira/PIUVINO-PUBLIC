class Categoria {
  String objectId;
  String nomeCategoria;

  Categoria({
    required this.objectId,
    required this.nomeCategoria,
  });

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      objectId: json['objectId'],
      nomeCategoria: json['nomeCategoria'],
    );
  }
  @override
  String toString() {
    return 'id: $objectId, nomeCategoria: $nomeCategoria ';
  }
}
