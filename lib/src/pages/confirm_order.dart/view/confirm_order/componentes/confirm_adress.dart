import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:page_transition/page_transition.dart';
import 'package:piu_vino/src/common_widgets/custom_shimmer.dart';
import 'package:piu_vino/src/config/custom_colors.dart';
import 'package:piu_vino/src/pages/auth/controller/auth_controller.dart';
import 'package:piu_vino/src/pages/confirm_order.dart/controller/adress_controller.dart';
import 'package:piu_vino/src/pages/confirm_order.dart/view/select_adress/select_adress.dart';
import 'package:piu_vino/src/pages/cart/controller/pedido_controller.dart';
import 'package:piu_vino/src/providers/providers.dart';
import 'package:piu_vino/src/services/utils_services.dart';

class ConfirmAdress extends StatefulWidget {
  const ConfirmAdress({super.key});

  @override
  State<ConfirmAdress> createState() => _ConfirmAdressState();
}

class _ConfirmAdressState extends State<ConfirmAdress> {
  CartController cartController = CartController();
  AuthController userController = AuthController();
  AdressController adressController = AdressController();
  final UtilsSerices utilsServices = UtilsSerices();

  @override
  void initState() {
    super.initState();
    cartController = getIt<CartController>();
    userController = getIt<AuthController>();
    adressController = getIt<AdressController>();
    cartController.calcularPrecoFinal(cartController.pedidos);
  }

  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.sizeOf(context).width;
    double sizeHeigth = MediaQuery.sizeOf(context).height;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.leftToRight,
            child: const SelectAdressOrAddAdress(),
          ),
        );
      },
      child: AnimatedBuilder(
        animation: adressController,
        builder: (context, _) {
          return SizedBox(
            width: sizeWidth,
            height: sizeHeigth / 9,
            child: adressController.isLoading
                ? CustomShimmer(
                    height: sizeHeigth / 9,
                    width: sizeWidth,
                    borderRadius: BorderRadius.circular(20),
                  )
                : AnimatedBuilder(
                    animation: adressController,
                    builder: (context, builder) {
                      if (adressController.adress.isNotEmpty) {
                        return Stack(
                          children: [
                            Positioned(
                              top: 2,
                              left: 3,
                              child: Icon(
                                CupertinoIcons.map_pin,
                                color: CustomColors.primaryColor,
                              ),
                            ),
                            Positioned(
                              top: 2,
                              left: 35,
                              child: SizedBox(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    const Text(
                                      'Endereço de entrega',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Gap(5),
                                    Text(
                                      '${adressController.adress[adressController.isSelect].nomeCompleto} | ${adressController.adress[adressController.isSelect].telefone}'
                                          .toUpperCase(),
                                      style: TextStyle(
                                          color: Colors.grey.shade500),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                        '${adressController.adress[adressController.isSelect].logradouro}, ${adressController.adress[adressController.isSelect].numero}, ${adressController.adress[adressController.isSelect].referencia}'
                                            .toUpperCase(),
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Colors.grey.shade500)),
                                    Text(
                                        '${adressController.adress[adressController.isSelect].cidade}, ${adressController.adress[adressController.isSelect].uf}, ${adressController.adress[adressController.isSelect].cep}'
                                            .toUpperCase(),
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Colors.grey.shade500))
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              right: 2,
                              height: sizeHeigth / 9,
                              child: Icon(
                                CupertinoIcons.forward,
                                color: Colors.grey.shade300,
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Stack(
                          children: [
                            Center(
                              child: Text(
                                'Nenhum endereço cadastrado',
                                style: TextStyle(color: Colors.grey.shade500),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              height: sizeHeigth / 9,
                              child: Icon(
                                CupertinoIcons.forward,
                                color: Colors.grey.shade300,
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
          );
        },
      ),
    );
  }
}
