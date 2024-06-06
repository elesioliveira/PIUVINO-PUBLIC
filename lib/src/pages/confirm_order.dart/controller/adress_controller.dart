// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:piu_vino/src/models/cupom_model.dart';
import 'package:piu_vino/src/models/frete_model.dart';
import 'package:piu_vino/src/models/user_adress.dart';
import 'package:piu_vino/src/pages/base/view/base_screen.dart';
import 'package:piu_vino/src/pages/confirm_order.dart/repository/adress_repository.dart';
import 'package:piu_vino/src/pages/confirm_order.dart/result/adress_result.dart';
import 'package:piu_vino/src/services/utils_services.dart';
import 'package:search_cep/search_cep.dart';

class AdressController with ChangeNotifier {
  final adressRepository = AdressRepository();
  final utilsSerices = UtilsSerices();
  final List<AdressModel> _adress = [];
  List<AdressModel> get adress => _adress;
  Cupom cupomIdentificado = Cupom(objectId: 'sem valor', valor: 0);
  final List<Frete> _frete = [];
  final List<Cupom> _cupom = [];
  int isSelect = 0;
  List<Cupom> get cupons => _cupom;
  List<Frete> get fretes => _frete;
  String timerText = '';

  atualizarAdressSelect(int index) {
    isSelect = index;
    notifyListeners();
  }

  PostmonCepInfo? cepSucess = PostmonCepInfo();

  bool _isLoadingAdress = false;
  bool get isLoading => _isLoadingAdress;

  bool _isLoadingFrete = false;
  bool get isLoadingFrete => _isLoadingFrete;

  bool _isLoadingCupom = false;
  bool get isLoadingCupom => _isLoadingCupom;

  final bool _isLoadingNewAdress = false;
  bool get isLoadingNewAdress => _isLoadingNewAdress;

  bool _isLoadingAttAdress = false;
  bool get isLoadingAttAdress => _isLoadingAttAdress;

  bool _isLoadingDeleteAdress = false;
  bool get isLoadingDeleteAdress => _isLoadingDeleteAdress;

  int freteValor = 0;

  int _valorFrete = 0;
  int get valorFrete => _valorFrete;

  Future<void> isSelectDeleteAdressUser(int index, String idAdress) async {
    if (isSelect == index) {
      await deleteUserAdress(idAdress: idAdress);
      isSelect = 0;
      notifyListeners();
      return;
    } else {
      await deleteUserAdress(idAdress: idAdress);
      notifyListeners();
      return;
    }
  }

  isLoadingAdress(bool value) {
    _isLoadingAdress = value;
    notifyListeners();
  }

  set setLoadingDeleteAdress(bool value) {
    _isLoadingDeleteAdress = value;
    notifyListeners();
  }

  set setLoadingAttAdress(bool value) {
    _isLoadingAttAdress = value;
    notifyListeners();
  }

  set setLoadingCupom(bool value) {
    _isLoadingCupom = value;
    notifyListeners();
  }

  set setLoadingFrete(bool value) {
    _isLoadingFrete = value;
    notifyListeners();
  }

  set setValorFrete(int index) {
    _valorFrete = index;
    freteValor = _frete[index].preco;
    notifyListeners();
  }

  Cupom? identificarCupom({String? cupomId}) {
    return cupomIdentificado = _cupom.firstWhere(
        (cupom) => cupom.objectId == cupomId,
        orElse: () => Cupom(objectId: 'sem valor', valor: 0));
  }

  double calcularPreco(double precoCart, int cupom) {
    double porcentagem = precoCart / 100;
    double multiplicacao = porcentagem * cupom;
    double resultado = precoCart - multiplicacao;
    return resultado;
  }

  Future<void> feacthAdress({required String userId}) async {
    isLoadingAdress(true);
    _adress.clear();
    try {
      AdressResult result = await adressRepository.featchAdress(userId: userId);
      result.when(success: (adress) {
        _adress.addAll(adress);
      }, error: (mensagem) {
        utilsSerices.showToast(message: mensagem, isError: true);
      });
    } finally {
      isLoadingAdress(false);
    }
    notifyListeners();
  }

  Future<void> deleteUserAdress({required String idAdress}) async {
    AdressResult result =
        await adressRepository.deleteUserAdress(idAdress: idAdress);
    result.when(success: (mensagem) {
      utilsSerices.showToast(message: mensagem);
    }, error: (mensagem) {
      utilsSerices.showToast(message: mensagem, isError: true);
    });
  }

  Future<void> attUserAdress(
      {required AdressModel adress, required String idAdress}) async {
    setLoadingAttAdress = true;
    AdressResult result = await adressRepository.attUserAdress(
        adress: adress, idAdress: idAdress);
    result.when(success: (mensagem) {
      utilsSerices.showToast(message: mensagem);
    }, error: (mensagem) {
      utilsSerices.showToast(message: mensagem, isError: true);
    });
    setLoadingAttAdress = false;
    notifyListeners();
  }

  Future<void> creatingAdress(
      {required AdressModel adress, required String userId}) async {
    setLoadingAttAdress = true;
    AdressResult result =
        await adressRepository.creatingAdress(adress: adress, userId: userId);
    result.when(success: (mensagem) {
      utilsSerices.showToast(message: mensagem);
    }, error: (mensagem) {
      utilsSerices.showToast(message: mensagem);
    });
    setLoadingAttAdress = false;
    notifyListeners();
  }

  Future<void> feacthFrete() async {
    setLoadingFrete = true;
    _frete.clear();
    AdressResult result = await adressRepository.feacthFrete();
    result.when(success: (frete) {
      _frete.addAll(frete);
    }, error: (mensagem) {
      utilsSerices.showToast(message: mensagem, isError: true);
    });
    setLoadingFrete = false;
    notifyListeners();
  }

  Future<void> feacthCupom() async {
    setLoadingCupom = true;
    _cupom.clear();
    notifyListeners();
    AdressResult result = await adressRepository.feacthCupom();
    result.when(success: (cupom) {
      _cupom.addAll(cupom);
    }, error: (mensagem) {
      utilsSerices.showToast(message: mensagem, isError: true);
    });
    setLoadingCupom = false;
    notifyListeners();
  }

  Future<void> searchCep({context, required String cep}) async {
    final postmonSearchCep = PostmonSearchCep();
    final infoCepJSON = await postmonSearchCep.searchInfoByCep(cep: cep);
    infoCepJSON.fold((searchInfoError) {
      utilsSerices.showToast(message: searchInfoError.errorMessage);
    }, (postmonSearchCep) {
      cepSucess = postmonSearchCep;
    });
  }

  void showDialogAdressDeleteConfirm(
      {required BuildContext context,
      required Listenable animation,
      required String idAdress,
      required bool carregando,
      required String userId}) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return CupertinoAlertDialog(
              title: const Text('Alerta'),
              content: const Text('Deseja excluír o endereço?'),
              actions: <CupertinoDialogAction>[
                CupertinoDialogAction(
                  onPressed: carregando
                      ? null
                      : () {
                          Navigator.of(context).pop();
                        },
                  child: const Text('Sair'),
                ),
                CupertinoDialogAction(
                  isDestructiveAction: true,
                  isDefaultAction: true,
                  onPressed: carregando
                      ? null
                      : () async {
                          await deleteUserAdress(idAdress: idAdress);
                          await feacthAdress(userId: userId);
                          Navigator.of(context).pop();
                        },
                  child: const Text('Excluír'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> updateTimerFinallOrder(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2));
    timerText = '8';
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    timerText = '7';
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    timerText = '6';
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    timerText = '5';
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    timerText = '4';
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    timerText = '3';
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    timerText = '2';
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    timerText = '1';
    notifyListeners();
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.bottomToTop,
        duration: const Duration(milliseconds: 700),
        child: const BaseScreen(),
      ),
    );
  }
}
