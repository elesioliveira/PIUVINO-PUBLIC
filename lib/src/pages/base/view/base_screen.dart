import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:piu_vino/src/config/custom_colors.dart';
import 'package:piu_vino/src/pages/base/controller/navigation_controller.dart';
import 'package:piu_vino/src/pages/favoritos/view/favorito_view.dart';
import 'package:piu_vino/src/pages/home/controller/home_controller.dart';
import 'package:piu_vino/src/pages/home/view/home_screen.dart';
import 'package:piu_vino/src/pages/order/view/order.dart';
import 'package:piu_vino/src/pages/perfil/view/user_perfil.dart';
import 'package:piu_vino/src/providers/providers.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final navigationController = NavigationController();
  HomeController controller = HomeController();

  @override
  void initState() {
    super.initState();
    navigationController.navigationController();
    controller = getIt<HomeController>();
  }

  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.sizeOf(context).width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white.withAlpha(180),
        body: SizedBox(
          width: sizeWidth,
          child: PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: navigationController.pageController,
            scrollDirection: Axis.horizontal,
            children: const [
              HomeScreen(),
              FavoritoScreen(),
              OrderUser(),
              PerfilUser()
            ],
          ),
        ),
        bottomNavigationBar: AnimatedBuilder(
          animation: navigationController,
          builder: (context, _) {
            return BottomNavigationBar(
              onTap: (index) {
                navigationController.navigatePageView(index);
              },
              backgroundColor: CustomColors.primaryColor,
              selectedItemColor: CustomColors.white,
              unselectedItemColor: Colors.black,
              type: BottomNavigationBarType.fixed,
              currentIndex: navigationController.currentIndex,
              items: [
                BottomNavigationBarItem(
                  icon: navigationController.currentIndex == 0
                      ? const Icon(
                          CupertinoIcons.house_fill,
                        )
                      : const Icon(CupertinoIcons.home),
                  label: 'Início',
                ),
                BottomNavigationBarItem(
                  icon: navigationController.currentIndex == 1
                      ? const Icon(CupertinoIcons.heart_fill)
                      : const Icon(CupertinoIcons.heart),
                  label: 'Favoritos',
                ),
                BottomNavigationBarItem(
                  icon: navigationController.currentIndex == 2
                      ? const Icon(CupertinoIcons.square_list_fill)
                      : const Icon(CupertinoIcons.square_list),
                  label: 'Pedidos',
                ),
                BottomNavigationBarItem(
                  icon: navigationController.currentIndex == 3
                      ? const Icon(CupertinoIcons.person_2_fill)
                      : const Icon(CupertinoIcons.person_2),
                  label: 'Perfil',
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
