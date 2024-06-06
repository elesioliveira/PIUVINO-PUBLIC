// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:piu_vino/src/common_widgets/appbar_base_screen.dart';
import 'package:piu_vino/src/common_widgets/custom_text_field.dart';
import 'package:piu_vino/src/config/custom_colors.dart';
import 'package:piu_vino/src/pages/auth/controller/auth_controller.dart';
import 'package:piu_vino/src/providers/providers.dart';
import 'package:piu_vino/src/services/validators.dart';

class UpdateUserInfo extends StatefulWidget {
  const UpdateUserInfo({super.key});

  @override
  State<UpdateUserInfo> createState() => _UpdateUserInfoState();
}

class _UpdateUserInfoState extends State<UpdateUserInfo> {
  AuthController userController = AuthController();
  late TextEditingController userName;
  late TextEditingController email;
  late TextEditingController nomeCompleto;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    userController = getIt<AuthController>();
    userName = TextEditingController(text: userController.user.username ?? '');
    email = TextEditingController(text: userController.user.email ?? '');
    nomeCompleto =
        TextEditingController(text: userController.user.nomeCompleto ?? '');
  }

  @override
  Widget build(BuildContext context) {
    double sizeHeigth = MediaQuery.sizeOf(context).height;
    double sizeWidth = MediaQuery.sizeOf(context).width;

    return SafeArea(
        child: Scaffold(
      body: Stack(
        children: [
          const Positioned(
            top: 15,
            child: Center(
              child: AppBarBaseScreen(),
            ),
          ),
          Positioned(
            top: 15,
            left: 25,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Icon(
                size: 25,
                CupertinoIcons.chevron_left,
                color: CustomColors.primaryColor,
              ),
            ),
          ),

          //corpo formulário
          Container(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomTextField(
                    label: 'user name',
                    controller: userName,
                    validator: userValidator,
                  ),
                  SizedBox(height: sizeHeigth * 0.02),
                  CustomTextField(
                    label: 'email',
                    controller: email,
                    validator: emailValidator,
                  ),
                  SizedBox(height: sizeHeigth * 0.02),
                  CustomTextField(
                    label: 'nome completo',
                    controller: nomeCompleto,
                    validator: nameValidator,
                  ),
                  SizedBox(height: sizeHeigth * 0.02),
                ],
              ),
            ),
          ),

          //butão atualizar
          Positioned(
            bottom: 0,
            child: AnimatedBuilder(
              animation: userController,
              builder: (context, builder) {
                return Material(
                  child: InkWell(
                    splashColor: CustomColors.segundaryColor,
                    onTap: () async {
                      FocusScope.of(context).unfocus();
                      if (_formKey.currentState!.validate()) {
                        await userController.updateUser(
                            userName: userName.text,
                            email: email.text,
                            nomeCompleto: nomeCompleto.text);

                        Navigator.of(context).pop();
                      }
                    },
                    child: Ink(
                      color: Colors.white,
                      width: sizeWidth,
                      height: sizeHeigth / 15,
                      child: userController.isLoading
                          ? const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [CupertinoActivityIndicator()],
                            )
                          : Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  CupertinoIcons.person_alt_circle_fill,
                                  color: CustomColors.primaryColor,
                                ),
                                const Gap(5),
                                Text(
                                  'Atualizar',
                                  style: TextStyle(
                                      color: CustomColors.primaryColor,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ));
  }
}
