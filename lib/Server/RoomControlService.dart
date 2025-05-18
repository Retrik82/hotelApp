import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_hotel/protos/lib/protos/device.pb.dart'; // Импорт сгенерированных классов protobuf
import 'package:protobuf/protobuf.dart'; // Для GeneratedMessage


class NeuralSocketService {
  final String serverUrl;
  late WebSocketChannel _channel;
  bool _isConnected = false;

  // Используем предполагаемый класс DeviceCommand вместо ControllerResponse
  final Function(DeviceCommand)? onResponseReceived;
  final Function(String)? onError;
  final Function()? onConnectionEstablished;

  NeuralSocketService({
    this.serverUrl = 'wss://hotelbackend-cd6n.onrender.com/ws',
    this.onResponseReceived,
    this.onError,
    this.onConnectionEstablished,
  });

  void connect() {
    try {
      _channel = WebSocketChannel.connect(Uri.parse(serverUrl));
      _isConnected = true;

      _channel.stream.listen(
        (data) {
          if (data is List<int>) {
            try {
              // Десериализуем данные в DeviceCommand (замените на правильный класс)
              final response = DeviceCommand.fromBuffer(data);
              onResponseReceived?.call(response);
            } catch (e) {
              onError?.call('Protobuf parsing error: $e');
            }
          } else {
            onError?.call('Unexpected data type received');
          }
        },
        onError: (error) => onError?.call('WebSocket error: $error'),
        onDone: () => _isConnected = false,
      );

      onConnectionEstablished?.call();

    } catch (e) {
      onError?.call('Connection failed: $e');
    }
  }

  // Отправляем сообщение на сервер - это должен быть один из твоих protobuf классов
  void sendCommand(GeneratedMessage command) {
    if (!_isConnected) {
      onError?.call('Not connected to server');
      return;
    }

    try {
      _channel.sink.add(command.writeToBuffer());
    } catch (e) {
      onError?.call('Failed to send command: $e');
    }
  }

  void disconnect() {
    if (_isConnected) {
      _channel.sink.close();
      _isConnected = false;
    }
  }

  bool get isConnected => _isConnected;
}