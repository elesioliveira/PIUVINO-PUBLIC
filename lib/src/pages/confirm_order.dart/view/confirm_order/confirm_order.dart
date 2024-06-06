import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:piu_vino/src/pages/auth/controller/auth_controller.dart';
import 'package:piu_vino/src/pages/confirm_order.dart/controller/adress_controller.dart';
import 'package:piu_vino/src/common_widgets/appbar_cart_widget.dart';
import 'package:piu_vino/src/pages/confirm_order.dart/view/confirm_order/componentes/buttom_widget.dart';
import 'package:piu_vino/src/pages/confirm_order.dart/view/confirm_order/componentes/confirm_adress.dart';
import 'package:piu_vino/src/pages/confirm_order.dart/view/confirm_order/componentes/confirm_frete_price.dart';
import 'package:piu_vino/src/pages/confirm_order.dart/view/confirm_order/componentes/mensagem_observacao.dart';
import 'package:piu_vino/src/pages/confirm_order.dart/view/confirm_order/componentes/metodo_pagamento_widget.dart';
import 'package:piu_vino/src/pages/confirm_order.dart/view/confirm_order/componentes/total_do_pedido_widget.dart';
import 'package:piu_vino/src/pages/cart/controller/pedido_controller.dart';

import 'package:piu_vino/src/providers/providers.dart';
import 'package:piu_vino/src/services/utils_services.dart';

class ConfirmOrder extends StatefulWidget {
  const ConfirmOrder({super.key});

  @override
  State<ConfirmOrder> createState() => _ConfirmOrderState();
}

class _ConfirmOrderState extends State<ConfirmOrder> {
  AdressController adressController = AdressController();
  AuthController userController = AuthController();
  CartController cartController = CartController();
  final UtilsSerices utilsServices = UtilsSerices();

  @override
  void initState() {
    super.initState();
    adressController = getIt<AdressController>();
    userController = getIt<AuthController>();
    cartController = getIt<CartController>();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Positioned(
              top: 0,
              child: SizedBox(
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      AppBarCartWidget(
                        titleAppBar: 'Comprar',
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      const Gap(10),
                      const ConfirmAdress(),
                      const Gap(5),
                      const ConfirmFrete(),
                      const Gap(10),
                      const MensagemDeObersavacao(),
                      const Gap(10),
                      TotalDoPedido(
                        priceTotal: cartController
                            .calcularPrecoFinal(cartController.pedidos),
                      ),
                      const Gap(10),
                      const MetodoPagamento(),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: ButtomWidget(
                  priceTotal: cartController
                      .calcularPrecoFinal(cartController.pedidos)),
            )
          ],
        ),
      ),
    );
  }
}
