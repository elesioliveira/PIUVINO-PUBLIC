import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:page_transition/page_transition.dart';
import 'package:piu_vino/src/pages/auth/controller/auth_controller.dart';
import 'package:piu_vino/src/pages/auth/view/sign_in__screen.dart';
import 'package:piu_vino/src/pages/auth/view/update_user.dart';
import 'package:piu_vino/src/pages/cart/controller/pedido_controller.dart';
import 'package:piu_vino/src/pages/favoritos/controller/favorito_controller.dart';
import 'package:piu_vino/src/pages/home/controller/home_controller.dart';
import 'package:piu_vino/src/pages/order/controller/order_controller.dart';
import 'package:piu_vino/src/pages/user_report/view/user_report.dart';
import 'package:piu_vino/src/providers/providers.dart';
import 'package:piu_vino/src/services/utils_services.dart';

class SettingsUser extends StatefulWidget {
  const SettingsUser({super.key});

  @override
  State<SettingsUser> createState() => _SettingsUserState();
}

class _SettingsUserState extends State<SettingsUser> {
  final MenuController _menuController = MenuController();
  UtilsSerices utilsServices = UtilsSerices();
  AuthController userController = AuthController();
  HomeController homeController = HomeController();
  FavoritoController favoritoController = FavoritoController();
  CartController cartController = CartController();
  OrderController orderController = OrderController();

  @override
  void initState() {
    super.initState();
    utilsServices = getIt<UtilsSerices>();
    userController = getIt<AuthController>();
    homeController = getIt<HomeController>();
    favoritoController = getIt<FavoritoController>();
    cartController = getIt<CartController>();
    orderController = getIt<OrderController>();
  }

  @override
  Widget build(BuildContext context) {
    double sizeHeight = MediaQuery.sizeOf(context).height;
    double sizeWidth = MediaQuery.sizeOf(context).width;
    return SizedBox(
      width: sizeWidth,
      height: sizeHeight / 2,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ListTile(
            onTap: () async {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.leftToRight,
                  duration: const Duration(milliseconds: 700),
                  child: const UpdateUserInfo(),
                ),
              );
            },
            contentPadding: EdgeInsets.only(left: sizeWidth * 0.2),
            leading: const Icon(CupertinoIcons.person),
            title: const Text('Alterar dados Cadastrais'),
          ),
          const Gap(10),
          MenuAnchor(
            style: const MenuStyle(),
            alignmentOffset: Offset(sizeWidth / 1.4, -18),
            controller: _menuController,
            menuChildren: [
              MenuItemButton(
                child: const Text('Modo escuro'),
                onPressed: () {
                  utilsServices.toggleTheme(true);
                  _menuController.close();
                },
              ),
              MenuItemButton(
                child: const Text('Modo claro'),
                onPressed: () {
                  utilsServices.toggleTheme(false);
                  _menuController.close();
                },
              ),
            ],
            child: AnimatedBuilder(
              animation: utilsServices,
              builder: (context, child) {
                return ListTile(
                  onTap: () {
                    _menuController.open();
                  },
                  contentPadding: EdgeInsets.only(left: sizeWidth * 0.2),
                  leading: utilsServices.isDarkMode
                      ? const Icon(CupertinoIcons.lightbulb_fill)
                      : const Icon(CupertinoIcons.lightbulb),
                  title: const Text('Alterar exibições'),
                  trailing: Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: utilsServices.isDarkMode
                        ? const Icon(CupertinoIcons.moon_fill)
                        : const Icon(CupertinoIcons.brightness),
                  ),
                );
              },
            ),
          ),
          const Gap(10),
          ListTile(
            onTap: () async {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.leftToRight,
                  duration: const Duration(milliseconds: 350),
                  child: const UserReport(),
                ),
              );
            },
            contentPadding: EdgeInsets.only(left: sizeWidth * 0.2),
            leading: const Icon(CupertinoIcons.exclamationmark_bubble),
            title: const Text('Relatar um problema'),
          ),
          const Gap(10),
          ListTile(
            onTap: () async {
              userController.resetUser();
              homeController.resetHomeController();
              favoritoController.resetFavorito();
              cartController.resetCartController();
              orderController.resetOrderController();
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  duration: const Duration(milliseconds: 350),
                  child: const SignInScreen(),
                ),
              );
            },
            contentPadding: EdgeInsets.only(left: sizeWidth * 0.2),
            title: const Text('Sair'),
          ),
          const Gap(10),
        ],
      ),
    );
  }
}
