import 'dart:convert';

class Helper {
  static String pongMsg() {
    return jsonEncode({'msg': 'pong'});
  }

  static String connectMsg() {
    return jsonEncode({
      'msg': 'connect',
      'version': '1',
      'support': ['1', 'pre2', 'pre1']
    });
  }

  static String getRoomsMsg() {
    return jsonEncode({
      "msg": "method",
      "method": "rooms/get",
      "id": "42",
      "params": [
        {"\$date": 0}
      ]
    });
  }

  static String subscribeMsg() {
    return jsonEncode({
      "msg": "method",
      "method": "subscriptions/get",
      "id": "42",
      "params": []
    });
  }

  static String streamNotifyUser() {
    return jsonEncode({
      "msg": "sub",
      "id": "unique-id",
      "name": "stream-notify-user",
      "params": ["user-id/event", false]
    });
  }

  static String streamNotifyRoom() {
    return jsonEncode({
      "msg": "sub",
      "id": "unique-id",
      "name": "stream-notify-room",
      "params": ["room-id/event", false]
    });
  }

  static String listCustomEmoji() {
    return jsonEncode({
      "msg": "method",
      "method": "listEmojiCustom",
      "id": "42",
      "params": []
    });
  }
}
