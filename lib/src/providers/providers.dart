import 'package:get_it/get_it.dart';
import 'package:piu_vino/src/pages/auth/controller/auth_controller.dart';
import 'package:piu_vino/src/pages/confirm_order.dart/controller/adress_controller.dart';
import 'package:piu_vino/src/pages/favoritos/controller/favorito_controller.dart';
import 'package:piu_vino/src/pages/cart/controller/pedido_controller.dart';
import 'package:piu_vino/src/pages/home/controller/home_controller.dart';
import 'package:piu_vino/src/pages/order/controller/order_controller.dart';
import 'package:piu_vino/src/pages/user_report/controller/user_report_controller.dart';
import 'package:piu_vino/src/services/utils_services.dart';

final getIt = GetIt.instance;

setupProviders() {
  getIt.registerSingleton<AuthController>(AuthController());
  getIt.registerSingleton<HomeController>(HomeController());
  getIt.registerSingleton<CartController>(CartController());
  getIt.registerSingleton<FavoritoController>(FavoritoController());
  getIt.registerSingleton<AdressController>(AdressController());
  getIt.registerSingleton<OrderController>(OrderController());
  getIt.registerSingleton<UtilsSerices>(UtilsSerices());
  getIt.registerSingleton<UserReportController>(UserReportController());
}
