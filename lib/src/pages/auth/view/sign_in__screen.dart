// ignore_for_file: use_build_context_synchronously, await_only_futures

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:page_transition/page_transition.dart';
import 'package:piu_vino/src/common_widgets/custom_text_field.dart';
import 'package:piu_vino/src/config/custom_colors.dart';
import 'package:piu_vino/src/pages/auth/controller/auth_controller.dart';
import 'package:piu_vino/src/pages/auth/view/rest_password_screen.dart';
import 'package:piu_vino/src/pages/auth/view/sign_up_screen.dart';
import 'package:piu_vino/src/pages/base/view/base_screen.dart';
import 'package:piu_vino/src/pages/favoritos/controller/favorito_controller.dart';
import 'package:piu_vino/src/pages/home/controller/home_controller.dart';
import 'package:piu_vino/src/pages/cart/controller/pedido_controller.dart';
import 'package:piu_vino/src/pages/order/controller/order_controller.dart';
import 'package:piu_vino/src/providers/providers.dart';
import 'package:piu_vino/src/services/validators.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late TextEditingController user = TextEditingController();
  late TextEditingController password = TextEditingController();
  OrderController orderController = OrderController();
  AuthController userController = AuthController();
  FavoritoController favoritoController = FavoritoController();
  CartController cartController = CartController();
  HomeController controllerHome = HomeController();
  bool _checkBox = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    controllerHome = getIt<HomeController>();
    favoritoController = getIt<FavoritoController>();
    cartController = getIt<CartController>();
    user = TextEditingController();
    password = TextEditingController();
    userController = getIt<AuthController>();
    orderController = getIt<OrderController>();
  }

  @override
  void dispose() {
    user.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.sizeOf(context).width;
    double sizeHeight = MediaQuery.sizeOf(context).height;
    return SafeArea(
      child: Scaffold(
          body: SizedBox(
        width: sizeWidth,
        height: sizeHeight,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Gap(sizeHeight / 8),
                SizedBox(
                  child: Image.asset('assets/app_images/logo.png'),
                ),
                // const Gap(5),
                Padding(
                  padding: const EdgeInsets.only(left: 18, right: 15),
                  child: CustomTextField(
                    controller: user,
                    label: 'User',
                    validator: userValidator,
                  ),
                ),
                const Gap(10),
                Padding(
                  padding: const EdgeInsets.only(left: 18, right: 15),
                  child: CustomTextField(
                    controller: password,
                    label: 'Password',
                    isSecret: true,
                    validator: passwordValidator,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 18, right: 15),
                  child: ListTile(
                    horizontalTitleGap: 1,
                    leading: SizedBox(
                      width: 10,
                      height: 10,
                      child: Checkbox(
                        activeColor: CustomColors.primaryColor,
                        value: _checkBox,
                        onChanged: (bool? value) {
                          setState(
                            () {
                              _checkBox = value!;
                            },
                          );
                        },
                      ),
                    ),
                    title: const Text('Lembrar de mim'),
                    trailing: GestureDetector(
                      onTap: () async {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.fade,
                            duration: await const Duration(milliseconds: 700),
                            child: const RestPasswordScreen(),
                          ),
                        );
                        user.text = '';
                        password.text = '';
                      },
                      child: Text(
                        'Esqueceu a senha?',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: CustomColors.segundaryColor),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: sizeWidth,
                  height: sizeHeight * 0.06,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 18, right: 15),
                    child: AnimatedBuilder(
                      animation: userController,
                      builder: (context, child) => CupertinoButton(
                        onPressed: userController.isLoading
                            ? null
                            : () async {
                                FocusScope.of(context).unfocus();
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  await userController.signIn(
                                      userName: user.text,
                                      password: password.text,
                                      context: context);
                                  await favoritoController.buscarItemFavorito(
                                      userId: userController.user.objectId
                                          .toString());
                                  if (userController.user.objectId != null) {
                                    controllerHome.buscarTodasCategorias();
                                    controllerHome.buscarTodosProdutos(
                                        canLoad: true);
                                    cartController.buscarPedido(
                                        idUser: userController.user.objectId
                                            .toString());
                                    orderController.getAllOrders(
                                        canLoad: true,
                                        idUser: userController.user.objectId
                                            .toString());
                                    Navigator.pushReplacement(
                                      context,
                                      PageTransition(
                                        type: PageTransitionType.bottomToTop,
                                        child: const BaseScreen(),
                                      ),
                                    );
                                  }
                                }
                              },
                        color: CustomColors.primaryColor,
                        child: userController.isLoading
                            ? const Padding(
                                padding: EdgeInsets.all(3.0),
                                child: CupertinoActivityIndicator(),
                              )
                            : const Text('Entrar'),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
                  child: GestureDetector(
                    onTap: () async {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.fade,
                          duration: await const Duration(milliseconds: 700),
                          child: const SignUpScreen(),
                        ),
                      );

                      user.text = '';
                      password.text = '';
                    },
                    child: RichText(
                      text: TextSpan(
                        text: 'Não possui uma conta?',
                        style: const TextStyle(color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                            text: ' Cadastre-se aqui.',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: CustomColors.segundaryColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
