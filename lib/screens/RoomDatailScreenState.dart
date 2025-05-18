import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// Импортируем MainScreen
import 'HomeScreen.dart';

class RoomDetailScreen extends StatefulWidget {
  final Room room;
  final bool isBooked;
  final Function(String, DateTime, DateTime) onBook;
  final Function(String) onCancel;
  final DateTime? bookedStartDate;
  final DateTime? bookedEndDate;

  const RoomDetailScreen({super.key, 
    required this.room,
    required this.isBooked,
    required this.onBook,
    required this.onCancel,
    this.bookedStartDate,
    this.bookedEndDate,
  });

  @override
  _RoomDetailScreenState createState() => _RoomDetailScreenState();
}

class _RoomDetailScreenState extends State<RoomDetailScreen> {
  final TextEditingController _startDate = TextEditingController();
  final TextEditingController _endDate = TextEditingController();
  String? _errorText;
  bool _isBookedLocally = false;

  @override
  void initState() {
    super.initState();
    _isBookedLocally = widget.isBooked;

    if (widget.bookedStartDate != null) {
      _startDate.text = DateFormat('dd.MM.yyyy').format(widget.bookedStartDate!);
    }

    if (widget.bookedEndDate != null) {
      _endDate.text = DateFormat('dd.MM.yyyy').format(widget.bookedEndDate!);
    }
  }

  @override
  void dispose() {
    _startDate.dispose();
    _endDate.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('dd.MM.yyyy').format(picked);
      });
    }
  }

  bool _validateDates() {
    try {
      final start = DateFormat('dd.MM.yyyy').parse(_startDate.text);
      final end = DateFormat('dd.MM.yyyy').parse(_endDate.text);

      if (end.isBefore(start)) {
        setState(() => _errorText = 'Дата окончания не может быть раньше начала.');
        return false;
      }

      setState(() => _errorText = null);
      return true;
    } catch (_) {
      setState(() => _errorText = 'Неверный формат даты. Используйте дд.мм.гггг');
      return false;
    }
  }

  int _calculateNights() {
    if (_startDate.text.isEmpty || _endDate.text.isEmpty) return 0;
    try {
      final start = DateFormat('dd.MM.yyyy').parse(_startDate.text);
      final end = DateFormat('dd.MM.yyyy').parse(_endDate.text);
      return end.difference(start).inDays;
    } catch (_) {
      return 0;
    }
  }

  int _calculateTotalPrice() {
    int nights = _calculateNights();
    return nights * widget.room.price; // Explicit integer multiplication
  }

  @override
  Widget build(BuildContext context) {
    bool isFieldsDisabled = _isBookedLocally;
    int nights = _calculateNights();
    int totalPrice = _calculateTotalPrice();

    return Scaffold(
      backgroundColor: Color(0xFF1A2A44),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '№${widget.room.number} — ${widget.room.description}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.account_circle,
                      color: Colors.white,
                      size: 40,
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Icon(Icons.image, size: 50, color: Colors.grey.shade600),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Для ${widget.room.guests} гостей • ${widget.room.beds} кровати • ${widget.room.area} m²',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.yellow, size: 16),
                    SizedBox(width: 4),
                    Text(
                      '${widget.room.rating} (${widget.room.reviews})',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  'Основные удобства',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Icon(Icons.wifi, color: Colors.white70, size: 24),
                        SizedBox(height: 4),
                        Text(
                          'Бесплатный WiFi',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Icon(Icons.tv, color: Colors.white70, size: 24),
                        SizedBox(height: 4),
                        Text(
                          'Телевизор',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Icon(Icons.shower, color: Colors.white70, size: 24),
                        SizedBox(height: 4),
                        Text(
                          'Душ',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'С',
                            style: TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                          SizedBox(height: 8),
                          TextField(
                            controller: _startDate,
                            enabled: !isFieldsDisabled,
                            readOnly: true,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: '14:00',
                              hintStyle: TextStyle(color: Colors.white70),
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
                            ),
                            onTap: isFieldsDisabled ? null : () => _selectDate(context, _startDate),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'По',
                            style: TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                          SizedBox(height: 8),
                          TextField(
                            controller: _endDate,
                            enabled: !isFieldsDisabled,
                            readOnly: true,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: '12:00',
                              hintStyle: TextStyle(color: Colors.white70),
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
                            ),
                            onTap: isFieldsDisabled ? null : () => _selectDate(context, _endDate),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (_errorText != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(_errorText!, style: TextStyle(color: Colors.redAccent)),
                  ),
                SizedBox(height: 24),
                if (_isBookedLocally)
                  Text(
                    'Вы забронировали с ${_startDate.text} по ${_endDate.text}',
                    style: TextStyle(color: Colors.white70, fontSize: 14, fontStyle: FontStyle.italic),
                  ),
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isBookedLocally
                        ? () {
                            widget.onCancel(widget.room.number);
                            setState(() {
                              _isBookedLocally = false;
                              _startDate.clear();
                              _endDate.clear();
                            });
                          }
                        : () {
                            if (_validateDates()) {
                              final start = DateFormat('dd.MM.yyyy').parse(_startDate.text);
                              final end = DateFormat('dd.MM.yyyy').parse(_endDate.text);
                              widget.onBook(widget.room.number, start, end);
                              setState(() {
                                _isBookedLocally = true;
                                _startDate.text = DateFormat('dd.MM.yyyy').format(start);
                                _endDate.text = DateFormat('dd.MM.yyyy').format(end);
                              });
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.bolt, color: Colors.white, size: 20),
                        SizedBox(width: 8),
                        Text(
                          _isBookedLocally ? 'Удалить бронь' : 'Забронировать',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '$totalPrice BYN за $nights ноч${nights % 10 == 1 && nights % 100 != 11 ? 'ь' : 'и'}',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                Text(
                  '30 BYN сервис, остальное — после заезда',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}