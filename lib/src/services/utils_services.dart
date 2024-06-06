import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:piu_vino/src/config/custom_colors.dart';

class UtilsSerices with ChangeNotifier {
  bool isDarkMode = false;
  ThemeMode get themeMode => isDarkMode ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme(bool isOn) {
    isDarkMode = isOn;
    notifyListeners();
  }

  void showToast({
    required String message,
    bool isError = false,
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3,
      backgroundColor: isError ? Colors.red : CustomColors.segundaryColor,
      textColor: isError ? Colors.white : Colors.white,
      fontSize: 14,
    );
  }

  String priceToCurrency(double price) {
    NumberFormat numberFormat = NumberFormat.simpleCurrency(locale: 'pt_BR');

    return numberFormat.format(price);
  }

  final storage = const FlutterSecureStorage();

  // Salva dado localmente em segurança
  Future<void> saveLocalData(
      {required String key, required String data}) async {
    await storage.write(key: key, value: data);
  }

  // Recupera dado salvo localmente em segurança
  Future<String?> getLocalData({required String key}) async {
    return await storage.read(key: key);
  }

  // Remove dado salvo localmente
  Future<void> removeLocalData({required String key}) async {
    await storage.delete(key: key);
  }
}
