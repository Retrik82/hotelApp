import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text('Профиль'),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.indigo,
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
            SizedBox(height: 16),
            Text(
              'Имя пользователя',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'user@example.com',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 30),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Настройки'),
              onTap: () {
                // Навигация или логика
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Выйти'),
              onTap: () {
                // Выйти из аккаунта
              },
            ),
          ],
        ),
      ),
    );
  }
}