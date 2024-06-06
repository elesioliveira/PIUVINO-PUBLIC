import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:piu_vino/src/config/custom_colors.dart';

class NewAdressButtom extends StatefulWidget {
  const NewAdressButtom({super.key, this.onTap, this.carregando = false});
  final Function()? onTap;
  final bool carregando;
  @override
  State<NewAdressButtom> createState() => _NewAdressButtomState();
}

class _NewAdressButtomState extends State<NewAdressButtom> {
  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.sizeOf(context).width;
    double sizeHeight = MediaQuery.sizeOf(context).height;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: CustomColors.segundaryColor,
        onTap: widget.onTap,
        child: Ink(
          color: widget.carregando ? Colors.grey : CustomColors.primaryColor,
          width: sizeWidth,
          height: sizeHeight / 15,
          child: widget.carregando
              ? const Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(3.0),
                      child: CupertinoActivityIndicator(),
                    )
                  ],
                )
              : Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Salvar',
                      style: TextStyle(
                          color: Colors.grey.shade400,
                          fontWeight: FontWeight.w500,
                          fontSize: 15),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
