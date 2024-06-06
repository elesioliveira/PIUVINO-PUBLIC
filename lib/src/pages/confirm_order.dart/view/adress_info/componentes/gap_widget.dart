import 'package:flutter/material.dart';

class GapWidget extends StatelessWidget {
  const GapWidget({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.sizeOf(context).width;
    return Container(
      padding: const EdgeInsets.only(left: 10, top: 10),
      height: 30,
      width: sizeWidth,
      child: Text(title),
    );
  }
}
