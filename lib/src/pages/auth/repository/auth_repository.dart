import 'package:piu_vino/src/constants/endpoints.dart';
import 'package:piu_vino/src/models/user_model.dart';
import 'package:piu_vino/src/pages/auth/result/auth_result.dart';
import 'package:piu_vino/src/services/http_manager.dart';

class AuthRepository {
  final HttpManager _httpManager = HttpManager();

  AuthResult handleUserOrError(Map<dynamic, dynamic> result) {
    if (result['objectId'] != null) {
      final user = User.fromJson(result);
      return AuthResult.success(user);
    } else if (result['error'] != null) {
      return AuthResult.error(result['error']);
    } else {
      return AuthResult.error('Erro desconhecido');
    }
  }

  AuthResult sucessUpdateOrError(Map<String, dynamic> result) {
    if (result['updatedAt'] != null) {
      return AuthResult.success('Usuário atualizado');
    } else if (result['error'] != null) {
      return AuthResult.error(result['error']);
    } else {
      return AuthResult.error('Erro desconhecido');
    }
  }

  Future<AuthResult> signIn(
      {required String username, required String password}) async {
    final result = await _httpManager.restRequest(
      url: Endpoints.signin,
      method: HttpMethods.requisicaoPost,
      body: {
        'username': username,
        'password': password,
      },
    );

    return handleUserOrError(result);
  }

  Future<AuthResult> signUpUser({required User user}) async {
    final result = await _httpManager.restRequest(
        url: Endpoints.users,
        method: HttpMethods.requisicaoPost,
        body: user.toJson());
    return handleUserOrError(result);
  }

  Future<void> resetPassword({required String emailRest}) async {
    await _httpManager.restRequest(
      url: Endpoints.restPassword,
      method: HttpMethods.requisicaoPost,
      body: {"email": emailRest},
    );
  }

  Future<AuthResult> updateUser(
      {required String userId,
      required String userName,
      required String email,
      required String nomeCompleto,
      required String userToken}) async {
    final result = await _httpManager.restRequest(
        url: '${Endpoints.users}/$userId',
        method: HttpMethods.requisicaoPut,
        body: {
          "username": userName,
          "email": email,
          "nomeCompleto": nomeCompleto
        },
        headers: {});
    return sucessUpdateOrError(result);
  }

  Future<AuthResult> validateToken({required String token}) async {
    final result = await _httpManager.restRequest(
        url: Endpoints.sessionToken,
        method: HttpMethods.requisicaoGet,
        headers: {});
    return handleUserOrError(result);
  }
}
