String? emailValidator(String? email) {
  if (email == null || email.isEmpty) {
    return 'Digite seu email!';
  }
  if (email.length < 12 || email.length > 25) {
    return 'Digite um emaill correto!';
  }

  return null;
}

String? passwordValidator(String? password) {
  if (password == null || password.isEmpty) {
    return 'Digite sua senha!';
  }

  if (password.length < 7) {
    return 'Digite uma senha com pelos menos 7 caracteres.';
  }

  return null;
}

String? nameValidator(String? name) {
  if (name == null || name.isEmpty) {
    return 'Digite seu nome!';
  }

  final names = name.split(' ');

  if (names.length == 1) return 'Digite seu nome completo!';
  return null;
}

String? phoneValidator(String? phone) {
  if (phone == null || phone.isEmpty) {
    return 'Digite um celular!';
  }

  if (phone.length < 9) {
    return 'Digite um número válido!';
  }

  return null;
}

String? userValidator(String? name) {
  if (name == null || name.isEmpty) {
    return 'Digite seu usuário!';
  }

  return null;
}
