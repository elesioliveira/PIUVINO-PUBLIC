import 'package:flutter/cupertino.dart';

abstract class NavigationTabs {
  static const int home = 0;
  static const int cart = 1;
  static const int perfil = 2;
}

class NavigationController with ChangeNotifier {
  late PageController _pageController;
  int _value = 0;

  PageController get pageController => _pageController;
  int get currentIndex => _value;

  navigationController() {
    // Inicializa o _pageController no construtor
    _pageController = PageController(initialPage: NavigationTabs.home);
  }

  set index(int value) {
    _value = value;
    notifyListeners();
  }

  // Construtor para realizar a inicialização
  void initNavigation({
    required PageController pageController,
    required int currentIndex,
  }) {
    _pageController = pageController;
    _value = currentIndex;
    notifyListeners();
  }

  void navigatePageView(int page) {
    if (_value == page) return;
    _pageController.jumpToPage(page);
    _value = page;
    notifyListeners();
  }
}
