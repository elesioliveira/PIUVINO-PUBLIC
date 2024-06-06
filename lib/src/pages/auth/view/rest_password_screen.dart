// ignore_for_file: use_build_context_synchronously, unused_element

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:piu_vino/src/common_widgets/custom_text_field.dart';
import 'package:piu_vino/src/config/custom_colors.dart';
import 'package:piu_vino/src/pages/auth/controller/auth_controller.dart';
import 'package:piu_vino/src/providers/providers.dart';
import 'package:piu_vino/src/services/validators.dart';

class RestPasswordScreen extends StatefulWidget {
  const RestPasswordScreen({super.key});

  @override
  State<RestPasswordScreen> createState() => _RestPasswordScreenState();
}

class _RestPasswordScreenState extends State<RestPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    double sizeWidth = MediaQuery.sizeOf(context).width;
    double sizeHeight = MediaQuery.sizeOf(context).height;
    TextEditingController restPassword = TextEditingController();
    AuthController controller = AuthController();

    @override
    void initState() {
      super.initState();
      controller = getIt<AuthController>();
    }

    @override
    void dispose() {
      restPassword.dispose();
      super.dispose();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(CupertinoIcons.back),
        ),
      ),
      body: SizedBox(
        width: sizeWidth,
        child: Center(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: sizeWidth,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                    child: CustomTextField(
                      controller: restPassword,
                      validator: emailValidator,
                      label: 'Informe seu Email',
                    ),
                  ),
                ),
                SizedBox(
                  width: sizeWidth,
                  height: sizeHeight * 0.06,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: AnimatedBuilder(
                      animation: controller,
                      builder: ((context, child) {
                        return CupertinoButton(
                          color: CustomColors.primaryColor,
                          onPressed: controller.isLoading
                              ? null
                              : () async {
                                  FocusScope.of(context).unfocus();
                                  if (formKey.currentState!.validate()) {
                                    await controller.resetPassword(
                                        emailRest: restPassword.text);
                                  }
                                  Navigator.pop(context);
                                },
                          child: controller.isLoading
                              ? const Padding(
                                  padding: EdgeInsets.all(3.0),
                                  child: CupertinoActivityIndicator(),
                                )
                              : const Text('Enviar'),
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
