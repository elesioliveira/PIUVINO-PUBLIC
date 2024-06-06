import 'package:piu_vino/src/constants/endpoints.dart';
import 'package:piu_vino/src/models/categoria_model.dart';
import 'package:piu_vino/src/models/produto_model.dart';
import 'package:piu_vino/src/pages/home/result/home_result.dart';
import 'package:piu_vino/src/services/http_manager.dart';

class HomeRepository {
  final HttpManager _httpManager = HttpManager();

  HomeResult handleCategoriaOrError(Map<String, dynamic> result) {
    if (result['results'] != null) {
      final List<dynamic> results = result['results'];
      final List<Categoria> produtos =
          results.map((item) => Categoria.fromJson(item)).toList();
      return HomeResult.success(produtos);
    } else if (result['error'] != null) {
      return HomeResult.error(result['error']);
    } else {
      return HomeResult.error('Erro desconhecido');
    }
  }

  HomeResult handleProdutoOrError(Map<String, dynamic> result) {
    if (result['results'] != null) {
      final List<dynamic> results = result['results'];
      final List<Produto> produtos =
          results.map((item) => Produto.fromJson(item)).toList();
      return HomeResult.success(produtos);
    } else if (result['error'] != null) {
      return HomeResult.error(result['error']);
    } else {
      return HomeResult.error('Erro desconhecido');
    }
  }

  Future<HomeResult> buscarProduto(
      {Map<String, dynamic>? queryParameters}) async {
    final result = await _httpManager.restRequest(
        url: Endpoints.buscarProdutos,
        method: HttpMethods.requisicaoGet,
        queryParameters: queryParameters);

    return handleProdutoOrError(result);
  }

  Future<HomeResult> buscarCategorias() async {
    final result = await _httpManager.restRequest(
        url: Endpoints.buscarCategorias, method: HttpMethods.requisicaoGet);
    return handleCategoriaOrError(result);
  }
}
