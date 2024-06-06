import 'package:flutter/material.dart';
import 'package:piu_vino/src/pages/auth/view/sign_in__screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late double _sizeWidth;
  late double _sizeHeight;

  Future<void> _proximaPage() async {
    await Future.delayed(const Duration(seconds: 4));
    Navigator.pushReplacement(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(
        builder: (context) => const SignInScreen(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _sizeWidth = 300;
    _sizeHeight = 300;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _controller.repeat(reverse: true);
    _proximaPage();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.scale(
                scale: _controller.value * 0.5 + 1.0,
                child: Image.asset(
                  'assets/app_images/logo.png',
                  width: _sizeWidth,
                  height: _sizeHeight,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
