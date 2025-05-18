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
        number: (243 + index).toString(),
        description: index % 3 == 0
            ? "Люкс с видом на море"
            : index % 3 == 1
                ? "Стандартный номер"
                : "Семейный номер",
        price: 3000 + (index % 5) * 500,
        isAvailable: true,
        guests: 2,
        beds: 2,
        area: 24,
        rating: 9.2,
        reviews: 120,
      ),
    );

    final available = rooms
        .where((r) => widget.bookedRooms.every((b) => b.roomNumber != r.number))
        .toList();

    return Scaffold(
      backgroundColor: Color(0xFF1A2A44),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Бронирование\nДоступные номера',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    Icons.account_circle, // Замените на нужную иконку, если есть
                    color: Colors.white,
                    size: 40,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: available.map((room) => _buildRoomCard(context, room, false)).toList(),
              ),
            ),
          ],
        ),
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
                setState(() {});
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
        color: Color(0xFF2A3A54),
        margin: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300, // Заглушка для изображения
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Center(
                    child: Icon(Icons.image, size: 50, color: Colors.grey.shade600),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    color: Colors.red,
                    child: Text(
                      'Выбор',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Icon(
                    Icons.favorite_border,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '№${room.number} — ${room.description}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Для ${room.guests} гостей • ${room.beds} кровати • ${room.area} м²',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${room.price} ₽ / ночь',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.yellow, size: 16),
                          SizedBox(width: 4),
                          Text(
                            '${room.rating} (${room.reviews})',
                            style: TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
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
  final int guests;
  final int beds;
  final int area;
  final double rating;
  final int reviews;

  Room({
    required this.number,
    required this.description,
    required this.price,
    required this.isAvailable,
    required this.guests,
    required this.beds,
    required this.area,
    required this.rating,
    required this.reviews,
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