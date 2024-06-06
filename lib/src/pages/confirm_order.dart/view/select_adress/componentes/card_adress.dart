// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:page_transition/page_transition.dart';
import 'package:piu_vino/src/config/custom_colors.dart';
import 'package:piu_vino/src/models/user_adress.dart';
import 'package:piu_vino/src/pages/confirm_order.dart/controller/adress_controller.dart';
import 'package:piu_vino/src/pages/confirm_order.dart/view/adress_info/adress_info.dart';
import 'package:piu_vino/src/providers/providers.dart';

class CardAdress extends StatefulWidget {
  CardAdress(
      {super.key,
      required this.adress,
      required this.carregandoDelete,
      required this.animation,
      this.onPressedDelete,
      this.isSelect = false,
      required this.selectFunction});
  final AdressModel adress;
  final bool carregandoDelete;
  final Listenable animation;
  final Function()? onPressedDelete;
  final Function()? selectFunction;
  bool isSelect;

  @override
  State<CardAdress> createState() => _CardAdressState();
}

class _CardAdressState extends State<CardAdress> {
  AdressController adressController = AdressController();

  @override
  void initState() {
    super.initState();
    adressController = getIt<AdressController>();
  }

  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.sizeOf(context).width;
    return AnimatedBuilder(
      animation: adressController,
      builder: (context, child) {
        return Container(
          height: 100,
          width: sizeWidth,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 2,
                offset: const Offset(0, 8), // move a sombra para baixo
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5, top: 10),
                child: GestureDetector(
                  onTap: widget.selectFunction,
                  child: Container(
                    decoration: BoxDecoration(
                      color: widget.isSelect
                          ? CustomColors.primaryColor
                          : Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: widget.isSelect
                            ? Colors.transparent
                            : CustomColors.segundaryColor,
                        width: 1.5, // Largura da borda
                      ),
                    ),
                    height: 20,
                    width: 20,
                    child: widget.isSelect
                        ? const Center(
                            child: Icon(
                              size: 15,
                              CupertinoIcons.checkmark_alt,
                              color: Colors.white,
                            ),
                          )
                        : null,
                  ),
                ),
              ),
              const Gap(5),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.adress.nomeCompleto.toUpperCase(),
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400),
                            ),
                            const Gap(5),
                            const Text(' | '),
                            Text(
                              widget.adress.telefone.toUpperCase(),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                            const Gap(5),
                          ],
                        ),
                      ),
                      SizedBox(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${widget.adress.logradouro}, ${widget.adress.numero}, ${widget.adress.referencia}'
                                  .toUpperCase(),
                              style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              '${widget.adress.cidade}, ${widget.adress.uf}'
                                  .toUpperCase(),
                              style: TextStyle(
                                  color: Colors.grey.shade900,
                                  fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Material(
                        child: InkWell(
                          splashColor: CustomColors.white,
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.leftToRight,
                                child: UserAdressInfo(
                                  atualizarAdress: true,
                                  onTap: () {},
                                  title: 'Editar Cadastro',
                                  adress: widget.adress,
                                ),
                              ),
                            );
                          },
                          child: Ink(
                            width: 40,
                            decoration: BoxDecoration(
                              color: CustomColors.primaryColor,
                            ),
                            child: const Center(
                              child: Icon(
                                CupertinoIcons.pencil,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Material(
                        child: InkWell(
                          splashColor: CustomColors.white,
                          onTap: widget.onPressedDelete,
                          child: Ink(
                            width: 40,
                            decoration: BoxDecoration(
                              color: CustomColors.segundaryColor,
                            ),
                            child: const Center(
                              child: Icon(
                                CupertinoIcons.delete,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
