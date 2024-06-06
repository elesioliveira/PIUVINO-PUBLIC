// ignore_for_file: prefer_final_fields
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:piu_vino/src/models/categoria_model.dart';
import 'package:piu_vino/src/models/produto_model.dart';
import 'package:piu_vino/src/pages/home/repository/home_repository.dart';
import 'package:piu_vino/src/pages/home/result/home_result.dart';
import 'package:piu_vino/src/services/utils_services.dart';

class HomeController with ChangeNotifier {
  final homeRepository = HomeRepository();
  final utilsServices = UtilsSerices();
  Timer? _timer;
  String? currentCategory;
  int _skip = 0;
  final int _limit = 10;
  int _ultimaRequisicao = 0;
  bool _isLoadingCategoria = false;
  bool _isLoadingProduto = false;
  List<Categoria> _categoria = [];
  List<Produto> _produtos = [];

  List<Categoria> get categoria => _categoria;
  List<Produto> get produtos => _produtos;
  bool get isLoadingProduto => _isLoadingProduto;
  bool get isLoadingCategoria => _isLoadingCategoria;
  int get ultimaRequisicao => _ultimaRequisicao;
  TextEditingController pesquisarProduto = TextEditingController();

  resetHomeController() {
    _produtos.clear();
    _categoria.clear();
    _skip = 0;
    _ultimaRequisicao = 0;
    notifyListeners();
  }

  void setFavoritedProduct(int index, bool? value) {
    if (index < _produtos.length) {
      _produtos[index].favorito = !_produtos[index].favorito;
      notifyListeners();
    }
  }

  limparListaProduto() {
    _produtos.clear();
    _skip = 0;
    _ultimaRequisicao = 0;
    notifyListeners();
  }

  getProductToNameTimer() async {
    // Cancela o timer existente para evitar múltiplas chamadas
    _timer?.cancel();
    // Configura um novo timer para executar a função após 2 segundos
    _timer = Timer(const Duration(seconds: 4), () {
      notifyListeners();

      if (pesquisarProduto.text.length < 4) {
        return utilsServices.showToast(
            message: 'Nome insuficiente', isError: true);
      }
      filtrarProdutoPeloNome(pesquisarProduto.text);
    });
  }

  bool get isLastPage {
    if (_ultimaRequisicao < _limit) return true;
    return _skip + _limit > _produtos.length;
  }

  void loadMoreProducts() {
    _skip += 10;
    buscarTodosProdutos(canLoad: false);
  }

  setLoading(bool value) {
    _isLoadingCategoria = value;
    notifyListeners();
  }

  setLoadingProduto(bool value) {
    _isLoadingProduto = value;
    notifyListeners();
    return;
  }

  void selectCategory(String category) {
    currentCategory = category;
    notifyListeners();
  }

  Future<void> buscarTodosProdutos({required bool canLoad}) async {
    if (canLoad == false) {
      HomeResult result = await homeRepository.buscarProduto(
        queryParameters: {
          "limit": _limit,
          "skip": _skip,
          "include": "categoria",
        },
      );
      result.when(success: (produto) {
        _produtos.addAll(produto);
        _ultimaRequisicao = _produtos.length;
        notifyListeners();
      }, error: (menssagem) {
        utilsServices.showToast(message: menssagem, isError: true);
      });
      notifyListeners();
      return;
    } else {
      setLoadingProduto(canLoad);
      HomeResult result = await homeRepository.buscarProduto(
        queryParameters: {
          "limit": _limit,
          "skip": _skip,
          "include": "categoria",
        },
      );
      result.when(success: (produto) {
        _produtos.addAll(produto);
        _ultimaRequisicao = _produtos.length;
        notifyListeners();
      }, error: (menssagem) {
        utilsServices.showToast(message: menssagem, isError: true);
      });
    }
    setLoadingProduto(false);
    notifyListeners();
  }

  Future<void> filtrarProdutoPorCategoria(String? categoria) async {
    // Cancela o timer existente para evitar múltiplas chamadas
    _timer?.cancel();
    //vai limpar a lista de produto
    _produtos.clear();

    notifyListeners();
    setLoadingProduto(true);

    HomeResult result = await homeRepository.buscarProduto(
      queryParameters: {
        "include": "categoria",
        "where": {
          "categoria": {
            "__type": "Pointer",
            "className": "Categoria",
            "objectId": categoria
          }
        }
      },
    );
    result.when(success: (produto) {
      _produtos.addAll(produto);
    }, error: (mensagem) {
      utilsServices.showToast(message: mensagem, isError: true);
    });
    setLoadingProduto(false);
    notifyListeners();
  }

  Future<void> filtrarProdutoPeloNome(String? nomeProduto) async {
    _produtos.clear();
    setLoadingProduto(true);
    notifyListeners();

    HomeResult result = await homeRepository.buscarProduto(
      queryParameters: {
        "include": "categoria",
        "where": {
          "nome": {
            "\$regex": nomeProduto ?? '', // Usando ?? para tratar valor nulo
            "\$options": "i"
          }
        }
      },
    );
    result.when(success: (produto) {
      _produtos.addAll(produto);
    }, error: (mensagem) {
      utilsServices.showToast(message: mensagem, isError: true);
    });
    setLoadingProduto(false);
    notifyListeners();
  }

  Future<void> buscarTodasCategorias() async {
    setLoading(true);
    HomeResult result = await homeRepository.buscarCategorias();
    result.when(success: (categoria) {
      _categoria.addAll(categoria);
      selectCategory(_categoria[0].nomeCategoria);
    }, error: (mensagem) {
      utilsServices.showToast(message: mensagem, isError: true);
    });
    setLoading(false);
    notifyListeners();
  }
}
