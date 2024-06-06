// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:piu_vino/src/common_widgets/quantity_widget.dart';
import 'package:piu_vino/src/config/custom_colors.dart';
import 'package:piu_vino/src/pages/auth/controller/auth_controller.dart';
import 'package:piu_vino/src/pages/cart/controller/pedido_controller.dart';
import 'package:piu_vino/src/providers/providers.dart';

import 'package:piu_vino/src/services/utils_services.dart';

class DetailProductScreen extends StatefulWidget {
  DetailProductScreen(
      {super.key,
      required this.produtoId,
      required this.tagHero,
      required this.nomeProduto,
      required this.precoProduto,
      required this.quantidadeProduto});

  final String produtoId;
  final String tagHero;
  final String nomeProduto;
  final double precoProduto;
  late int quantidadeProduto;

  @override
  State<DetailProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<DetailProductScreen> {
  final UtilsSerices utilsServices = UtilsSerices();
  AuthController userController = AuthController();
  CartController cartController = CartController();
  @override
  void initState() {
    super.initState();
    userController = getIt<AuthController>();
    cartController = getIt<CartController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withAlpha(180),
      body: SafeArea(
        child: Stack(
          children: [
            // Conteúdo
            Column(
              children: [
                Expanded(
                  child: Hero(
                    tag: widget.tagHero,
                    child: Image.asset('assets/app_images/garrafa.png'),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(50),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade600,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Nome - Quantidade
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.nomeProduto.toUpperCase(),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 27,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Preço
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              utilsServices.priceToCurrency(
                                  widget.precoProduto.toDouble()),
                              style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                                color: CustomColors.primaryColor,
                              ),
                            ),
                            QuantityWidget(
                              value: widget.quantidadeProduto.toInt(),
                              result: (quantity) {
                                setState(() {
                                  widget.quantidadeProduto = quantity;
                                });
                              },
                            ),
                          ],
                        ),

                        // Descrição
                        const Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: SingleChildScrollView(
                              child: Text(
                                'A descrição de produto não deve ser longa e não deve trazer informações desnecessárias. O ideal é que ela traga informações relevantes para o convencimento do cliente, de modo conciso e sempre prezando pela transparência de conceitos e especificações técnicas.',
                                style: TextStyle(
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Botão
                        SizedBox(
                          height: 55,
                          child: CupertinoButton(
                            color: CustomColors.primaryColor,
                            onPressed: () async {
                              if (widget.quantidadeProduto == 0) {
                                return utilsServices.showToast(
                                    message: 'Adicione uma quantidade',
                                    isError: true);
                              }
                              await cartController.addProductIntoCart(
                                  priceProduto: widget.precoProduto,
                                  idCliente:
                                      userController.user.objectId.toString(),
                                  idProduto: widget.produtoId,
                                  quantidade: widget.quantidadeProduto);
                              cartController.buscarPedido(
                                  idUser:
                                      userController.user.objectId.toString(),
                                  canLoad: true);

                              Navigator.of(context).pop();
                            },
                            child: Row(
                              children: [
                                Text(
                                  'Adicionar no carrinho',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white.withAlpha(140)),
                                ),
                                Icon(Icons.shopping_cart_outlined,
                                    color: Colors.white.withAlpha(140)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Botão voltar
            Positioned(
              left: 25,
              top: 25,
              child: SafeArea(
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(
                    Icons.arrow_back_ios,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
