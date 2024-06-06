import 'package:flutter/material.dart';
import 'package:piu_vino/src/models/user_model.dart';
import 'package:piu_vino/src/pages/auth/repository/auth_repository.dart';
import 'package:piu_vino/src/pages/auth/result/auth_result.dart';
import 'package:piu_vino/src/pages/auth/view/sign_in__screen.dart';
import 'package:piu_vino/src/pages/home/view/home_screen.dart';
import 'package:piu_vino/src/services/utils_services.dart';

class AuthController with ChangeNotifier {
  final authRepository = AuthRepository();
  final utilsServices = UtilsSerices();
  User user = User();

  late String tokenAcess;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  resetUser() {
    user = User();
    notifyListeners();
  }

  Future<void> validateToken(BuildContext context) async {
    String? token = await utilsServices.getLocalData(key: 'sessionToken');

    if (token == null) {
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(
          builder: (context) => const SignInScreen(),
        ),
      );
      return;
    }

    AuthResult result =
        await authRepository.validateToken(token: user.sessionToken!);

    result.when(
      success: (user) {
        this.user = user;

        saveTokenAndProceedToBase(context);
      },
      error: (message) {
        signOut(context);
      },
    );
  }

  void saveTokenAndProceedToBase(BuildContext context) {
    // Salvar o token
    utilsServices.saveLocalData(key: 'sessionToken', data: user.sessionToken!);

    // Ir para a base
    Navigator.pushReplacement(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    );
  }

  Future<void> signOut(BuildContext context) async {
    // Zerar o user
    user = User();

    // Remover o token localmente
    await utilsServices.removeLocalData(key: 'sessionToken');

    // Ir para o login
    Navigator.pushReplacement(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(
        builder: (context) => const SignInScreen(),
      ),
    );
  }

  set setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  loadingUser(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> signIn(
      {required String userName,
      required String password,
      required BuildContext context}) async {
    loadingUser(true);
    AuthResult result =
        await authRepository.signIn(username: userName, password: password);
    result.when(
      success: (user) {
        this.user = user;
      },
      error: (message) {
        utilsServices.showToast(
          message: message,
          isError: true,
        );
      },
    );

    loadingUser(false);
    notifyListeners();
  }

  Future<void> signUpUser(
      {required User user, required BuildContext context}) async {
    loadingUser(true);
    AuthResult result = await authRepository.signUpUser(user: user);
    result.when(
      success: (user) {
        this.user = user;
        utilsServices.showToast(message: 'Cadastro realizado com sucesso');
        Navigator.pop(context);
      },
      error: (message) {
        utilsServices.showToast(
          message: message,
          isError: true,
        );
      },
    );
    loadingUser(false);
    notifyListeners();
  }

  Future<void> resetPassword({required String emailRest}) async {
    loadingUser(true);
    await authRepository.resetPassword(emailRest: emailRest);
    loadingUser(false);
    utilsServices.showToast(message: 'Email enviado');
    notifyListeners();
  }

  Future<void> updateUser(
      {required String userName,
      required String email,
      required String nomeCompleto}) async {
    loadingUser(true);
    AuthResult result = await authRepository.updateUser(
        userToken: user.sessionToken.toString(),
        userId: user.objectId!,
        userName: userName,
        email: email,
        nomeCompleto: nomeCompleto);
    result.when(success: (mensagem) {
      user.username = userName;
      user.email = email;
      user.nomeCompleto = nomeCompleto;
      utilsServices.showToast(message: mensagem);
      notifyListeners();
    }, error: (mensagem) {
      utilsServices.showToast(message: mensagem, isError: true);
    });

    loadingUser(false);
  }
}
