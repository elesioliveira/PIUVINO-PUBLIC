import 'package:flutter/cupertino.dart';
import 'package:gap/gap.dart';
import 'package:piu_vino/src/config/custom_colors.dart';
import 'package:piu_vino/src/pages/confirm_order.dart/view/confirm_order/componentes/drop_buttom_widget.dart';

class MetodoPagamento extends StatefulWidget {
  const MetodoPagamento({super.key});

  @override
  State<MetodoPagamento> createState() => _MetodoPagamentoState();
}

List<String> listPayment = <String>['Pix', 'Cartão', 'Dinheiro'];
String dropdownValue = listPayment.first;

class _MetodoPagamentoState extends State<MetodoPagamento> {
  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.sizeOf(context).width;
    double sizeHeigth = MediaQuery.sizeOf(context).height;
    return Container(
      height: sizeHeigth / 15,
      padding: const EdgeInsets.only(left: 10, right: 10),
      width: sizeWidth,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            child: Row(
              children: [
                Icon(
                  CupertinoIcons.money_dollar_circle,
                  color: CustomColors.primaryColor,
                ),
                const Gap(2),
                const Text('Método de Pagamento'),
              ],
            ),
          ),
          SizedBox(
            child: DropdownMenuExample(
              listPayment: listPayment,
              onSelected: (String? value) {
                setState(() {
                  dropdownValue = value!;
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
