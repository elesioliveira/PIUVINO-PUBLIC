import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:piu_vino/src/common_widgets/custom_text_field.dart';
import 'package:piu_vino/src/config/custom_colors.dart';
import 'package:piu_vino/src/models/user_model.dart';
import 'package:piu_vino/src/pages/auth/controller/auth_controller.dart';
import 'package:piu_vino/src/providers/providers.dart';
import 'package:piu_vino/src/services/utils_services.dart';
import 'package:piu_vino/src/services/validators.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController user = TextEditingController();
  TextEditingController senha = TextEditingController();
  TextEditingController nomeCompleto = TextEditingController();
  TextEditingController email = TextEditingController();
  UtilsSerices utilServices = UtilsSerices();
  bool _checkBox1 = false;
  bool _checkBox2 = false;
  AuthController controller = AuthController();

  @override
  void initState() {
    super.initState();
    controller = getIt<AuthController>();
    utilServices = UtilsSerices();
  }

  @override
  void dispose() {
    user.dispose();
    senha.dispose();
    nomeCompleto.dispose();
    email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.sizeOf(context).width;
    double sizeHeight = MediaQuery.sizeOf(context).height;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset:
            false, // Evita que o teclado sobreponha o conteúdo
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                    child: Stack(
                  children: [
                    Image.asset('assets/app_images/logo.png'),
                    Positioned(
                      top: 0,
                      left: 0,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(CupertinoIcons.back),
                      ),
                    )
                  ],
                )),
                const Gap(5),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: CustomTextField(
                    controller: user,
                    label: 'User name',
                    validator: userValidator,
                  ),
                ),
                const Gap(5),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: CustomTextField(
                    controller: senha,
                    validator: passwordValidator,
                    label: 'Senha',
                    isSecret: true,
                  ),
                ),
                const Gap(5),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: CustomTextField(
                    controller: nomeCompleto,
                    label: 'Nome',
                    validator: nameValidator,
                  ),
                ),
                const Gap(5),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: CustomTextField(
                    controller: email,
                    label: 'Email',
                    validator: emailValidator,
                  ),
                ),
                SizedBox(
                  width: sizeWidth,
                  height: sizeHeight * 0.055,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          child: Checkbox(
                            value: _checkBox1,
                            onChanged: ((bool? value) {
                              setState(
                                () {
                                  _checkBox1 = value!;
                                },
                              );
                            }),
                          ),
                        ),
                        const Gap(2),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Gap(8),
                            GestureDetector(
                              onTap: () {},
                              child: SizedBox(
                                child: RichText(
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black),
                                    text: 'Declaro que li e aceito os ',
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: 'termos e condições ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: CustomColors.segundaryColor),
                                      ),
                                      const TextSpan(
                                        text: 'e ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              child: RichText(
                                softWrap: true,
                                text: TextSpan(
                                    text: 'a ',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: 'politíca de privacidade',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: CustomColors.segundaryColor),
                                      )
                                    ]),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: sizeWidth,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          child: Checkbox(
                            value: _checkBox2,
                            onChanged: ((bool? value) {
                              setState(
                                () {
                                  _checkBox2 = value!;
                                },
                              );
                            }),
                          ),
                        ),
                        const Gap(2),
                        const Text(
                          'Deseja receber nossas promoções?',
                          style: TextStyle(
                              fontWeight: FontWeight.w300, color: Colors.black),
                        )
                      ],
                    ),
                  ),
                ),
                const Gap(10),
                SizedBox(
                  width: sizeWidth,
                  height: sizeHeight * 0.06,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: AnimatedBuilder(
                      animation: controller,
                      builder: (context, child) {
                        return CupertinoButton(
                          color: CustomColors.primaryColor,
                          onPressed: controller.isLoading
                              ? null
                              : () async {
                                  FocusScope.of(context).unfocus();
                                  if (_formKey.currentState!.validate()) {
                                    if (_checkBox1 == false) {
                                      utilServices.showToast(
                                          message:
                                              'Confirme autorização de termos',
                                          isError: true);
                                      return;
                                    }
                                    User novoUsuario = User(
                                        username: user.text,
                                        senha: senha.text,
                                        nomeCompleto: nomeCompleto.text,
                                        email: email.text);
                                    await controller.signUpUser(
                                        user: novoUsuario, context: context);
                                  }
                                },
                          child: controller.isLoading
                              ? const Padding(
                                  padding: EdgeInsets.all(3.0),
                                  child: CupertinoActivityIndicator(),
                                )
                              : const Text('Criar Cadastro'),
                        );
                      },
                    ),
                  ),
                ),
                const Gap(5),
                SizedBox(
                  width: sizeWidth,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: RichText(
                        textAlign: TextAlign.center,
                        softWrap: true,
                        text: TextSpan(
                          text: 'Já tem uma conta?',
                          style: const TextStyle(
                              fontWeight: FontWeight.w300, color: Colors.black),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Acesse aqui',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: CustomColors.segundaryColor),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
