// ignore: file_names
import 'package:web_socket_channel/io.dart';

class Websocket {
  Websocket._();

  factory Websocket() {
    return _instance;
  }

  static final Websocket _instance = Websocket._();

  late IOWebSocketChannel channel;
  bool connected = false;
  bool ledstatus = false;

  channelconnect() {
    try {
      channel =
          IOWebSocketChannel.connect("ws://192.168.0.1:81"); //channel IP : Port
      channel.stream.listen(
        (message) {
          if (message == "connected") {
            connected = true; //message is "connected" from NodeMCU
          } else if (message == "poweron:success") {
            ledstatus = true;
          } else if (message == "poweroff:success") {
            ledstatus = false;
          }
        },
        onDone: () {
          //if WebSocket is disconnected
          connected = false;
        },
        onError: (error) {},
      );
    } catch (_) {}
  }

  Future<void> sendcmd(String cmd) async {
    if (connected == true) {
      if (ledstatus == false && cmd != "poweron" && cmd != "poweroff") {
      } else {
        channel.sink.add(cmd); //sending Command to NodeMCU
      }
    } else {
      channelconnect();
    }
  }
}
