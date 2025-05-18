import 'package:flutter/material.dart';
import 'WelcomeScreen.dart';
import 'MainScreen.dart';
import 'RegistrationScreenState.dart'; // Предполагаемый экран регистрации

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _errorText;
  bool _rememberMe = false;
  bool _passwordVisible = false;

  void _login() {
    final username = _emailController.text.trim();
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    IconData? suffixIcon,
    VoidCallback? onSuffixIconPressed,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white70, fontSize: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.orange, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.orange, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.orangeAccent, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        suffixIcon: suffixIcon != null
            ? IconButton(
                icon: Icon(suffixIcon, color: Colors.white70),
                onPressed: onSuffixIconPressed,
              )
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A2A44),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => WelcomeScreen()),
                        );
                      },
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          'С возвращением!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Icon(
                      Icons.account_circle, // Замените на нужную иконку, если есть
                      color: Colors.white,
                      size: 40,
                    ),
                  ],
                ),
                SizedBox(height: 40),
                _buildTextField(
                  controller: _emailController,
                  label: 'Логин(email)',
                ),
                SizedBox(height: 16),
                _buildTextField(
                  controller: _passwordController,
                  label: 'Пароль',
                  obscureText: !_passwordVisible,
                  suffixIcon: _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  onSuffixIconPressed: () {
                    setState(() => _passwordVisible = !_passwordVisible);
                  },
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (value) {
                            setState(() => _rememberMe = value ?? false);
                          },
                          checkColor: Colors.white,
                          activeColor: Colors.orange,
                        ),
                        Text(
                          'Запомнить меня',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        // Заглушка для "Забыли пароль?"
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Функция восстановления пароля в разработке')),
                        );
                      },
                      child: Text(
                        'Забыли пароль?',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ),
                  ],
                ),
                if (_errorText != null) ...[
                  SizedBox(height: 12),
                  Text(
                    _errorText!,
                    style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600),
                  ),
                ],
                SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: Text(
                      'Войти',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => RegistrationScreen()),
                      );
                    },
                    child: Text(
                      'Нет аккаунта? Зарегистрироваться',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}