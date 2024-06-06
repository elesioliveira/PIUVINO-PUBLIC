// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:piu_vino/src/common_widgets/appbar_base_screen.dart';
import 'package:piu_vino/src/config/custom_colors.dart';
import 'package:piu_vino/src/pages/auth/controller/auth_controller.dart';
import 'package:piu_vino/src/pages/user_report/controller/user_report_controller.dart';
import 'package:piu_vino/src/providers/providers.dart';

class UserReport extends StatefulWidget {
  const UserReport({super.key});

  @override
  State<UserReport> createState() => _UserReportState();
}

class _UserReportState extends State<UserReport> {
  UserReportController userReport = UserReportController();
  AuthController userController = AuthController();
  TextEditingController mensagemReport = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    userReport = getIt<UserReportController>();
    userController = getIt<AuthController>();
  }

  @override
  Widget build(BuildContext context) {
    double sizeHeigth = MediaQuery.sizeOf(context).height;
    double sizeWidth = MediaQuery.sizeOf(context).width;
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Stack(
                children: [
                  const Positioned(
                    top: 15,
                    child: SizedBox(
                      child: Center(
                        child: AppBarBaseScreen(),
                      ),
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
                  Center(
                    child: Container(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      width: sizeWidth,
                      child: SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                'Descreva a sua situação',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: CustomColors.primaryColor),
                              ),
                              TextFormField(
                                controller: mensagemReport,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Descreva seu problema';
                                  }
                                  if (value.length < 5) {
                                    return 'Descreva mais para que possamos ajudar!';
                                  }
                                  return null;
                                },
                                minLines: 1, // Número mínimo de linhas
                                maxLines: 100, // Número máximo de linhas
                                decoration: InputDecoration(
                                  label: const Text('Digite aqui'),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      8,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  //butão atualizar
                  Positioned(
                    bottom: 0,
                    child: AnimatedBuilder(
                      animation: userReport,
                      builder: (context, builder) {
                        return Material(
                          child: InkWell(
                            splashColor: CustomColors.segundaryColor,
                            onTap: () async {
                              FocusScope.of(context).unfocus();
                              if (_formKey.currentState!.validate()) {
                                await userReport.sendUserReport(
                                    userId:
                                        userController.user.objectId.toString(),
                                    infoProblemn: mensagemReport.text);
                                Navigator.of(context).pop();
                              }
                            },
                            child: Ink(
                              color: Colors.white,
                              width: sizeWidth,
                              height: sizeHeigth / 15,
                              child: userReport.isLoading
                                  ? const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [CupertinoActivityIndicator()],
                                    )
                                  : Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          CupertinoIcons.shift_fill,
                                          color: CustomColors.primaryColor,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          'Enviar',
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
            ),
          ],
        ),
      ),
    );
  }
}
