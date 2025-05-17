import 'package:flutter/material.dart';
import 'WelcomeScreen.dart';
import 'MainScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _errorText;

  void _login() {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      setState(() {
        _errorText = 'Введите логин и пароль';
      });
      return;
    }

    // Простейшая проверка, можно заменить на API
    if (username == 'admin' && password == '1234') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MainScreen()),
      );
    } else {
      setState(() {
        _errorText = 'Неверный логин или пароль';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Вход'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => WelcomeScreen()),
            );
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade100, Colors.blue.shade300],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Icon(Icons.lock, size: 80, color: Colors.indigo),
                SizedBox(height: 20),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(labelText: 'Логин'),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Пароль'),
                ),
                if (_errorText != null) ...[
                  SizedBox(height: 8),
                  Text(_errorText!, style: TextStyle(color: Colors.red)),
                ],
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _login,
                  child: Text('Войти'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
