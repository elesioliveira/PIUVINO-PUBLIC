import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:page_transition/page_transition.dart';
import 'package:piu_vino/src/config/custom_colors.dart';
import 'package:piu_vino/src/pages/confirm_order.dart/view/adress_info/adress_info.dart';

class BottomWidgetButtom extends StatelessWidget {
  const BottomWidgetButtom(
      {super.key, required this.title, this.thanIcon = false, this.iconButton});
  final String title;
  final bool thanIcon;
  final IconData? iconButton;

  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.sizeOf(context).width;
    double sizeHeight = MediaQuery.sizeOf(context).height;
    return Material(
      child: InkWell(
        splashColor: CustomColors.segundaryColor,
        onTap: () {
          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.leftToRight,
              child: UserAdressInfo(
                title: 'Endereço Novo',
                atualizarAdress: false,
                onTap: () {},
              ),
            ),
          );
        },
        child: Ink(
          color: Colors.white,
          width: sizeWidth,
          height: sizeHeight / 15,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                iconButton,
                color: CustomColors.primaryColor,
              ),
              const Gap(5),
              Text(
                title,
                style: TextStyle(
                    color: CustomColors.primaryColor,
                    fontWeight: FontWeight.w500),
              )
            ],
          ),
        ),
      ),
    );
  }
}
