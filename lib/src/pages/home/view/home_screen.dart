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
import 'package:piu_vino/src/pages/home/componentes/category_tile.dart';
import 'package:piu_vino/src/pages/home/controller/home_controller.dart';
import 'package:piu_vino/src/pages/cart/controller/pedido_controller.dart';
import 'package:piu_vino/src/pages/produto/produto_screen.dart';
import 'package:piu_vino/src/providers/providers.dart';
import 'package:piu_vino/src/services/utils_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool activeIcon = false;
  bool isTrue = false;
  HomeController homeController = HomeController();
  FavoritoController favoritoController = FavoritoController();
  AuthController userController = AuthController();
  CartController cartController = CartController();
  final UtilsSerices utilsServices = UtilsSerices();

  @override
  void initState() {
    super.initState();
    homeController = getIt<HomeController>();
    favoritoController = getIt<FavoritoController>();
    cartController = getIt<CartController>();
    userController = getIt<AuthController>();
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
          const Gap(10),

          //Entrada de texto
          Container(
            padding: const EdgeInsets.only(left: 30, right: 30),
            width: sizeWidth / 0.8,
            child: Material(
              elevation: 1,
              borderRadius: BorderRadius.circular(30.0),
              child: TextFormField(
                controller: homeController.pesquisarProduto,
                onChanged: (String? value) {
                  setState(() {
                    homeController.pesquisarProduto.text = value!;
                    isTrue = homeController.pesquisarProduto.text.isNotEmpty;
                    activeIcon = isTrue;
                    homeController.getProductToNameTimer();
                  });
                },
                decoration: InputDecoration(
                  label: const Text('Pesquise sua bebida..'),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(30.0),
                  ), // Remover todas as bordas
                  suffixIcon: activeIcon
                      ? Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                homeController.pesquisarProduto.text = '';
                                activeIcon = homeController
                                    .pesquisarProduto.text.isNotEmpty;
                                homeController.limparListaProduto();
                                homeController.buscarTodosProdutos(
                                    canLoad: true);
                              });
                            },
                            child: Icon(
                              CupertinoIcons.clear,
                              color: CustomColors.primaryColor,
                            ),
                          ),
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
          ),
          const Gap(15),

          //Categorias
          Container(
            width: sizeWidth,
            padding: const EdgeInsets.only(
              left: 30,
              right: 30,
            ),
            child: AnimatedBuilder(
              animation: homeController,
              builder: (context, child) {
                if (homeController.categoria.isNotEmpty) {
                  return Container(
                    height: 50,
                    padding: const EdgeInsets.only(left: 3),
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (_, index) {
                        return CategoryTile(
                          onPressed: () async {
                            if (homeController.pesquisarProduto.text != '') {
                              setState(() {
                                homeController.pesquisarProduto.text = '';
                                activeIcon = homeController
                                    .pesquisarProduto.text.isNotEmpty;
                                homeController.limparListaProduto();
                              });
                            }
                            if (homeController.currentCategory ==
                                homeController.categoria[index].nomeCategoria) {
                              return;
                            }
                            homeController.selectCategory(
                                homeController.categoria[index].nomeCategoria);
                            if (homeController.currentCategory ==
                                homeController.categoria[0].nomeCategoria) {
                              homeController.limparListaProduto();
                              await homeController.buscarTodosProdutos(
                                  canLoad: true);
                              return;
                            }
                            await homeController.filtrarProdutoPorCategoria(
                                homeController.categoria[index].objectId);
                          },
                          category:
                              homeController.categoria[index].nomeCategoria,
                          isSelected:
                              homeController.categoria[index].nomeCategoria ==
                                  homeController.currentCategory,
                        );
                      },
                      separatorBuilder: (_, index) => const SizedBox(width: 10),
                      itemCount: homeController.categoria.length,
                    ),
                  );
                }
                if (homeController.isLoadingCategoria) {
                  return Container(
                    height: 50,
                    padding: const EdgeInsets.only(left: 3),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: List.generate(
                        10,
                        (index) => Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(right: 12),
                          child: CustomShimmer(
                            height: 20,
                            width: 80,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container(
                    height: 50,
                    padding: const EdgeInsets.only(left: 3),
                    child: const Center(
                      child: Text(
                        'Error',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
          const Gap(5),

          //Produtos GridView
          Expanded(
            child: AnimatedBuilder(
              animation: homeController,
              builder: (context, child) {
                if (homeController.isLoadingProduto == true) {
                  return GridView.count(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    physics: const BouncingScrollPhysics(),
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
                if (homeController.produtos.isNotEmpty) {
                  return GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    physics: const BouncingScrollPhysics(),
                    itemCount: homeController.produtos.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 8.5 / 9.5,
                    ),
                    itemBuilder: (_, index) {
                      if (((index + 1) == homeController.ultimaRequisicao) &&
                          !homeController.isLastPage &&
                          homeController.currentCategory ==
                              homeController.categoria[0].nomeCategoria) {
                        homeController.loadMoreProducts();
                      }
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              duration: const Duration(milliseconds: 800),
                              type: PageTransitionType.leftToRightWithFade,
                              child: DetailProductScreen(
                                quantidadeProduto: homeController
                                    .produtos[index].quantidade
                                    .toInt(),
                                nomeProduto:
                                    homeController.produtos[index].nome,
                                precoProduto: homeController
                                    .produtos[index].preco
                                    .toDouble(),
                                produtoId:
                                    homeController.produtos[index].objectId,
                                tagHero:
                                    homeController.produtos[index].objectId,
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
                                    tag:
                                        homeController.produtos[index].objectId,
                                    child: Image.asset(
                                      scale: 4,
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
                                            homeController.produtos[index].nome
                                                .toUpperCase(),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          utilsServices.priceToCurrency(
                                            homeController.produtos[index].preco
                                                .toDouble(),
                                          ),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: CustomColors.primaryColor,
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
                                        setState(() {
                                          if (homeController
                                              .produtos[index].favorito) {
                                            homeController
                                                    .produtos[index].favorito =
                                                !homeController
                                                    .produtos[index].favorito;
                                            favoritoController.favoritedForTime(
                                                value: homeController
                                                    .produtos[index].favorito,
                                                userId: userController
                                                    .user.objectId
                                                    .toString(),
                                                productId: homeController
                                                    .produtos[index].objectId);
                                            return;
                                          }
                                          if (favoritoController.isFavorito(
                                            homeController
                                                .produtos[index].objectId
                                                .toString(),
                                          )) {
                                            return utilsServices.showToast(
                                                message:
                                                    'Esse item já está em sua lista',
                                                isError: true);
                                          } else {
                                            homeController
                                                    .produtos[index].favorito =
                                                !homeController
                                                    .produtos[index].favorito;
                                            favoritoController.favoritedForTime(
                                                value: homeController
                                                    .produtos[index].favorito,
                                                userId: userController
                                                    .user.objectId
                                                    .toString(),
                                                productId: homeController
                                                    .produtos[index].objectId);
                                          }
                                        });
                                      },
                                      child: AnimatedBuilder(
                                        animation: homeController,
                                        builder: (context, child) {
                                          return SizedBox(
                                            child: homeController
                                                    .produtos[index].favorito
                                                ? Icon(
                                                    CupertinoIcons.heart_fill,
                                                    color: CustomColors
                                                        .segundaryColor,
                                                  )
                                                : Icon(
                                                    CupertinoIcons.heart,
                                                    color: CustomColors
                                                        .segundaryColor,
                                                  ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                } else {
                  return SizedBox(
                    width: sizeWidth,
                    height: sizeHeigth,
                    child: const Center(
                      child: Text(
                        'Não há produtos pra apresentar',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
