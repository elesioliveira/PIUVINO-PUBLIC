import 'package:dio/dio.dart';

abstract class HttpMethods {
  static const String requisicaoPost = 'POST';
  static const String requisicaoGet = 'GET';
  static const String requisicaoPut = 'PUT';
  static const String requisicaoPatch = 'Patch';
  static const String requisicaoDelete = 'DELETE';
}

class HttpManager {
  Future<Map<String, dynamic>> restRequest({
    required String url,
    required String method,
    Map? headers,
    Map? body,
    int? page,
    int? limit = 0,
    Map<String, dynamic>? queryParameters,
  }) async {
    // Headers da requisição
    final defaultHeaders = headers?.cast<String, String>() ?? {}
      ..addAll({});

    Dio dio = Dio();

    try {
      Response response = await dio.request(
        url,
        options: Options(
          headers: defaultHeaders,
          method: method,
        ),
        queryParameters: queryParameters,
        data: body,
      );

      // Retorno do resultado do backend
      return response.data;
    } on DioException catch (e) {
      // Retorno do erro do dio request

      return e.response?.data ?? {};
    } catch (error) {
      // Retorno de map vazio para error generalizado
      return {};
    }
  }
}
