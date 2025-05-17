import 'package:flutter/material.dart';
import 'RoomDatailScreenState.dart';

class HomeScreen extends StatefulWidget {
  final List<RoomBooking> bookedRooms;
  final Function(String roomNumber, DateTime start, DateTime end) onBook;
  final Function(String roomNumber) onCancel;

  HomeScreen({
    required this.bookedRooms,
    required this.onBook,
    required this.onCancel,
  });

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final rooms = List.generate(
      20,
      (index) => Room(
        number: (100 + index).toString(),
        description: index % 3 == 0
            ? "Люкс с видом на море"
            : index % 3 == 1
                ? "Стандартный номер"
                : "Семейный номер",
        price: 3000 + (index % 5) * 500,
        isAvailable: true,
      ),
    );

    final available = rooms
        .where((r) => widget.bookedRooms.every((b) => b.roomNumber != r.number))
        .toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Бронирование в SmartHotel'),
            Icon(Icons.hotel),
          ],
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text('Доступные номера',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          ...available.map((room) => _buildRoomCard(context, room, false)),
        ],
      ),
    );
  }

  Widget _buildRoomCard(BuildContext context, Room room, bool isBooked) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RoomDetailScreen(
              room: room,
              isBooked: isBooked,
              onBook: (roomNumber, start, end) {
                widget.onBook(roomNumber, start, end);
                setState(() {}); // <--- ВАЖНО: Обновляем список
              },
              onCancel: (roomNumber) {
                widget.onCancel(roomNumber);
                setState(() {});
              },
            ),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: ListTile(
          leading: Icon(Icons.king_bed),
          title: Text('Номер ${room.number} — ${room.description}'),
          subtitle: Text('${room.price} ₽ / ночь'),
        ),
      ),
    );
  }
}


class Room {
  final String number;
  final String description;
  final int price;
  final bool isAvailable;

  Room({
    required this.number,
    required this.description,
    required this.price,
    required this.isAvailable,
  });
}

class RoomBooking {
  final String roomNumber;
  final DateTime startDate;
  final DateTime endDate;

  RoomBooking({
    required this.roomNumber,
    required this.startDate,
    required this.endDate,
  });
}