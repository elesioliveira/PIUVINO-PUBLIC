// ignore_for_file: prefer_is_empty

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:page_transition/page_transition.dart';
import 'package:piu_vino/src/common_widgets/appbar_base_screen.dart';
import 'package:piu_vino/src/common_widgets/custom_shimmer.dart';
import 'package:piu_vino/src/config/custom_colors.dart';
import 'package:piu_vino/src/pages/auth/controller/auth_controller.dart';
import 'package:piu_vino/src/pages/favoritos/controller/favorito_controller.dart';
import 'package:piu_vino/src/pages/home/controller/home_controller.dart';
import 'package:piu_vino/src/pages/cart/controller/pedido_controller.dart';
import 'package:piu_vino/src/pages/produto/produto_screen.dart';
import 'package:piu_vino/src/providers/providers.dart';
import 'package:piu_vino/src/services/utils_services.dart';

class FavoritoScreen extends StatefulWidget {
  const FavoritoScreen({super.key});

  @override
  State<FavoritoScreen> createState() => _FavoritoScreenState();
}

class _FavoritoScreenState extends State<FavoritoScreen> {
  bool activeIcon = false;
  bool isTrue = false;
  HomeController homeController = HomeController();
  AuthController userController = AuthController();
  CartController cartController = CartController();
  FavoritoController favoritoController = FavoritoController();
  final UtilsSerices utilsServices = UtilsSerices();

  @override
  void initState() {
    super.initState();
    homeController = getIt<HomeController>();
    userController = getIt<AuthController>();
    favoritoController = getIt<FavoritoController>();
    cartController = getIt<CartController>();
  }

  Future<void> refreshListFavorito() async {
    await favoritoController.buscarItemFavorito(
        userId: userController.user.objectId.toString());
  }

  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.sizeOf(context).width;
    double sizeHeigth = MediaQuery.sizeOf(context).height;
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const Gap(20),
          //AppBar
          const AppBarBaseScreen(
            opacityIsTrue: false,
          ),
          const Gap(20),

          AnimatedBuilder(
            animation: favoritoController,
            builder: (context, child) {
              return Expanded(
                child: AnimatedBuilder(
                  animation: homeController,
                  builder: (context, child) {
                    if (homeController.isLoadingProduto == true) {
                      return GridView.count(
                        scrollDirection: Axis.vertical,
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 9 / 11.5,
                        children: List.generate(
                          10,
                          (index) => CustomShimmer(
                            height: double.infinity,
                            width: double.infinity,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      );
                    }
                    if (favoritoController.favoritos.isNotEmpty) {
                      return AnimatedBuilder(
                        animation: favoritoController,
                        builder: (context, child) {
                          return RefreshIndicator(
                            onRefresh: () async {
                              favoritoController.setListaItem();
                              await favoritoController.buscarItemFavorito(
                                  userId:
                                      userController.user.objectId.toString());
                            },
                            //Produtos GridView
                            child: GridView.builder(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                              itemCount: favoritoController.favoritos.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                childAspectRatio: 8.5 / 9.5,
                              ),
                              itemBuilder: (_, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                        duration:
                                            const Duration(milliseconds: 800),
                                        type: PageTransitionType
                                            .leftToRightWithFade,
                                        child: DetailProductScreen(
                                          quantidadeProduto: favoritoController
                                              .favoritos[index]
                                              .produtoId
                                              .quantidade
                                              .toInt(),
                                          nomeProduto: favoritoController
                                              .favoritos[index].produtoId.nome,
                                          precoProduto: favoritoController
                                              .favoritos[index].produtoId.preco
                                              .toDouble(),
                                          produtoId: favoritoController
                                              .favoritos[index]
                                              .produtoId
                                              .objectId,
                                          tagHero: favoritoController
                                              .favoritos[index]
                                              .produtoId
                                              .objectId,
                                        ),
                                      ),
                                    );
                                  },
                                  child: AnimatedBuilder(
                                    animation: homeController,
                                    builder: (context, child) {
                                      return Card(
                                        child: Stack(
                                          alignment: Alignment.topCenter,
                                          children: [
                                            Hero(
                                              tag: favoritoController
                                                  .favoritos[index]
                                                  .produtoId
                                                  .objectId
                                                  .toString(),
                                              child: Image.asset(
                                                height: sizeHeigth / 4.7,
                                                'assets/app_images/garrafa.png',
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            Positioned(
                                              bottom: 5,
                                              left: 15,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    width: sizeWidth / 2.6,
                                                    child: Text(
                                                      textAlign: TextAlign.left,
                                                      favoritoController
                                                          .favoritos[index]
                                                          .produtoId
                                                          .nome
                                                          .toUpperCase(),
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    utilsServices
                                                        .priceToCurrency(
                                                      favoritoController
                                                          .favoritos[index]
                                                          .produtoId
                                                          .preco
                                                          .toDouble(),
                                                    ),
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: CustomColors
                                                          .primaryColor,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Positioned(
                                                right: 5,
                                                top: 8,
                                                child: GestureDetector(
                                                  onTap: () async {
                                                    favoritoController
                                                        .removeItemFavorito(
                                                            itemFavoritoId:
                                                                favoritoController
                                                                    .favoritos[
                                                                        index]
                                                                    .objectId);
                                                  },
                                                  child: Icon(
                                                    CupertinoIcons.heart_fill,
                                                    color: CustomColors
                                                        .segundaryColor,
                                                  ),
                                                ))
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
                    } else {
                      return SizedBox(
                        height: sizeHeigth,
                        child: RefreshIndicator(
                          onRefresh: () async {
                            favoritoController.setListaItem();
                            await favoritoController.buscarItemFavorito(
                                userId:
                                    userController.user.objectId.toString());
                          },
                          child: ListView.builder(
                            itemCount: 1,
                            itemBuilder: (context, child) {
                              return Center(
                                child: Text(
                                  'Não há produtos pra apresentar',
                                  style: TextStyle(color: Colors.grey.shade400),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    }
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
