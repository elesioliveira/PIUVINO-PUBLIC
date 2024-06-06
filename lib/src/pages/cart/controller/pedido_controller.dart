// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:piu_vino/src/config/custom_colors.dart';
import 'package:piu_vino/src/models/cart_mordel.dart';
import 'package:piu_vino/src/pages/cart/cart_result/cart_result.dart';
import 'package:piu_vino/src/pages/cart/repository/pedido_repository.dart';
import 'package:piu_vino/src/services/utils_services.dart';

class CartController with ChangeNotifier {
  final pedidoRepository = CartRepository();
  final utilsServices = UtilsSerices();
  final List<Pedido> _pedidos = [];
  Timer? _timer;
  bool _isLoading = false;
  bool _isLoadingAddCart = false;
  bool get isLoadingCart => _isLoadingAddCart;
  List<Pedido> get pedidos => _pedidos;
  bool get isLoading => _isLoading;
  bool _deleteProduto = false;

  resetCartController() {
    _pedidos.clear();
    notifyListeners();
  }

  setLoadingCart(bool value) {
    _isLoadingAddCart = value;
    notifyListeners();
  }

  setDeleteProduto(bool value) {
    _deleteProduto = value;
    notifyListeners();
  }

  setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> buscarPedido({required String idUser, bool? canLoad}) async {
    if (canLoad == true) {
      setLoading(true);
    }

    _pedidos.clear();
    CartResult result = await pedidoRepository.buscarPedido(queryParameters: {
      "include": "produto",
      "where": {
        "pago": false,
        "cliente": {
          "__type": "Pointer",
          "className": "_User",
          "objectId": idUser
        }
      }
    });
    result.when(success: (pedido) {
      _pedidos.addAll(pedido);
      notifyListeners();
    }, error: (mensagem) {
      utilsServices.showToast(message: mensagem, isError: true);
    });
    setLoading(false);
    notifyListeners();
  }

  Future<void> deletarProdutoDoPedido({required String idPedido}) async {
    setLoading(true);
    CartResult result =
        await pedidoRepository.deletarProdutoEmPedido(idPedido: idPedido);

    result.when(success: (mensagem) {
      utilsServices.showToast(
        message: mensagem,
      );
    }, error: (mensagem) {
      utilsServices.showToast(message: mensagem, isError: true);
    });
    setLoading(false);
    notifyListeners();
  }

  Future<void> addProductIntoCart(
      {required String idCliente,
      required String idProduto,
      required num quantidade,
      required num priceProduto}) async {
    setLoadingCart(true);
    CartResult result = await pedidoRepository.addNoCarrinho(
      idCliente: idCliente,
      idProduto: idProduto,
      quantidade: quantidade,
      priceProduto: priceProduto,
    );

    result.when(success: (mensagem) {
      utilsServices.showToast(message: mensagem);
    }, error: (mensagem) {
      utilsServices.showToast(message: mensagem, isError: true);
    });
    setLoadingCart(false);
    notifyListeners();
  }

  Future<void> attItemIntoCart(
      {required String idCart,
      required bool confirmado,
      required num quantidade}) async {
    CartResult result = await pedidoRepository.attItenIntoCart(
      idCart: idCart,
      confirmado: confirmado,
      quantidade: quantidade,
    );
    result.when(success: (mensagem) {
      utilsServices.showToast(message: mensagem);
    }, error: (mensagem) {
      utilsServices.showToast(message: mensagem, isError: true);
    });
    notifyListeners();
  }

  timerAttItemIntoCart(
      {required String idCart,
      required bool confirmado,
      required num quantidade}) async {
    // Cancela o timer existente para evitar múltiplas chamadas

    _timer?.cancel();
    // Configura um novo timer para executar a função após 2 segundos
    _timer = Timer(const Duration(seconds: 4), () {
      notifyListeners();

      attItemIntoCart(
          idCart: idCart, confirmado: confirmado, quantidade: quantidade);
    });
  }

  void showAlertDialog(
      {required BuildContext context,
      required String idCliente,
      required Listenable animation,
      required String idPedido}) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => AnimatedBuilder(
        animation: animation,
        builder: (context, _) {
          return CupertinoAlertDialog(
            title: const Text('Alerta'),
            content: const Text('Deseja excluír o item?'),
            actions: <CupertinoDialogAction>[
              CupertinoDialogAction(
                onPressed: _deleteProduto
                    ? null
                    : () {
                        Navigator.of(context).pop();
                      },
                child: Text(
                  'Não',
                  style: TextStyle(color: CustomColors.primaryColor),
                ),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                isDefaultAction: true,
                onPressed: _deleteProduto
                    ? null
                    : () async {
                        setDeleteProduto(true);
                        await deletarProdutoDoPedido(idPedido: idPedido);
                        _pedidos.clear();
                        buscarPedido(idUser: idCliente);
                        setDeleteProduto(false);
                        Navigator.of(context).pop();
                      },
                child: const Text('Sim'),
              ),
            ],
          );
        },
      ),
    );
  }

  double calcularPrecoFinal(List<Pedido> pedidos) {
    double precoFinal = 0.0;

    for (Pedido pedido in pedidos) {
      double precoItem = pedido.produto.preco.toDouble();
      int quantidade = pedido.quantidade;
      double subtotal = precoItem * quantidade;
      precoFinal += subtotal;
    }

    return precoFinal;
  }
}
