import 'package:flutter/material.dart';
import 'screens/LoadingScreen.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Hotel',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: LoadingScreen(), // Сначала показываем экран загрузки
    );
  }
}