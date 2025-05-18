import 'package:flutter/material.dart';
import 'package:flutter_hotel/Server/RoomControlService.dart';

class RoomControlScreen extends StatefulWidget {
  final String roomNumber;

  const RoomControlScreen({required this.roomNumber, super.key});

  @override
  _RoomControlScreenState createState() => _RoomControlScreenState();
}

class _RoomControlScreenState extends State<RoomControlScreen> {
  late final NeuralSocketService _socketService;
  String temperature = '—';
  String humidity = '—';
  String pressure = '—';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _socketService = NeuralSocketService(
      serverUrl: 'ws://192.168.124.119:8000/ws',
      onPredictionReceived: _handleSensorData,
      onError: _handleError,
      onConnectionEstablished: _handleConnectionEstablished,
    );
  }

  void _handleSensorData(Map<String, dynamic> data) {
    setState(() {
      temperature = data['temperature']?.toString() ?? '—';
      humidity = data['humidity']?.toString() ?? '—';
      pressure = data['pressure']?.toString() ?? '—';
      _isLoading = false;
    });
  }

  void _handleError(String error) {
    setState(() => _isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error), duration: Duration(seconds: 2)),
    );
  }

  void _handleConnectionEstablished() {
    _showMessage('✅ Подключено к серверу');
    // Запрашиваем текущие данные после подключения
    _sendCommand('3'); 
  }

  Future<void> _toggleConnection() async {
    setState(() => _isLoading = true);
    if (_socketService.isConnected) {
      _socketService.disconnect();
      setState(() {
        temperature = humidity = pressure = '—';
        _isLoading = false;
      });
      _showMessage('🔌 Отключено от сервера');
    } else {
      try {
        _socketService.connect();
      } catch (e) {
        _handleError('Ошибка подключения: $e');
      }
    }
  }

  void _sendCommand(String command) {
    if (!_socketService.isConnected) {
      _showMessage('⚠️ Сначала подключитесь к серверу');
      return;
    }
    setState(() => _isLoading = true);
    _socketService.sendCommand(command);
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), duration: Duration(seconds: 1)),
    );
  }

  @override
  void dispose() {
    _socketService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Управление номером ${widget.roomNumber}'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => _sendCommand('3'),
            tooltip: 'Обновить данные',
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                _buildRoomImage(),
                const SizedBox(height: 20),
                _buildControlPanel(),
                const SizedBox(height: 30),
                _buildSensorDataSection(),
              ],
            ),
          ),
          if (_isLoading)
            Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  Widget _buildRoomImage() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/image.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildControlPanel() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildActionButton(
                'Открыть дверь', 
                Icons.lock_open, 
                () => _sendCommand('6'),
              ),
              _buildActionButton(
                'Закрыть дверь', 
                Icons.lock, 
                () => _sendCommand('5'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildActionButton(
                'Включить свет', 
                Icons.lightbulb_outline, 
                () => _sendCommand('2'),
                color: Colors.green,
              ),
              _buildActionButton(
                'Выключить свет', 
                Icons.lightbulb, 
                () => _sendCommand('4'),
                color: Colors.red,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildConnectionButton(),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, VoidCallback onPressed, {Color? color}) {
    return SizedBox(
      width: 150,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 18),
        label: Text(label, style: TextStyle(fontSize: 13)),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildConnectionButton() {
    return ElevatedButton.icon(
      icon: Icon(
        _socketService.isConnected ? Icons.cancel : Icons.power,
        color: Colors.white,
      ),
      label: Text(
        _socketService.isConnected ? 'Отключиться' : 'Подключиться',
        style: TextStyle(color: Colors.white),
      ),
      onPressed: _toggleConnection,
      style: ElevatedButton.styleFrom(
        backgroundColor: _socketService.isConnected ? Colors.grey[700] : Colors.blue,
        minimumSize: Size(double.infinity, 48),
      ),
    );
  }

  Widget _buildSensorDataSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Датчики', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              _buildSensorRow('Температура', temperature, '°C'),
              _buildSensorRow('Влажность', humidity, '%'),
              _buildSensorRow('Давление', pressure, 'hPa'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSensorRow(String label, String value, String unit) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 16)),
          Text(
            '$value $unit', 
            style: TextStyle(
              fontSize: 16, 
              fontWeight: FontWeight.bold,
              color: _getValueColor(value),
            ),
          ),
        ],
      ),
    );
  }

  Color? _getValueColor(String value) {
    if (value == '—') return Colors.grey;
    return null;
  }
}