// ignore_for_file: public_member_api_docs, sort_constructors_first
class User {
  final String? objectId;
  String? username;
  final String? senha;
  String? email;
  String? nomeCompleto;
  String? sessionToken;

  User(
      {this.objectId,
      this.username,
      this.email,
      this.nomeCompleto,
      this.sessionToken,
      this.senha});

  factory User.fromJson(Map<dynamic, dynamic> json) {
    return User(
      objectId: json['objectId'] as String?,
      username: json['username'] as String?,
      email: json['email'] as String?,
      nomeCompleto: json['nomeCompleto'] as String?,
      sessionToken: json['sessionToken'] as String?,
    );
  }

  Map<dynamic, dynamic> toJson() {
    return {
      "username": username,
      "password": senha,
      "nomeCompleto": nomeCompleto,
      "email": email,
    };
  }

  @override
  String toString() {
    return 'UserModel(name: $nomeCompleto, email: $email, username: $username,  password: $senha, token: $sessionToken, id: $objectId)';
  }
}
