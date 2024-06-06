import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:piu_vino/src/pages/order/componentes/app_bar_order_widget.dart';
import 'package:piu_vino/src/pages/order/componentes/item_order.dart';

class OrderUser extends StatelessWidget {
  const OrderUser({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            AppBarOrder(),
            Gap(10),
            Expanded(child: ItemOrder()),
          ],
        ),
      ),
    );
  }
}
