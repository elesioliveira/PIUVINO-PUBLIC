import 'package:flutter/material.dart';
import 'package:piu_vino/src/config/custom_colors.dart';

class AppBarOrder extends StatelessWidget {
  const AppBarOrder({super.key});

  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.sizeOf(context).width;
    double sizeHeight = MediaQuery.sizeOf(context).height;
    return Container(
      height: sizeHeight * 0.08,
      decoration: BoxDecoration(color: CustomColors.primaryColor, boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 5,
          blurRadius: 7,
          offset: const Offset(0, 3), // move a sombra para baixo
        ),
      ]),
      width: sizeWidth,
      child: const Center(
        child: Text(
          'Últimos pedidos',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 18,
              shadows: [
                BoxShadow(
                  color: Color.fromARGB(27, 255, 255, 255),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // move a sombra para baixo
                ),
              ]),
        ),
      ),
    );
  }
}
