// ignore_for_file: prefer_final_fields

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:piu_vino/src/models/item_favorito.dart';
import 'package:piu_vino/src/pages/favoritos/repository/favorito_repository.dart';
import 'package:piu_vino/src/pages/favoritos/result/favorito_result.dart';
import 'package:piu_vino/src/services/utils_services.dart';

class FavoritoController with ChangeNotifier {
  final itemFavoritoRepository = FavoritoRepository();
  final utilsServices = UtilsSerices();
  Timer? _timer;
  List<Favorito> _favorito = [];
  List<Favorito> get favoritos => _favorito;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  resetFavorito() {
    _favorito.clear();
    notifyListeners();
  }

  setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  setListaItem() {
    _favorito.clear();
    notifyListeners();
  }

  favoritedForTime(
      {required bool value,
      required String userId,
      required String productId}) {
    // Cancela o timer existente para evitar múltiplas chamadas
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 3), () {
      notifyListeners();

      if (value == true) {
        addItemFavorito(userId: userId, produtoId: productId);
        buscarItemFavorito(userId: userId);
      } else {
        removeFavoritoPorProdutoId(productId);
      }
    });
  }

  removeFavoritoPorProdutoId(String productId) {
    // Encontra o índice do item na lista _favorito com o productId correspondente
    int indexToRemove = _favorito
        .indexWhere((favorito) => favorito.produtoId.objectId == productId);

    if (indexToRemove >= 0) {
      // Obtém o objectId do item que será removido
      String objectIdItem = _favorito[indexToRemove].objectId;

      removeItemFavorito(itemFavoritoId: objectIdItem);
    } else {
      // Caso o item com o productId não seja encontrado na lista
      utilsServices.showToast(
          message: 'Esse item não está na lista', isError: true);
    }
    notifyListeners();
  }

  Future<void> buscarItemFavorito({required String userId}) async {
    _favorito.clear();
    FavoritoResult result =
        await itemFavoritoRepository.buscarProdutoFavorito(userId: userId);
    result.when(success: (itemFavorito) {
      _favorito.addAll(itemFavorito);
      notifyListeners();
    }, error: (mensagem) {
      utilsServices.showToast(message: mensagem, isError: true);
    });
    notifyListeners();
  }

  bool isFavorito(String produtoId) {
    return _favorito
        .any((favorito) => favorito.produtoId.objectId == produtoId);
  }

  Future<void> addItemFavorito(
      {required String userId, required String produtoId}) async {
    setLoading(true);
    FavoritoResult result = await itemFavoritoRepository.addItemFavorito(
        userId: userId, produtoId: produtoId);

    result.when(success: (mensagem) {
      utilsServices.showToast(message: mensagem);
    }, error: (mensagem) {
      utilsServices.showToast(message: mensagem, isError: true);
    });
    setLoading(false);
    notifyListeners();
  }

  Future<void> removeItemFavorito({required String itemFavoritoId}) async {
    setLoading(true);
    _favorito.removeWhere((element) => element.objectId == itemFavoritoId);
    FavoritoResult result = await itemFavoritoRepository.deletItemFavorito(
        itemFavoritoId: itemFavoritoId);

    result.when(success: (mensagem) {
      utilsServices.showToast(message: mensagem);
    }, error: (mensagem) {
      utilsServices.showToast(message: mensagem, isError: true);
    });
    setLoading(false);
    notifyListeners();
  }
}
