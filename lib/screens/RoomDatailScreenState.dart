import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'HomeScreen.dart';

class RoomDetailScreen extends StatefulWidget {
  final Room room;
  final bool isBooked;
  final Function(String, DateTime, DateTime) onBook;
  final Function(String) onCancel;
  final DateTime? bookedStartDate;
  final DateTime? bookedEndDate;

  RoomDetailScreen({
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

  @override
  Widget build(BuildContext context) {
    bool isFieldsDisabled = _isBookedLocally;

    return Scaffold(
      appBar: AppBar(title: Text('Номер ${widget.room.number}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 180,
                color: Colors.grey[300],
                child: Center(child: Text('Фото номера', style: TextStyle(fontSize: 18))),
              ),
              SizedBox(height: 16),
              Text(widget.room.description,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('${widget.room.price} ₽ / ночь', style: TextStyle(fontSize: 16)),
              SizedBox(height: 16),

              // Дата начала
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _startDate,
                      enabled: !isFieldsDisabled,
                      readOnly: true,
                      decoration: InputDecoration(labelText: 'С даты (дд.мм.гггг)'),
                      onTap: isFieldsDisabled ? null : () => _selectDate(context, _startDate),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: isFieldsDisabled ? null : () => _selectDate(context, _startDate),
                  ),
                ],
              ),

              // Дата окончания
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _endDate,
                      enabled: !isFieldsDisabled,
                      readOnly: true,
                      decoration: InputDecoration(labelText: 'По дату (дд.мм.гггг)'),
                      onTap: isFieldsDisabled ? null : () => _selectDate(context, _endDate),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: isFieldsDisabled ? null : () => _selectDate(context, _endDate),
                  ),
                ],
              ),

              if (_errorText != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(_errorText!, style: TextStyle(color: Colors.red)),
                ),

              SizedBox(height: 16),

              if (_isBookedLocally)
                Text(
                  'Вы забронировали с ${_startDate.text} по ${_endDate.text}',
                  style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                ),

              SizedBox(height: 12),

              // Кнопки
              _isBookedLocally
                  ? ElevatedButton(
                      onPressed: () {
                        widget.onCancel(widget.room.number);
                        setState(() {
                          _isBookedLocally = false;
                          _startDate.clear();
                          _endDate.clear();
                        });
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: Text('Удалить бронь'),
                    )
                  : ElevatedButton(
                      onPressed: () {
                        if (_validateDates()) {
                          final start = DateFormat('dd.MM.yyyy').parse(_startDate.text);
                          final end = DateFormat('dd.MM.yyyy').parse(_endDate.text);
                          widget.onBook(widget.room.number, start, end);

                          setState(() {
                            _isBookedLocally = true;

                            // Вот это добавь 👇
                            _startDate.text = DateFormat('dd.MM.yyyy').format(start);
                            _endDate.text = DateFormat('dd.MM.yyyy').format(end);
                          });
                        }
                      },
                      child: Text('Забронировать'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
