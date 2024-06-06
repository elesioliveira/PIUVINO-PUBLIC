const String baseUrl = 'https://parseapi.back4app.com';

abstract class Endpoints {
  static const String signin = '$baseUrl/login';
  static const String users = '$baseUrl/users';
  static const String restPassword = '$baseUrl/requestPasswordReset';
  static const String buscarProdutos = '$baseUrl/classes/Produto';
  static const String buscarCategorias = '$baseUrl/classes/Categoria';
  static const String urlCarrinho = '$baseUrl/classes/Carrinho';
  static const String deletarProdutoNoPedido = '$baseUrl/classes/Carrinho/';
  static const String buscarFavorito = '$baseUrl/classes/Produto_favorito';
  static const String buscarUserAdress = '$baseUrl/classes/User_adress';
  static const String buscarFrete = '$baseUrl/classes/Frete';
  static const String buscarCupom = '$baseUrl/classes/Cupom';
  static const String sessionToken = '$baseUrl/users/me';
  static const String userReport = '$baseUrl/classes/User_critical';
}
