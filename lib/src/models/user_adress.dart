class AdressModel {
  final String? objectId;
  final Usuario? userId;
  final String cidade;
  final String bairro;
  final String logradouro;
  final String numero;
  final String cep;
  final String referencia;
  final String nomeCompleto;
  final String telefone;
  final String uf;
  final bool? adressPadrao;

  AdressModel({
    this.objectId,
    this.userId,
    required this.cidade,
    required this.bairro,
    required this.logradouro,
    required this.numero,
    required this.cep,
    required this.referencia,
    this.adressPadrao = false,
    required this.nomeCompleto,
    required this.telefone,
    required this.uf,
  });

  factory AdressModel.fromJson(Map<String, dynamic> json) {
    return AdressModel(
      objectId: json['objectId'],
      uf: json['uf'],
      nomeCompleto: json['nomeCompleto'],
      telefone: json['telefone'],
      adressPadrao: json['adressPadrao'] ?? false,
      userId: Usuario.fromJson(json['userId']),
      cidade: json['cidade'],
      bairro: json['bairro'],
      logradouro: json['logradouro'],
      numero: json['numero'],
      cep: json['cep'],
      referencia: json['referencia'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cep': cep,
      'bairro': bairro,
      'cidade': cidade,
      'numero': numero,
      'userId': userId?.toJson(),
      'logradouro': logradouro,
      'referencia': referencia,
    };
  }
}

class Usuario {
  final String objectId;
  final String className;

  Usuario({
    required this.objectId,
    required this.className,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(objectId: json['objectId'], className: json['className']);
  }

  Map<String, dynamic> toJson() {
    return {
      "__type": "Pointer",
      "className": "_User",
      "objectId": objectId,
    };
  }
}
