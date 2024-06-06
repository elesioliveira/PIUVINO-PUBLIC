// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:piu_vino/src/common_widgets/quantity_widget.dart';
import 'package:piu_vino/src/config/custom_colors.dart';
import 'package:piu_vino/src/services/utils_services.dart';

class ItemCart extends StatefulWidget {
  ItemCart(
      {super.key,
      required this.nomeItem,
      required this.precoItem,
      required this.quantidade,
      required this.onTap,
      required this.result});
  final String nomeItem;
  final num precoItem;
  num quantidade;
  final Function()? onTap;
  final dynamic Function(int) result;

  @override
  State<ItemCart> createState() => _ItemCartState();
}

class _ItemCartState extends State<ItemCart> {
  final UtilsSerices utilsServices = UtilsSerices();

  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.sizeOf(context).width;
    double sizeHeigth = MediaQuery.sizeOf(context).height;
    return Container(
      width: sizeWidth,
      height: sizeHeigth * 0.11,
      padding: const EdgeInsets.only(
        left: 15,
        right: 5,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            elevation: 1,
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
            clipBehavior: Clip.antiAlias,
            child: Image.asset(
              'assets/app_images/garrafa.png',
              fit: BoxFit.cover,
            ),
          ),
          Gap(sizeWidth * 0.05),
          SizedBox(
            width: sizeWidth / 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: sizeWidth / 1.8,
                  child: Text(
                    widget.nomeItem.toUpperCase(),
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                        fontSize: 15),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    utilsServices.priceToCurrency(
                      widget.precoItem.toDouble(),
                    ),
                    style: TextStyle(
                        color: CustomColors.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                )
              ],
            ),
          ),
          // Gap(sizeWidth * 0.19),
          SizedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: [
                GestureDetector(
                  onTap: widget.onTap,
                  child: const Icon(
                    CupertinoIcons.delete,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: QuantityWidget(
                    value: widget.quantidade.toInt(),
                    result: widget.result,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
