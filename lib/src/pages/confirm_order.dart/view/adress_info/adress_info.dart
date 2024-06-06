// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:piu_vino/src/models/user_adress.dart';
import 'package:piu_vino/src/pages/auth/controller/auth_controller.dart';
import 'package:piu_vino/src/pages/confirm_order.dart/controller/adress_controller.dart';
import 'package:piu_vino/src/common_widgets/appbar_cart_widget.dart';
import 'package:piu_vino/src/pages/confirm_order.dart/view/adress_info/componentes/bottom_buttom_widget.dart';
import 'package:piu_vino/src/pages/confirm_order.dart/view/adress_info/componentes/entrada_de_texto.dart';
import 'package:piu_vino/src/pages/confirm_order.dart/view/adress_info/componentes/gap_widget.dart';
import 'package:piu_vino/src/providers/providers.dart';

class UserAdressInfo extends StatefulWidget {
  const UserAdressInfo(
      {super.key,
      required this.title,
      this.adress,
      required this.onTap,
      required this.atualizarAdress});
  final String title;
  final AdressModel? adress;
  final dynamic Function()? onTap;
  final bool atualizarAdress;

  @override
  State<UserAdressInfo> createState() => _UserAdressInfoState();
}

class _UserAdressInfoState extends State<UserAdressInfo> {
  TextEditingController nomeController = TextEditingController();
  TextEditingController telefoneController = TextEditingController();
  TextEditingController cepController = TextEditingController();
  TextEditingController ufController = TextEditingController();
  TextEditingController cidadeController = TextEditingController();
  TextEditingController bairroController = TextEditingController();
  TextEditingController logradouroController = TextEditingController();
  TextEditingController referenciaController = TextEditingController();
  TextEditingController numeroController = TextEditingController();
  AdressController adressController = AdressController();
  AuthController userController = AuthController();
  final _formKey = GlobalKey<FormState>();

  final phoneFormatter = MaskTextInputFormatter(
    mask: '(##)#####-####',
    filter: {'#': RegExp(r'[0-9]')},
  );
  final cepFormatter = MaskTextInputFormatter(
    mask: '########',
    filter: {'#': RegExp(r'[0-9]')},
  );

  late String controller = '';
  @override
  void initState() {
    super.initState();
    nomeController.text = widget.adress?.nomeCompleto ?? '';
    telefoneController.text = widget.adress?.telefone ?? '';
    cepController.text = widget.adress?.cep ?? '';
    ufController.text = widget.adress?.uf ?? '';
    cidadeController.text = widget.adress?.cidade ?? '';
    bairroController.text = widget.adress?.bairro ?? '';
    logradouroController.text = widget.adress?.logradouro ?? '';
    referenciaController.text = widget.adress?.referencia ?? '';
    numeroController.text = widget.adress?.numero ?? '';
    adressController = getIt<AdressController>();
    userController = getIt<AuthController>();
  }

  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.sizeOf(context).width;
    double sizeHeight = MediaQuery.sizeOf(context).height;
    limparControllers() {
      nomeController.clear();
      telefoneController.clear();
      cepController.clear();
      ufController.clear();
      cidadeController.clear();
      bairroController.clear();
      logradouroController.clear();
      referenciaController.clear();
      numeroController.clear();
    }

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                AppBarCartWidget(
                  titleAppBar: widget.title,
                  onPressed: () {
                    Navigator.of(context).pop();
                    limparControllers();
                  },
                ),
                const GapWidget(
                  title: 'Contato',
                ),
                const Gap(10),
                EntradaTextoAdress(
                  inputFormatters: const [],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Digite seu nome completo';
                    }
                    return null;
                  },
                  label: 'Nome complerto',
                  textEditingController: nomeController,
                ),
                const Gap(10),
                EntradaTextoAdress(
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    phoneFormatter
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Digite seu telefone';
                    }
                    return null;
                  },
                  label: 'Numero de telefone',
                  textEditingController: telefoneController,
                ),
                const GapWidget(
                  title: 'Endereço',
                ),
                const Gap(10),
                EntradaTextoAdress(
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    cepFormatter
                  ],
                  searchCep: () async {
                    await adressController.searchCep(cep: cepController.text);
                    if (adressController.cepSucess != null) {
                      ufController.text = adressController
                          .cepSucess!.estadoInfo!.nome
                          .toString()
                          .toUpperCase();
                      cidadeController.text = adressController.cepSucess!.cidade
                          .toString()
                          .toUpperCase();
                      bairroController.text = adressController.cepSucess!.bairro
                          .toString()
                          .toUpperCase();
                      logradouroController.text = adressController
                          .cepSucess!.logradouro
                          .toString()
                          .toUpperCase();
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Digite seu cep';
                    }
                    return null;
                  },
                  textEditingController: cepController,
                  checkTextField: controller.isNotEmpty,
                  label: 'Cep',
                  onChanged: (String? value) {
                    setState(() {
                      controller = value!;
                    });
                  },
                ),
                const Gap(10),
                EntradaTextoAdress(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Digite seu Estado';
                    }
                    return null;
                  },
                  label: 'Estado',
                  textEditingController: ufController,
                ),
                const Gap(10),
                const Gap(10),
                EntradaTextoAdress(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Digite sua Cidade';
                    }
                    return null;
                  },
                  label: 'Cidade',
                  textEditingController: cidadeController,
                ),
                const Gap(10),
                const Gap(10),
                EntradaTextoAdress(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Digite seu Bairro';
                    }
                    return null;
                  },
                  label: 'Bairro',
                  textEditingController: bairroController,
                ),
                const Gap(10),
                SizedBox(
                  width: sizeWidth,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      EntradaTextoAdress(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Digite sua Rua';
                          }
                          return null;
                        },
                        label: 'Nome da rua',
                        width: sizeWidth * 0.689,
                        textEditingController: logradouroController,
                      ),
                      Gap(sizeHeight * 0.004),
                      EntradaTextoAdress(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Digite o numero de sua residência';
                          }
                          return null;
                        },
                        label: 'Numero',
                        width: sizeWidth * 0.30,
                        textEditingController: numeroController,
                      ),
                    ],
                  ),
                ),
                const Gap(10),
                EntradaTextoAdress(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Digite alguma referência';
                      }
                      return null;
                    },
                    label: 'Complemento/Referência',
                    textEditingController: referenciaController),
                Gap(sizeHeight * 0.052),
                AnimatedBuilder(
                  animation: adressController,
                  builder: (context, child) {
                    return NewAdressButtom(
                      carregando: adressController.isLoadingAttAdress,
                      onTap: adressController.isLoadingAttAdress
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                AdressModel newAdress = AdressModel(
                                    objectId:
                                        widget.adress?.objectId?.toUpperCase(),
                                    cidade: cidadeController.text.toUpperCase(),
                                    bairro: bairroController.text.toUpperCase(),
                                    logradouro:
                                        logradouroController.text.toUpperCase(),
                                    numero: numeroController.text.toUpperCase(),
                                    cep: cepController.text.toUpperCase(),
                                    referencia:
                                        referenciaController.text.toUpperCase(),
                                    nomeCompleto:
                                        nomeController.text.toUpperCase(),
                                    telefone:
                                        telefoneController.text.toUpperCase(),
                                    uf: ufController.text.toUpperCase());

                                if (widget.atualizarAdress == true) {
                                  await adressController.attUserAdress(
                                      adress: newAdress,
                                      idAdress: widget.adress!.objectId ?? '');
                                  await adressController.feacthAdress(
                                      userId: userController.user.objectId
                                          .toString());
                                  Navigator.of(context).pop();
                                  return;
                                } else {
                                  await adressController.creatingAdress(
                                      adress: newAdress,
                                      userId: userController.user.objectId
                                          .toString());
                                  await adressController.feacthAdress(
                                      userId: userController.user.objectId
                                          .toString());
                                  Navigator.of(context).pop();
                                  return;
                                }
                              }
                            },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
