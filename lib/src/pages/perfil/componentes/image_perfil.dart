import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:piu_vino/src/config/custom_colors.dart';

class UserImage extends StatelessWidget {
  const UserImage({super.key});

  @override
  Widget build(BuildContext context) {
    double sizeHeight = MediaQuery.sizeOf(context).height;
    double sizeWidth = MediaQuery.sizeOf(context).width;
    return Container(
      height: sizeHeight / 3.1,
      width: sizeWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // move a sombra para baixo
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.7,
              child: Image.asset(
                'assets/app_images/eu.PNG',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: sizeWidth * 0.3,
                    height: sizeHeight * 0.15,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          width: 2, color: CustomColors.primaryColor),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Image.asset(
                        'assets/app_images/eu.PNG',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Align(
                    alignment: const Alignment(0.30, 0.44),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: CustomColors.primaryColor,
                        border: Border.all(
                            width: 1, color: CustomColors.primaryColor),
                      ),
                      padding: const EdgeInsets.all(5),
                      child: Material(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          splashColor: CustomColors.primaryColor,
                          onTap: () {},
                          child: Ink(
                            child: Icon(
                              color: CustomColors.neutroColor,
                              CupertinoIcons.camera,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: sizeHeight * 0.03,
            child: SizedBox(
              width: sizeWidth,
              child: Center(
                child: Text(
                  'Elesio Oliveira',
                  style: TextStyle(
                      color: CustomColors.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 22),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
