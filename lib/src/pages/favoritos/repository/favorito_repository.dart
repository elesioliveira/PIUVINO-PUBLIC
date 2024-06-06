import 'package:piu_vino/src/constants/endpoints.dart';
import 'package:piu_vino/src/models/item_favorito.dart';

import 'package:piu_vino/src/pages/favoritos/result/favorito_result.dart';
import 'package:piu_vino/src/services/http_manager.dart';

class FavoritoRepository {
  final HttpManager _httpManager = HttpManager();

  FavoritoResult handleFavoritoOrError(Map<String, dynamic> result) {
    if (result['results'] != null) {
      final List<dynamic> results = result['results'];
      final List<Favorito> produtos = results
          .map(
              (dynamic item) => Favorito.fromJson(item as Map<String, dynamic>))
          .toList();
      return FavoritoResult.success(produtos);
    } else if (result['error'] != null) {
      return FavoritoResult.error(result['error']);
    } else {
      return FavoritoResult.error('Erro ao processar a informação');
    }
  }

  FavoritoResult sucessDeleteOrError(Map<String, dynamic> result) {
    if (result['objectId'] != null) {
      return FavoritoResult.success('Ok');
    } else if (result['error'] != null) {
      return FavoritoResult.error(result['error']);
    } else {
      return FavoritoResult.success('Removido!');
    }
  }

  FavoritoResult sucessAddOrError(Map<String, dynamic> result) {
    if (result['objectId'] != null) {
      return FavoritoResult.success('Favoritado!');
    } else if (result['error'] != null) {
      return FavoritoResult.error(result['error']);
    } else {
      return FavoritoResult.error('Erro ao processar informação');
    }
  }

  Future<FavoritoResult> buscarProdutoFavorito({required String userId}) async {
    final result = await _httpManager.restRequest(
        url: Endpoints.buscarFavorito,
        method: HttpMethods.requisicaoGet,
        queryParameters: {
          "include": "produtoId",
          "where": {
            "userId": {
              "__type": "Pointer",
              "className": "_User",
              "objectId": userId
            },
          }
        });

    return handleFavoritoOrError(result);
  }

  Future<FavoritoResult> deletItemFavorito(
      {required String itemFavoritoId}) async {
    final result = await _httpManager.restRequest(
        url: '${Endpoints.buscarFavorito}/$itemFavoritoId',
        method: HttpMethods.requisicaoDelete);
    return sucessDeleteOrError(result);
  }

  Future<FavoritoResult> addItemFavorito(
      {required String userId, required String produtoId}) async {
    final result = await _httpManager.restRequest(
        url: Endpoints.buscarFavorito,
        method: HttpMethods.requisicaoPost,
        body: {
          "userId": {
            "__type": "Pointer",
            "className": "_User",
            "objectId": userId
          },
          "produtoId": {
            "__type": "Pointer",
            "className": "Produto",
            "objectId": produtoId
          }
        });
    return sucessAddOrError(result);
  }
}
