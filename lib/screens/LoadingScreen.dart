import 'dart:async';
import 'package:flutter/material.dart';
import 'WelcomeScreen.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

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
@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color.fromARGB(255, 5, 34, 57), // фон
    body: Center(      // центрируем содержимое по вертикали и горизонтали
      child: Column(
        mainAxisSize: MainAxisSize.min, // чтобы Column занял минимально возможное место
        children: [
          RotationTransition(
            turns: _controller,
            child: Image.asset(
              'assets/logoHotel.png',
              width: 80,
              height: 80,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Загрузка...',
            style: TextStyle(fontSize: 18, color: Color.fromARGB(221, 255, 255, 255)),
          ),
        ],
      ),
    ),
  );
}

}
