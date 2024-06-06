import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:piu_vino/src/pages/splash/splash_screen.dart';
import 'package:piu_vino/src/providers/providers.dart';
import 'package:piu_vino/src/services/utils_services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  debugPaintSizeEnabled = false; // Ativar debug painting de tamanhos
  setupProviders();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  UtilsSerices utilsServices = UtilsSerices();

  @override
  void initState() {
    super.initState();
    utilsServices = getIt<UtilsSerices>();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: utilsServices,
      builder: (context, child) {
        return MaterialApp(
          themeMode: utilsServices.themeMode,
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(useMaterial3: true),
          darkTheme: ThemeData.dark(useMaterial3: true),
          home: const SplashScreen(),
        );
      },
    );
  }
}
