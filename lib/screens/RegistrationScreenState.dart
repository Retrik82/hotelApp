import 'package:flutter/material.dart';
import 'WelcomeScreen.dart';
import 'MainScreen.dart';
import 'NeuralSocketService.dart'; // Импорт NeuralSocketService

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
  bool _agreeToTerms = false;
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  late NeuralSocketService _socketService;

  @override
  void initState() {
    super.initState();
    _socketService = NeuralSocketService(
      serverUrl: 'wss://hotelbackend-cd6n.onrender.com/ws',
      onResponseReceived: (response) {
        if (response.hasStatus()) {
          if (response.status == Statuses.Ok) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => MainScreen()),
            );
          } else if (response.status == Statuses.Error) {
            setState(() {
              _errorText = 'Ошибка регистрации на сервере';
            });
          }
        } else if (response.hasInfo() || response.hasState()) {
          setState(() {
            _errorText = 'Непредвиденный ответ от сервера';
          });
        }
      },
      onError: (error) {
        setState(() {
          _errorText = error;
        });
      },
      onConnectionEstablished: () {
        print('WebSocket connection established');
      },
    );
    _socketService.connect();
  }

  @override
  void dispose() {
    _socketService.disconnect();
    _surnameController.dispose();
    _nameController.dispose();
    _patronymicController.dispose();
    _passportController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

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

    if (!_agreeToTerms) {
      setState(() => _errorText = 'Пожалуйста, согласитесь с условиями');
      return;
    }

    setState(() => _errorText = null);

    final command = DeviceCommand()
      ..action = 'register'
      ..surname = surname
      ..name = name
      ..patronymic = patronymic
      ..passport = passport
      ..email = email
      ..password = password
      ..confirmPassword = confirmPassword;

    _socketService.sendCommand(command);
  }

  void _validateEmail(String email) {
    if (email.isNotEmpty && !email.contains('@')) {
      setState(() {
        _errorText = 'Введите корректный email';
      });
    } else {
      setState(() {
        if (_errorText == 'Введите корректный email') _errorText = null; // Сбрасываем ошибку только для email
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
    ValueChanged<String>? onChanged, // Добавляем параметр для onChanged
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
        errorText: _errorText, // Отображаем ошибку под полем
      ),
      onChanged: onChanged, // Применяем onChanged, если задан
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
                          'Регистрация',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Icon(Icons.account_circle, color: Colors.white, size: 40),
                  ],
                ),
                SizedBox(height: 40),
                _buildTextField(controller: _nameController, label: 'Имя'),
                SizedBox(height: 16),
                _buildTextField(controller: _surnameController, label: 'Фамилия'),
                SizedBox(height: 16),
                _buildTextField(controller: _patronymicController, label: 'Отчество'),
                SizedBox(height: 16),
                _buildTextField(
                  controller: _emailController,
                  label: 'Электронная почта',
                  keyboardType: TextInputType.emailAddress,
                  onChanged: _validateEmail, // Вызываем действие при изменении текста
                ),
                SizedBox(height: 16),
                _buildTextField(
                  controller: _passwordController,
                  label: 'Введите пароль',
                  obscureText: !_passwordVisible,
                  suffixIcon: _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  onSuffixIconPressed: () {
                    setState(() => _passwordVisible = !_passwordVisible);
                  },
                ),
                SizedBox(height: 16),
                _buildTextField(
                  controller: _confirmPasswordController,
                  label: 'Подтвердите пароль',
                  obscureText: !_confirmPasswordVisible,
                  suffixIcon: _confirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  onSuffixIconPressed: () {
                    setState(() => _confirmPasswordVisible = !_confirmPasswordVisible);
                  },
                ),
                SizedBox(height: 16),
                _buildTextField(controller: _passportController, label: 'Серия и номер паспорта'),
                SizedBox(height: 20),
                Row(
                  children: [
                    Checkbox(
                      value: _agreeToTerms,
                      onChanged: (value) {
                        setState(() => _agreeToTerms = value ?? false);
                      },
                      checkColor: Colors.white,
                      activeColor: Colors.orange,
                    ),
                    Expanded(
                      child: Text(
                        'Ознакомлен и согласен с условиями и политикой конфиденциальности',
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
                    onPressed: _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: Text(
                      'Зарегистрироваться',
                      style: TextStyle(fontSize: 18, color: Colors.white),
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