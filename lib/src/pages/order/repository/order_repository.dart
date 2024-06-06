import 'package:piu_vino/src/constants/endpoints.dart';
import 'package:piu_vino/src/models/cart_mordel.dart';
import 'package:piu_vino/src/pages/order/result/order_result.dart';
import 'package:piu_vino/src/services/http_manager.dart';

class OrderRepository {
  final HttpManager _httpManager = HttpManager();

  OrderResult handleOrdersOrError(Map<String, dynamic> result) {
    if (result['results'] != null) {
      final List<dynamic> results = result['results'];
      final List<Pedido> carrinho =
          results.map((item) => Pedido.fromJson(item)).toList();
      return OrderResult.success(carrinho);
    } else if (result['error'] != null) {
      return OrderResult.error(result['error']);
    } else {
      return OrderResult.error('Erro ao buscar lista de compras');
    }
  }

  Future<OrderResult> getAllOrders(
      {required int limit, required int skip, required String idUser}) async {
    final result = await _httpManager.restRequest(
      url: Endpoints.urlCarrinho,
      method: HttpMethods.requisicaoGet,
      queryParameters: {
        'order': 'updatedAt',
        "limit": limit,
        "skip": skip,
        "include": "produto",
        "where": {
          "pago": true,
          "cliente": {
            "__type": "Pointer",
            "className": "_User",
            "objectId": idUser
          }
        }
      },
    );
    return handleOrdersOrError(result);
  }
}
