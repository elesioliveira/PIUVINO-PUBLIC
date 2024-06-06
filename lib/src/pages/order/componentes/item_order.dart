import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:piu_vino/src/common_widgets/custom_shimmer.dart';
import 'package:piu_vino/src/pages/auth/controller/auth_controller.dart';
import 'package:piu_vino/src/pages/order/controller/order_controller.dart';
import 'package:piu_vino/src/providers/providers.dart';
import 'package:piu_vino/src/services/utils_services.dart';

class ItemOrder extends StatefulWidget {
  const ItemOrder({super.key});

  @override
  State<ItemOrder> createState() => _ItemOrderState();
}

class _ItemOrderState extends State<ItemOrder> {
  OrderController orderController = OrderController();
  AuthController userController = AuthController();
  final UtilsSerices utilsServices = UtilsSerices();

  @override
  void initState() {
    super.initState();
    orderController = getIt<OrderController>();
    userController = getIt<AuthController>();
  }

  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.sizeOf(context).width;
    return AnimatedBuilder(
      animation: orderController,
      builder: ((context, child) {
        if (orderController.isLoading == true) {
          return const CustomShimmer(
            height: double.infinity,
            width: double.infinity,
          );
        }
        if (orderController.order.isNotEmpty) {
          return RefreshIndicator(
            onRefresh: () async {
              await orderController.getAllOrders(
                  canLoad: true,
                  idUser: userController.user.objectId.toString());
            },
            child: ListView.separated(
                padding: const EdgeInsets.only(left: 5, right: 5),
                itemBuilder: (contex, index) {
                  if (((index + 1) == orderController.ultimaRequisicao) &&
                      !orderController.isLastPage) {
                    orderController.loadMoreProducts(
                        idUser: userController.user.objectId.toString());
                  }
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 0.5,
                        color: Colors.grey.shade400,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    width: sizeWidth,
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/app_images/garrafa.png',
                          scale: 6,
                        ),
                        const Gap(10),
                        Expanded(
                          child: SizedBox(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    text: 'Pedido:',
                                    style:
                                        TextStyle(color: Colors.grey.shade400),
                                    children: [
                                      TextSpan(
                                          text:
                                              ' ${orderController.order[index].objectId.toString()}',
                                          style: TextStyle(
                                              color: Colors.grey.shade400)),
                                      const TextSpan(text: ' - '),
                                      const TextSpan(
                                        text: '21/05/2024',
                                      )
                                    ],
                                  ),
                                ),
                                const Gap(5),
                                Text(
                                  orderController.order[index].produto.nome,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500),
                                ),
                                const Gap(5),
                                RichText(
                                  text: TextSpan(
                                    text: 'Quantidade:',
                                    style:
                                        TextStyle(color: Colors.grey.shade400),
                                    children: [
                                      TextSpan(
                                        text:
                                            ' ${orderController.order[index].quantidade}',
                                      ),
                                    ],
                                  ),
                                ),
                                const Gap(5),
                                SizedBox(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          text: 'Valor un:',
                                          style: TextStyle(
                                              color: Colors.grey.shade400),
                                          children: [
                                            TextSpan(
                                              text:
                                                  utilsServices.priceToCurrency(
                                                orderController
                                                    .order[index].price
                                                    .toDouble(),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 5),
                                        child: RichText(
                                          text: TextSpan(
                                            text: 'Valor Total:',
                                            style: TextStyle(
                                                color: Colors.grey.shade400),
                                            children: [
                                              TextSpan(
                                                text: utilsServices
                                                    .priceToCurrency(
                                                  orderController
                                                          .order[index].price
                                                          .toDouble() *
                                                      orderController
                                                          .order[index]
                                                          .quantidade
                                                          .toDouble(),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, _) {
                  return const Gap(5);
                },
                itemCount: orderController.order.length),
          );
        } else {
          return Center(
            child: Text(
              'Sem histórico de compras',
              style: TextStyle(color: Colors.grey.shade500),
            ),
          );
        }
      }),
    );
  }
}
