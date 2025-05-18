import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF061A27), // тёмно-синий фон
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20),
            // Аватар
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/user_profile.png'), // сюда вставь путь к своей картинке
              ),
            ),
            SizedBox(height: 12),
            // Имя
            Text(
              'Михаил Иванов',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            // Почта
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 24.0),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Color(0xFF0D2B40),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'mikhailivanov@gmail.com',
                  style: TextStyle(color: Colors.grey[300]),
                ),
              ),
            ),
            SizedBox(height: 30),

            // Меню
            Expanded(
              child: ListView(
                children: [
                  _buildMenuItem(Icons.settings, 'Настройки', onTap: () {}),
                  _buildMenuItem(Icons.payment, 'Способ платежа', onTap: () {}),
                  _buildMenuItem(Icons.language, 'Язык', onTap: () {}),
                  _buildMenuItem(Icons.help_outline, 'Помощь', onTap: () {}),
                  _buildMenuItem(
                    Icons.logout,
                    'Выйти',
                    iconColor: Colors.red,
                    textColor: Colors.red,
                    onTap: () {
                      // Выйти из аккаунта
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String title, {
    Color iconColor = Colors.white,
    Color textColor = Colors.white,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(
        title,
        style: TextStyle(color: textColor),
      ),
      trailing: Icon(Icons.chevron_right, color: Colors.white),
      onTap: onTap,
    );
  }
}
