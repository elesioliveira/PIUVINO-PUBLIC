// ignore_for_file: unnecessary_null_comparison, collection_methods_unrelated_type

import 'package:piu_vino/src/constants/endpoints.dart';
import 'package:piu_vino/src/models/cupom_model.dart';
import 'package:piu_vino/src/models/frete_model.dart';
import 'package:piu_vino/src/models/user_adress.dart';
import 'package:piu_vino/src/pages/confirm_order.dart/result/adress_result.dart';
import 'package:piu_vino/src/services/http_manager.dart';

class AdressRepository {
  final HttpManager _httpManager = HttpManager();

  AdressResult handleAdressOrError(Map<String, dynamic> result) {
    if (result['results'] != null) {
      final List<dynamic> results = result['results'];
      final List<AdressModel> carrinho =
          results.map((item) => AdressModel.fromJson(item)).toList();
      return AdressResult.success(carrinho);
    } else if (result['error'] != null) {
      return AdressResult.error(result['error']);
    } else if (result['message' != null]) {
      return AdressResult.error(result['message']);
    } else {
      return AdressResult.error('Erro desconhecido');
    }
  }

  AdressResult handleFreteOrError(Map<String, dynamic> result) {
    if (result['results'] != null) {
      final List<dynamic> results = result['results'];
      final List<Frete> frete =
          results.map((item) => Frete.fromJson(item)).toList();
      return AdressResult.success(frete);
    } else if (result['error'] != null) {
      return AdressResult.error(result['error']);
    } else if (result['message' != null]) {
      return AdressResult.error(result['message']);
    } else {
      return AdressResult.error('Erro desconhecido');
    }
  }

  AdressResult sucessCupomOrError(Map<String, dynamic> result) {
    if (result['results'] != null) {
      final List<dynamic> results = result['results'];
      final List<Cupom> frete =
          results.map((item) => Cupom.fromJson(item)).toList();
      return AdressResult.success(frete);
    } else if (result['error'] != null) {
      return AdressResult.error(result['error']);
    } else if (result['message' != null]) {
      return AdressResult.error(result['message']);
    } else {
      return AdressResult.error('Erro desconhecido');
    }
  }

  AdressResult sucessCreatingOrError(Map<String, dynamic> result) {
    if (result['objectId'] != null) {
      return AdressResult.success('Endereço adicionado!');
    } else if (result['error'] != null) {
      return AdressResult.error(result['error']);
    } else if (result['message' != null]) {
      return AdressResult.error(result['message']);
    } else {
      return AdressResult.error('Erro desconhecido');
    }
  }

  AdressResult sucessAttAdressOrError(Map<String, dynamic> result) {
    if (result['updatedAt'] != null) {
      return AdressResult.success('Sucesso');
    } else if (result['message'] != null) {
      return AdressResult.error(result['message']);
    } else if (result['error'] != null) {
      return AdressResult.error(result['error']);
    } else {
      return AdressResult.error('Erro desconhecido');
    }
  }

  AdressResult sucessDeleteOrError(Map<String, dynamic> result) {
    if (result['data'] == null) {
      return AdressResult.success('Endereço excluído!');
    } else if (result['error'] != null) {
      return AdressResult.error(result['error']);
    } else {
      return AdressResult.error('Erro desconhecido');
    }
  }

  Future<AdressResult> featchAdress({required String userId}) async {
    final result = await _httpManager.restRequest(
        url: Endpoints.buscarUserAdress,
        method: HttpMethods.requisicaoGet,
        queryParameters: {
          "where": {
            "userId": {
              "__type": "Pointer",
              "className": "_User",
              "objectId": userId
            }
          }
        });
    return handleAdressOrError(result);
  }

  Future<AdressResult> creatingAdress(
      {required AdressModel adress, required String userId}) async {
    final result = await _httpManager.restRequest(
        url: Endpoints.buscarUserAdress,
        method: HttpMethods.requisicaoPost,
        body: {
          "uf": adress.uf,
          "cep": adress.cep,
          "bairro": adress.bairro,
          "cidade": adress.cidade,
          "numero": adress.numero,
          "userId": {
            "__type": "Pointer",
            "className": "_User",
            "objectId": userId
          },
          "telefone": adress.telefone,
          "logradouro": adress.logradouro,
          "referencia": adress.referencia,
          "nomeCompleto": adress.nomeCompleto
        });
    return sucessCreatingOrError(result);
  }

  Future<AdressResult> attUserAdress(
      {required AdressModel adress, required String idAdress}) async {
    final result = await _httpManager.restRequest(
        url: '${Endpoints.buscarUserAdress}/$idAdress',
        method: HttpMethods.requisicaoPut,
        body: {
          "uf": adress.uf,
          "cep": adress.cep,
          "bairro": adress.bairro,
          "cidade": adress.cidade,
          "numero": adress.numero,
          "telefone": adress.telefone,
          "logradouro": adress.logradouro,
          "referencia": adress.referencia,
          "nomeCompleto": adress.nomeCompleto
        });
    return sucessAttAdressOrError(result);
  }

  Future<AdressResult> deleteUserAdress({required String idAdress}) async {
    final result = await _httpManager.restRequest(
        url: '${Endpoints.buscarUserAdress}/$idAdress',
        method: HttpMethods.requisicaoDelete);
    return sucessDeleteOrError(result);
  }

  Future<AdressResult> feacthFrete() async {
    final result = await _httpManager.restRequest(
        url: Endpoints.buscarFrete,
        method: HttpMethods.requisicaoGet,
        queryParameters: {'order': 'preco'});
    return handleFreteOrError(result);
  }

  Future<AdressResult> feacthCupom() async {
    final result = await _httpManager.restRequest(
        url: Endpoints.buscarCupom, method: HttpMethods.requisicaoGet);
    return sucessCupomOrError(result);
  }
}
