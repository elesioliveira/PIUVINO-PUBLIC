import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:page_transition/page_transition.dart';
import 'package:piu_vino/src/common_widgets/custom_shimmer.dart';
import 'package:piu_vino/src/common_widgets/custom_text_field.dart';
import 'package:piu_vino/src/config/custom_colors.dart';
import 'package:piu_vino/src/pages/auth/controller/auth_controller.dart';
import 'package:piu_vino/src/pages/confirm_order.dart/controller/adress_controller.dart';
import 'package:piu_vino/src/pages/confirm_order.dart/view/confirm_order/confirm_order.dart';
import 'package:piu_vino/src/pages/cart/controller/pedido_controller.dart';
import 'package:piu_vino/src/pages/cart/view/components/item_cart.dart';
import 'package:piu_vino/src/pages/cart/view/components/title.dart';
import 'package:piu_vino/src/providers/providers.dart';
import 'package:piu_vino/src/services/utils_services.dart';

class PedidoTab extends StatefulWidget {
  const PedidoTab({super.key});

  @override
  State<PedidoTab> createState() => _PedidoTabState();
}

class _PedidoTabState extends State<PedidoTab> {
  CartController cartController = CartController();
  AuthController userController = AuthController();
  AdressController adressController = AdressController();
  final UtilsSerices utilsServices = UtilsSerices();
  TextEditingController cupomController = TextEditingController();

  @override
  void initState() {
    super.initState();
    cartController = getIt<CartController>();
    userController = getIt<AuthController>();
    adressController = getIt<AdressController>();
    cartController.buscarPedido(
        idUser: userController.user.objectId.toString(), canLoad: false);
    cartController.calcularPrecoFinal(cartController.pedidos);
    adressController.feacthCupom();
    adressController.feacthAdress(
        userId: userController.user.objectId.toString());
  }

  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.sizeOf(context).width;
    double sizeHeigth = MediaQuery.sizeOf(context).height;

    return SafeArea(
      child: Scaffold(
        body: AnimatedBuilder(
          animation: cartController,
          builder: (context, child) {
            if (cartController.isLoading) {
              return CustomShimmer(height: sizeHeigth, width: sizeWidth);
            } else {
              return Stack(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Gap(sizeHeigth * 0.02),
                      //TITULO
                      const TitleCartScreen(),
                      //Dvider
                      SizedBox(
                        width: sizeWidth,
                        height: 2,
                        child: Divider(
                          height: 2,
                          thickness: 2,
                          color: Colors.grey.shade300,
                        ),
                      ),

                      Gap(sizeHeigth * 0.02),

                      //Compras
                      AnimatedBuilder(
                          animation: cartController,
                          builder: (context, child) {
                            if (cartController.pedidos.isNotEmpty) {
                              return Container(
                                width: sizeWidth,
                                height: sizeHeigth / 1.5,
                                padding: const EdgeInsets.only(bottom: 30),
                                child: ListView.separated(
                                    itemBuilder: (context, index) {
                                      return ItemCart(
                                        result: (quantidade) {
                                          setState(() {
                                            cartController.pedidos[index]
                                                .quantidade = quantidade;
                                            cartController.timerAttItemIntoCart(
                                                idCart: cartController
                                                    .pedidos[index].objectId
                                                    .toString(),
                                                confirmado: false,
                                                quantidade: cartController
                                                    .pedidos[index].quantidade
                                                    .toInt());
                                          });
                                        },
                                        nomeItem: cartController
                                            .pedidos[index].produto.nome
                                            .toString(),
                                        precoItem: cartController
                                            .pedidos[index].produto.preco,
                                        quantidade: cartController
                                            .pedidos[index].quantidade,
                                        onTap: () async {
                                          cartController.showAlertDialog(
                                              context: context,
                                              idCliente: userController
                                                  .user.objectId
                                                  .toString(),
                                              animation: cartController,
                                              idPedido: cartController
                                                  .pedidos[index].objectId);
                                        },
                                      );
                                    },
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(
                                          height: 10,
                                        ),
                                    itemCount: cartController.pedidos.length),
                              );
                            } else {
                              return SizedBox(
                                width: sizeWidth,
                                height: sizeHeigth / 1.5,
                                child: Center(
                                  child: cartController.pedidos.isEmpty
                                      ? Text(
                                          'Lista vazia',
                                          style: TextStyle(
                                              color: Colors.grey.shade400),
                                        )
                                      : Text(
                                          'Erro ao buscar pedidos',
                                          style: TextStyle(
                                              color: Colors.grey.shade400),
                                        ),
                                ),
                              );
                            }
                          }),

                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),

                  //Finalizar Pedido
                  Positioned(
                    bottom: 0,
                    child: SizedBox(
                      width: sizeWidth,
                      height: sizeHeigth * 0.21,
                      child: Column(
                        children: [
                          const Gap(10),
                          Container(
                            width: sizeWidth,
                            padding: const EdgeInsets.only(left: 20, right: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: CustomTextField(
                                    controller: cupomController,
                                    label: 'insira o cupom',
                                    borderRadius: 5,
                                  ),
                                ),
                                const Gap(2),
                                Material(
                                  child: InkWell(
                                    splashColor:
                                        const Color.fromARGB(53, 224, 224, 224),
                                    onTap: () {
                                      if (cupomController.text.isEmpty) {
                                        return utilsServices.showToast(
                                            message: 'Insira um cupom',
                                            isError: true);
                                      }
                                      adressController.identificarCupom(
                                          cupomId: cupomController.text);
                                      if (adressController
                                              .cupomIdentificado.valor ==
                                          0) {
                                        utilsServices.showToast(
                                            message: 'Cupom não encontrado',
                                            isError: true);
                                      } else {
                                        utilsServices.showToast(
                                            message: 'Cupom aplicado');
                                      }
                                      return;
                                    },
                                    child: Ink(
                                      width: sizeWidth / 3.7,
                                      height: sizeHeigth / 16,
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(
                                          5,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Aplicar',
                                          style: TextStyle(
                                            color: CustomColors.segundaryColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Gap(5),
                          AnimatedBuilder(
                            animation: cartController,
                            builder: (context, child) {
                              return Container(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 10),
                                width: sizeWidth,
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'SubTotal',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Text(
                                      utilsServices.priceToCurrency(
                                        cartController.calcularPrecoFinal(
                                            cartController.pedidos),
                                      ),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          const Gap(5),
                          AnimatedBuilder(
                            animation: cartController,
                            builder: (context, child) {
                              return Container(
                                width: sizeWidth,
                                padding:
                                    const EdgeInsets.only(left: 20, right: 10),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'TOTAL',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                    Text(
                                      utilsServices.priceToCurrency(
                                        cartController.calcularPrecoFinal(
                                            cartController.pedidos),
                                      ),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          const Gap(5),
                          Expanded(
                            child: SizedBox(
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: Material(
                                      child: InkWell(
                                        splashColor: const Color.fromARGB(
                                            53, 224, 224, 224),
                                        onTap: () {
                                          // if (cartController.pedidos.isEmpty) {
                                          //   utilsServices.showToast(
                                          //       message: 'Carrinho vazio',
                                          //       isError: true);
                                          //   return;
                                          // }

                                          Navigator.push(
                                            context,
                                            PageTransition(
                                              type: PageTransitionType
                                                  .leftToRight,
                                              child: const ConfirmOrder(),
                                            ),
                                          );
                                        },
                                        child: Ink(
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Center(
                                            child: Text(
                                              'Continuar',
                                              style: TextStyle(
                                                  color: CustomColors
                                                      .segundaryColor,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
