import 'package:flutter/material.dart';

class MensagemDeObersavacao extends StatelessWidget {
  const MensagemDeObersavacao({super.key});

  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.sizeOf(context).width;
    double sizeHeigth = MediaQuery.sizeOf(context).height;
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      width: sizeWidth,
      height: sizeHeigth / 20,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('Mensagem de observação: '),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Digite aqui',
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
