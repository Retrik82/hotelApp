import 'dart:async';
import 'package:flutter/material.dart';
import 'WelcomeScreen.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    // Инициализируем анимацию вращения логотипа
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // Ждём 3.5 секунды, затем переходим к WelcomeScreen
    Timer(const Duration(milliseconds: 3500), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => WelcomeScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 13, 43, 68), // Однотонный фон
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RotationTransition(
              turns: _controller,
              child: Image.asset(
                'assets/logoHotel.png', // Помести логотип в папку assets
                width: 100,
                height: 100,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Загрузка...',
              style: TextStyle(fontSize: 20, color: Color.fromARGB(221, 255, 255, 255)),
            ),
          ],
        ),
      ),
    );
  }
}
