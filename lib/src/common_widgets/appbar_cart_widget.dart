import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:piu_vino/src/config/custom_colors.dart';

class AppBarCartWidget extends StatelessWidget {
  const AppBarCartWidget(
      {super.key, required this.titleAppBar, this.onPressed});
  final String titleAppBar;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.sizeOf(context).width;
    return SizedBox(
      width: sizeWidth,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          IconButton(
            onPressed: onPressed,
            icon: Icon(
              CupertinoIcons.chevron_left,
              color: CustomColors.primaryColor,
            ),
          ),
          Gap(sizeWidth * 0.002),
          Text(
            titleAppBar,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
          )
        ],
      ),
    );
  }
}
