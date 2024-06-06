// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:page_transition/page_transition.dart';
import 'package:piu_vino/src/config/custom_colors.dart';
import 'package:piu_vino/src/models/cart_mordel.dart';
import 'package:piu_vino/src/pages/auth/controller/auth_controller.dart';
import 'package:piu_vino/src/pages/confirm_order.dart/controller/adress_controller.dart';
import 'package:piu_vino/src/pages/cart/controller/pedido_controller.dart';
import 'package:piu_vino/src/pages/confirm_order.dart/view/finally_order/finally_order.dart';
import 'package:piu_vino/src/providers/providers.dart';
import 'package:piu_vino/src/services/utils_services.dart';

class ButtomWidget extends StatefulWidget {
  const ButtomWidget({super.key, required this.priceTotal});
  final double priceTotal;

  @override
  State<ButtomWidget> createState() => _ButtomWidgetState();
}

class _ButtomWidgetState extends State<ButtomWidget> {
  CartController cartController = CartController();
  AuthController controllerUser = AuthController();
  AdressController adressController = AdressController();
  final UtilsSerices utilsServices = UtilsSerices();

  @override
  void initState() {
    super.initState();
    cartController = getIt<CartController>();
    controllerUser = getIt<AuthController>();
    adressController = getIt<AdressController>();
  }

  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.sizeOf(context).width;
    double sizeHeigth = MediaQuery.sizeOf(context).height;

    return SizedBox(
      width: sizeWidth,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 10),
            child: const Row(
              children: [
                Icon(CupertinoIcons.square_list),
                Text('Detalhes de Pagamento')
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10),
            width: sizeWidth,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total dos Produtos',
                  style: TextStyle(
                      color: Colors.grey.shade600, fontWeight: FontWeight.w300),
                ),
                Text(
                  utilsServices.priceToCurrency(widget.priceTotal.toDouble()),
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10),
            width: sizeWidth,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total do Frete',
                  style: TextStyle(
                      color: Colors.grey.shade600, fontWeight: FontWeight.w300),
                ),
                AnimatedBuilder(
                  animation: adressController,
                  builder: (context, child) {
                    return Text(
                      utilsServices.priceToCurrency(
                          adressController.freteValor.toDouble()),
                    );
                  },
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10),
            width: sizeWidth,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Cupom de desconto',
                  style: TextStyle(
                      color: Colors.grey.shade600, fontWeight: FontWeight.w300),
                ),
                Text('${adressController.cupomIdentificado.valor}%')
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10),
            width: sizeWidth,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Pagamento Total',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                AnimatedBuilder(
                  animation: adressController,
                  builder: (context, child) {
                    return Text(
                      utilsServices.priceToCurrency(
                          adressController.calcularPreco(widget.priceTotal,
                                  adressController.cupomIdentificado.valor) +
                              adressController.freteValor),
                    );
                  },
                ),
              ],
            ),
          ),
          const Gap(10),

          //finalizar
          Container(
            padding: const EdgeInsets.only(left: 10),
            width: sizeWidth,
            height: sizeHeigth * 0.06,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Pagamento Total',
                          style: TextStyle(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w300),
                        ),
                        AnimatedBuilder(
                          animation: adressController,
                          builder: (context, builder) {
                            return Text(
                              utilsServices.priceToCurrency(
                                  adressController.calcularPreco(
                                          widget.priceTotal,
                                          adressController
                                              .cupomIdentificado.valor) +
                                      adressController.freteValor),
                              style: TextStyle(
                                  color: CustomColors.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const Gap(5),
                Material(
                  child: InkWell(
                    splashColor: CustomColors.segundaryColor,
                    onTap: cartController.isLoading
                        ? null
                        : () async {
                            for (Pedido item in cartController.pedidos) {
                              await cartController.attItemIntoCart(
                                  idCart: item.objectId.toString(),
                                  confirmado: true,
                                  quantidade: item.quantidade);
                            }
                            await cartController.buscarPedido(
                                idUser:
                                    controllerUser.user.objectId.toString());

                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.leftToRight,
                                child: const FinalOrder(),
                              ),
                            );
                          },
                    child: Ink(
                      height: sizeHeigth,
                      padding: const EdgeInsets.all(10),
                      decoration:
                          BoxDecoration(color: CustomColors.primaryColor),
                      child: const Center(
                        child: Text(
                          'FAZER PEDIDO',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
