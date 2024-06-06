import 'package:piu_vino/src/constants/endpoints.dart';
import 'package:piu_vino/src/models/cart_mordel.dart';
import 'package:piu_vino/src/pages/cart/cart_result/cart_result.dart';
import 'package:piu_vino/src/services/http_manager.dart';

class CartRepository {
  final HttpManager _httpManager = HttpManager();

  CartResult handleCartOrError(Map<String, dynamic> result) {
    if (result['results'] != null) {
      final List<dynamic> results = result['results'];
      final List<Pedido> carrinho =
          results.map((item) => Pedido.fromJson(item)).toList();
      return CartResult.success(carrinho);
    } else if (result['error'] != null) {
      return CartResult.error(result['error']);
    } else {
      return CartResult.error('Erro ao buscar lista de compras');
    }
  }

  CartResult sucessDeleteOrError(Map<String, dynamic> result) {
    if (result['data'] == null) {
      return CartResult.success('Produto excluído com sucesso');
    } else if (result['error'] != null) {
      return CartResult.error(result['error']);
    } else {
      return CartResult.error('Erro desconhecido');
    }
  }

  CartResult addCartOrError(Map<String, dynamic> result) {
    if (result['objectId'] != null) {
      return CartResult.success('Adicionado no carrinho');
    } else if (result['error'] != null) {
      return CartResult.error(result['error']);
    } else {
      return CartResult.error('Erro ao processar informação');
    }
  }

  CartResult attItensOrError(Map<String, dynamic> result) {
    if (result['updatedAt'] != null) {
      return CartResult.success('Sucesso');
    } else if (result['message'] != null) {
      return CartResult.error(result['message']);
    } else if (result['error'] != null) {
      return CartResult.error(result['error']);
    } else {
      return CartResult.error('Erro não identificado');
    }
  }

  Future<CartResult> buscarPedido(
      {Map<String, dynamic>? queryParameters}) async {
    final result = await _httpManager.restRequest(
        url: Endpoints.urlCarrinho,
        method: HttpMethods.requisicaoGet,
        queryParameters: queryParameters);
    return handleCartOrError(result);
  }

  Future<CartResult> deletarProdutoEmPedido({required String idPedido}) async {
    final result = await _httpManager.restRequest(
        url: '${Endpoints.deletarProdutoNoPedido}$idPedido',
        method: HttpMethods.requisicaoDelete);
    return sucessDeleteOrError(result);
  }

  Future<CartResult> addNoCarrinho(
      {required String idCliente,
      required String idProduto,
      required num quantidade,
      required num priceProduto}) async {
    final result = await _httpManager.restRequest(
        url: Endpoints.urlCarrinho,
        method: HttpMethods.requisicaoPost,
        body: {
          "cliente": {
            "__type": "Pointer",
            "className": "_User",
            "objectId": idCliente
          },
          "produto": {
            "__type": "Pointer",
            "className": "Produto",
            "objectId": idProduto
          },
          "quantidade": quantidade,
          "price": priceProduto,
        });
    return addCartOrError(result);
  }

  Future<CartResult> attItenIntoCart(
      {required String idCart,
      required bool confirmado,
      required num quantidade}) async {
    final result = await _httpManager.restRequest(
      url: '${Endpoints.deletarProdutoNoPedido}$idCart',
      method: HttpMethods.requisicaoPut,
      body: {
        "pago": confirmado,
        "quantidade": quantidade,
      },
    );
    return attItensOrError(result);
  }
}
