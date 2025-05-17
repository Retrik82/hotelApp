import 'package:flutter/material.dart';

class RoomControlScreen extends StatelessWidget {
  final String roomNumber;

  RoomControlScreen({required this.roomNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Номер $roomNumber')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Фото номера
            Container(
              height: 200,
              width: double.infinity,
              child: Image.asset(
                'assets/room.jpg', // Убедись, что добавил room.jpg в pubspec.yaml
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20),

            // Кнопки управления
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Дверь открыта')),
                      );
                    },
                    icon: Icon(Icons.lock_open),
                    label: Text('Открыть'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Свет включен')),
                      );
                    },
                    icon: Icon(Icons.lightbulb),
                    label: Text('Свет'),
                  ),
                ],
              ),
            ),

            SizedBox(height: 30),

            // Информация об условиях в комнате
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InfoTile(label: 'Температура', value: '22°C'),
                  InfoTile(label: 'Влажность', value: '45%'),
                  InfoTile(label: 'CO₂ уровень', value: '420 ppm'),
                  InfoTile(label: 'Шум', value: '30 dB'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  final String label;
  final String value;

  const InfoTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 18)),
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
