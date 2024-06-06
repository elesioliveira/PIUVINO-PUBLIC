import 'package:flutter/material.dart';
import 'package:piu_vino/src/models/cart_mordel.dart';
import 'package:piu_vino/src/pages/order/repository/order_repository.dart';
import 'package:piu_vino/src/pages/order/result/order_result.dart';
import 'package:piu_vino/src/services/utils_services.dart';

class OrderController with ChangeNotifier {
  final utilsServices = UtilsSerices();
  final orderRepository = OrderRepository();
  final List<Pedido> _order = [];
  int _ultimaRequisicao = 0;
  bool _isLoading = false;
  final int _limit = 10;
  int _skip = 0;

  List<Pedido> get order => _order;
  bool get isLoading => _isLoading;
  int get ultimaRequisicao => _ultimaRequisicao;
  bool get isLastPage {
    if (_ultimaRequisicao < _limit) return true;
    return _skip + _limit > _order.length;
  }

  void loadMoreProducts({required String idUser}) {
    _skip += 10;
    getAllOrders(canLoad: false, idUser: idUser);
  }

  setLoadingProduto(bool value) {
    _isLoading = value;
    notifyListeners();
    return;
  }

  Future<void> getAllOrders({
    required bool canLoad,
    required String idUser,
  }) async {
    if (canLoad == false) {
      OrderResult result = await orderRepository.getAllOrders(
        idUser: idUser,
        limit: _limit,
        skip: _skip,
      );
      result.when(success: (order) {
        _order.addAll(order);
        _ultimaRequisicao = _order.length;
        notifyListeners();
      }, error: (menssagem) {
        utilsServices.showToast(message: menssagem, isError: true);
      });
      notifyListeners();
      return;
    } else {
      _order.clear();
      setLoadingProduto(canLoad);
      OrderResult result = await orderRepository.getAllOrders(
        idUser: idUser,
        limit: _limit,
        skip: _skip,
      );
      result.when(success: (order) {
        _order.addAll(order);
        _ultimaRequisicao = _order.length;
        notifyListeners();
      }, error: (menssagem) {
        utilsServices.showToast(message: menssagem, isError: true);
      });
      notifyListeners();
    }
    setLoadingProduto(false);
    notifyListeners();
  }

  resetOrderController() {
    _order.clear();
    notifyListeners();
  }
}
