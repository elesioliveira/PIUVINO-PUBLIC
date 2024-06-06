import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:piu_vino/src/config/custom_colors.dart';
import 'package:piu_vino/src/pages/confirm_order.dart/controller/adress_controller.dart';
import 'package:piu_vino/src/providers/providers.dart';
import 'package:piu_vino/src/services/utils_services.dart';

class ConfirmFrete extends StatefulWidget {
  const ConfirmFrete({super.key});

  @override
  State<ConfirmFrete> createState() => _ConfirmFreteState();
}

class _ConfirmFreteState extends State<ConfirmFrete> {
  AdressController adressController = AdressController();
  final UtilsSerices utilsServices = UtilsSerices();

  @override
  void initState() {
    super.initState();
    adressController = getIt<AdressController>();
    adressController.feacthFrete();
  }

  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.sizeOf(context).width;
    double sizeHeight = MediaQuery.sizeOf(context).height;
    return SizedBox(
      width: sizeWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Gap(5),
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
              color: const Color.fromARGB(44, 233, 30, 98),
              border:
                  Border.all(width: 0.7, color: CustomColors.segundaryColor),
            ),
            width: sizeWidth,
            height: sizeHeight * 0.25,
            child: Column(
              children: [
                SizedBox(
                  child: Text(
                    'Opções de envio',
                    style: TextStyle(color: CustomColors.segundaryColor),
                  ),
                ),
                const Gap(10),
                AnimatedBuilder(
                  animation: adressController,
                  builder: (context, child) {
                    return Expanded(
                      child: ListView.separated(
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            return Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          adressController.fretes[index].cidade,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          utilsServices.priceToCurrency(
                                            adressController.fretes[index].preco
                                                .toDouble(),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            const Gap(5),
                                            GestureDetector(
                                              onTap: () {
                                                adressController.setValorFrete =
                                                    index;
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: adressController
                                                              .valorFrete ==
                                                          index
                                                      ? CustomColors
                                                          .primaryColor
                                                      : Colors.transparent,
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: adressController
                                                                .valorFrete ==
                                                            index
                                                        ? Colors.transparent
                                                        : CustomColors
                                                            .segundaryColor,
                                                    width:
                                                        0.8, // Largura da borda
                                                  ),
                                                ),
                                                height: 20,
                                                width: 20,
                                                child: adressController
                                                            .valorFrete ==
                                                        index
                                                    ? const Center(
                                                        child: Icon(
                                                          size: 15,
                                                          CupertinoIcons
                                                              .checkmark_alt,
                                                          color: Colors.white,
                                                        ),
                                                      )
                                                    : null,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const Gap(10);
                          },
                          itemCount: adressController.fretes.length),
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
