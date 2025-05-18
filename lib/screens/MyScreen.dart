import 'package:flutter/material.dart';
import 'package:flutter_hotel/screens/HomeScreen.dart';
import 'package:intl/intl.dart';
import 'RoomControlScreen.dart';


class MyScreen extends StatefulWidget {
  final List<RoomBooking> bookedRooms;
  final Function(String) onCancelBooking;

  const MyScreen({super.key, 
    required this.bookedRooms,
    required this.onCancelBooking,
  });

  @override
  _MyScreenState createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    // Активные брони — текущая дата в интервале [startDate, endDate]
    final activeBookings = widget.bookedRooms.where((b) =>
        !b.startDate.isAfter(now) && !b.endDate.isBefore(now)).toList();

    // Неактивные брони — текущая дата вне интервала
    final inactiveBookings = widget.bookedRooms.where((b) =>
        b.startDate.isAfter(now) || b.endDate.isBefore(now)).toList();

    return Scaffold(
      appBar: AppBar(title: Text('Мои номера')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Активные брони', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              if (activeBookings.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('Нет активных броней'),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: activeBookings.length,
                  itemBuilder: (context, index) {
                    final booking = activeBookings[index];
                    return ListTile(
                      leading: Icon(Icons.hotel, color: Colors.green),
                      title: Text('Номер ${booking.roomNumber}'),
                      subtitle: Text(
                          'с ${DateFormat('dd.MM.yyyy').format(booking.startDate)} '
                          'по ${DateFormat('dd.MM.yyyy').format(booking.endDate)}'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RoomControlScreen(roomNumber: booking.roomNumber),
                          ),
                        );
                      },
                    );
                  },
                ),
              SizedBox(height: 24),
              Text('Другие брони', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              if (inactiveBookings.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('Нет других броней'),
                )
              else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: inactiveBookings.length,
                    itemBuilder: (context, index) {
                      final booking = inactiveBookings[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200, // светло-серый фон
                          borderRadius: BorderRadius.circular(8),
                        ),
                        margin: EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          leading: Icon(Icons.hotel, color: Colors.grey),
                          title: Text(
                            'Номер ${booking.roomNumber}',
                            style: TextStyle(color: Colors.black54),
                          ),
                          subtitle: Text(
                            'с ${DateFormat('dd.MM.yyyy').format(booking.startDate)} '
                            'по ${DateFormat('dd.MM.yyyy').format(booking.endDate)}',
                            style: TextStyle(color: Colors.black45),
                          ),
                          trailing: ElevatedButton(
                            onPressed: () {
                              widget.onCancelBooking(booking.roomNumber);
                              setState(() {
                                widget.bookedRooms.removeWhere((b) => b.roomNumber == booking.roomNumber);
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            child: Text('Отменить'),
                          ),
                          // УБИРАЕМ onTap для блокировки перехода
                          enabled: false, // также можно просто отключить весь ListTile
                        ),
                      );
                    },
                  ),

            ],
          ),
        ),
      ),
    );
  }
}
