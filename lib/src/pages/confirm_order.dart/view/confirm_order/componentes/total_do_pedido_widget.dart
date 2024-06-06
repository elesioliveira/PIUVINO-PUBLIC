import 'package:flutter/material.dart';
import 'package:piu_vino/src/common_widgets/custom_shimmer.dart';
import 'package:piu_vino/src/config/custom_colors.dart';
import 'package:piu_vino/src/pages/confirm_order.dart/controller/adress_controller.dart';
import 'package:piu_vino/src/providers/providers.dart';
import 'package:piu_vino/src/services/utils_services.dart';

class TotalDoPedido extends StatefulWidget {
  const TotalDoPedido({super.key, required this.priceTotal});
  final double priceTotal;

  @override
  State<TotalDoPedido> createState() => _TotalDoPedidoState();
}

class _TotalDoPedidoState extends State<TotalDoPedido> {
  final UtilsSerices utilsServices = UtilsSerices();
  AdressController adressController = AdressController();

  @override
  void initState() {
    super.initState();
    adressController = getIt<AdressController>();
  }

  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.sizeOf(context).width;
    double sizeHeigth = MediaQuery.sizeOf(context).height;
    return AnimatedBuilder(
      animation: adressController,
      builder: (context, child) {
        return Container(
          height: sizeHeigth / 15,
          padding: const EdgeInsets.only(left: 10, right: 10),
          width: sizeWidth,
          child: adressController.isLoading
              ? CustomShimmer(height: sizeHeigth / 15, width: sizeWidth)
              : Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total do pedido:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      utilsServices
                          .priceToCurrency(widget.priceTotal.toDouble()),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: CustomColors.primaryColor),
                    )
                  ],
                ),
        );
      },
    );
  }
}
