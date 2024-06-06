import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:piu_vino/src/config/custom_colors.dart';
import 'package:piu_vino/src/pages/cart/controller/pedido_controller.dart';
import 'package:piu_vino/src/pages/cart/view/cart_tab.dart';
import 'package:piu_vino/src/providers/providers.dart';

class AppBarBaseScreen extends StatefulWidget {
  const AppBarBaseScreen({super.key, this.opacityIsTrue = true});
  final bool opacityIsTrue;

  @override
  State<AppBarBaseScreen> createState() => _AppBarBaseScreenState();
}

class _AppBarBaseScreenState extends State<AppBarBaseScreen> {
  CartController cartController = CartController();

  @override
  void initState() {
    super.initState();
    cartController = getIt<CartController>();
  }

  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.sizeOf(context).width;
    return SizedBox(
      width: sizeWidth,
      child: Stack(
        children: [
          Center(
            child: RichText(
              text: TextSpan(
                text: 'Piú',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: CustomColors.primaryColor,
                  fontSize: 26,
                ),
                children: [
                  TextSpan(
                    text: 'vino',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: CustomColors.segundaryColor,
                      fontSize: 26,
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            right: 10,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.fade,
                      duration: const Duration(milliseconds: 700),
                      child: const PedidoTab(),
                    ),
                  );
                },
                child: Opacity(
                  opacity: widget.opacityIsTrue ? 0 : 1,
                  child: AnimatedBuilder(
                    animation: cartController,
                    builder: (context, child) {
                      return Badge(
                        backgroundColor: CustomColors.primaryColor,
                        isLabelVisible:
                            cartController.pedidos.isEmpty ? false : true,
                        label: Text(cartController.pedidos.length.toString()),
                        alignment: Alignment.topRight,
                        smallSize: 25,
                        largeSize: 15,
                        child: Icon(
                          CupertinoIcons.cart,
                          color: CustomColors.primaryColor,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
