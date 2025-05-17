import 'package:flutter/material.dart';
import 'WelcomeScreen.dart';
import 'MainScreen.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _patronymicController = TextEditingController();
  final TextEditingController _passportController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String? _errorText;

  void _register() {
    final surname = _surnameController.text.trim();
    final name = _nameController.text.trim();
    final patronymic = _patronymicController.text.trim();
    final passport = _passportController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (surname.isEmpty || name.isEmpty || patronymic.isEmpty || passport.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      setState(() => _errorText = 'Пожалуйста, заполните все поля');
      return;
    }

    if (!email.contains('@')) {
      setState(() => _errorText = 'Введите корректный email');
      return;
    }

    if (password.length < 6) {
      setState(() => _errorText = 'Пароль должен содержать минимум 6 символов');
      return;
    }

    if (password != confirmPassword) {
      setState(() => _errorText = 'Пароли не совпадают');
      return;
    }

    // Здесь можно вызвать API регистрации или сохранить в локальной базе

    setState(() => _errorText = null);

    // Переход на главный экран после регистрации
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => MainScreen()),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Регистрация'),
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
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo.shade100, Colors.indigo.shade300],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Icon(Icons.app_registration, size: 80, color: Colors.indigo),
                SizedBox(height: 24),
                _buildTextField(controller: _surnameController, label: 'Фамилия'),
                SizedBox(height: 16),
                _buildTextField(controller: _nameController, label: 'Имя'),
                SizedBox(height: 16),
                _buildTextField(controller: _patronymicController, label: 'Отчество'),
                SizedBox(height: 16),
                _buildTextField(controller: _passportController, label: 'Серия и номер паспорта'),
                SizedBox(height: 16),
                _buildTextField(
                  controller: _emailController,
                  label: 'Логин (Email)',
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 16),
                _buildTextField(
                  controller: _passwordController,
                  label: 'Пароль',
                  obscureText: true,
                ),
                SizedBox(height: 16),
                _buildTextField(
                  controller: _confirmPasswordController,
                  label: 'Повторите пароль',
                  obscureText: true,
                ),
                if (_errorText != null) ...[
                  SizedBox(height: 12),
                  Text(_errorText!, style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600)),
                ],
                SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _register,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(
                      'Зарегистрироваться',
                      style: TextStyle(fontSize: 18),
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
