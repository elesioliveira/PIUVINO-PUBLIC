import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:piu_vino/src/common_widgets/appbar_base_screen.dart';
import 'package:piu_vino/src/config/custom_colors.dart';
import 'package:piu_vino/src/pages/confirm_order.dart/controller/adress_controller.dart';
import 'package:piu_vino/src/providers/providers.dart';

class FinalOrder extends StatefulWidget {
  const FinalOrder({super.key});

  @override
  State<FinalOrder> createState() => _FinalOrderState();
}

class _FinalOrderState extends State<FinalOrder> {
  AdressController adressControler = AdressController();

  @override
  void initState() {
    super.initState();
    adressControler = getIt<AdressController>();
    adressControler.updateTimerFinallOrder(context);
  }

  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.sizeOf(context).width;
    double sizeHeigth = MediaQuery.sizeOf(context).height;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            const Positioned(
              top: 0,
              child: AppBarBaseScreen(),
            ),
            Center(
              child: SizedBox(
                width: sizeWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: sizeWidth,
                      child: Icon(
                        size: sizeWidth * 0.3,
                        CupertinoIcons.checkmark_seal_fill,
                        color: Colors.green.shade800,
                      ),
                    ),
                    Text(
                      'Recebemos',
                      style: TextStyle(
                          color: Colors.green.shade800,
                          fontWeight: FontWeight.bold,
                          fontSize: 35),
                    ),
                    Text(
                      'o seu pedido!',
                      style: TextStyle(
                          color: Colors.green.shade800,
                          fontWeight: FontWeight.bold,
                          fontSize: 35),
                    ),
                    SizedBox(
                      height: sizeHeigth * 0.02,
                    ),
                    const Text('Você receberá uma mensagem no whatssapp'),
                    Text(
                        '${adressControler.adress[adressControler.isSelect].telefone} com todos detalhes')
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 80,
              child: SizedBox(
                width: sizeWidth,
                child: Align(
                  alignment: Alignment.center,
                  child: AnimatedBuilder(
                    animation: adressControler,
                    builder: (context, child) {
                      return Text(
                        adressControler.timerText,
                        style: TextStyle(
                            fontSize: 40,
                            color: CustomColors.primaryColor,
                            fontWeight: FontWeight.bold),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
