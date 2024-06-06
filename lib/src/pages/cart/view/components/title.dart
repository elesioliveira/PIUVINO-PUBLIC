import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TitleCartScreen extends StatelessWidget {
  const TitleCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.sizeOf(context).width;
    double sizeHeigth = MediaQuery.sizeOf(context).height;
    return SizedBox(
      width: sizeWidth,
      height: sizeHeigth * 0.05,
      child: Stack(
        children: [
          Positioned(
            left: 25,
            height: sizeHeigth * 0.05,
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(CupertinoIcons.back),
            ),
          ),
          Positioned(
            child: SizedBox(
              width: sizeWidth,
              height: sizeHeigth * 0.07,
              child: const Center(
                child: Text(
                  'Carrinho',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 20),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
