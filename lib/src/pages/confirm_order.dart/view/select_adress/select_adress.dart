// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:piu_vino/src/common_widgets/buttom_widget.dart';
import 'package:piu_vino/src/common_widgets/custom_shimmer.dart';
import 'package:piu_vino/src/pages/auth/controller/auth_controller.dart';
import 'package:piu_vino/src/pages/confirm_order.dart/controller/adress_controller.dart';
import 'package:piu_vino/src/common_widgets/appbar_cart_widget.dart';
import 'package:piu_vino/src/pages/confirm_order.dart/view/select_adress/componentes/card_adress.dart';
import 'package:piu_vino/src/pages/cart/controller/pedido_controller.dart';
import 'package:piu_vino/src/providers/providers.dart';
import 'package:piu_vino/src/services/utils_services.dart';

class SelectAdressOrAddAdress extends StatefulWidget {
  const SelectAdressOrAddAdress({super.key});

  @override
  State<SelectAdressOrAddAdress> createState() =>
      _SelectAdressOrAddAdressState();
}

class _SelectAdressOrAddAdressState extends State<SelectAdressOrAddAdress> {
  CartController cartController = CartController();
  AuthController userController = AuthController();
  AdressController adressController = AdressController();
  final UtilsSerices utilsServices = UtilsSerices();
  int isSelect = 0;

  @override
  void initState() {
    super.initState();
    cartController = getIt<CartController>();
    userController = getIt<AuthController>();
    adressController = getIt<AdressController>();
  }

  @override
  Widget build(BuildContext context) {
    double sizeHeigth = MediaQuery.sizeOf(context).height;
    double sizeWidth = MediaQuery.sizeOf(context).width;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            AppBarCartWidget(
              titleAppBar: 'Seleção de endereço',
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            const Gap(10),
            Expanded(
              child: AnimatedBuilder(
                animation: adressController,
                builder: (context, child) {
                  if (adressController.adress.isNotEmpty) {
                    return ListView.separated(
                      itemBuilder: (context, index) {
                        return CardAdress(
                          isSelect: adressController.isSelect == index,
                          selectFunction: () {
                            adressController.atualizarAdressSelect(index);
                          },
                          adress: adressController.adress[index],
                          animation: adressController,
                          carregandoDelete:
                              adressController.isLoadingDeleteAdress,
                          onPressedDelete: () async {
                            adressController.showDialogAdressDeleteConfirm(
                                context: context,
                                animation: adressController,
                                idAdress: adressController
                                    .adress[index].objectId
                                    .toString(),
                                carregando:
                                    adressController.isLoadingDeleteAdress,
                                userId:
                                    userController.user.objectId.toString());
                          },
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const Gap(5);
                      },
                      itemCount: adressController.adress.length,
                    );
                  } else if (adressController.isLoading) {
                    return CustomShimmer(height: sizeHeigth, width: sizeWidth);
                  }
                  {
                    return Center(
                      child: Text(
                        'Nenhum endereço cadastrado',
                        style: TextStyle(color: Colors.grey.shade400),
                      ),
                    );
                  }
                },
              ),
            ),
            const BottomWidgetButtom(
              title: 'Adicione um novo Endereço',
              iconButton: CupertinoIcons.plus_circle,
            )
          ],
        ),
      ),
    );
  }
}
