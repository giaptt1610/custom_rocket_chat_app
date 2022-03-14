import 'message.dart';

class Room {
  final String id;
  final String? name;
  final String? fname;

  /// type of channel
  final String _t;

  final int usersCount;

  final String ts;
  final String updateAt;
  final Message lastMessage;

  final List<dynamic>? usernames;
  final List<dynamic>? uids;

  Room.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        name = json['name'],
        fname = json['fname'],
        _t = json['t'],
        usersCount = json['usersCount'],
        ts = json['ts'],
        updateAt = json['_updatedAt'],
        lastMessage = Message.fromJson(json['lastMessage']),
        usernames = json['usernames'],
        uids = json['uids'];

  String roomType() {
    switch (_t) {
      case 'd':
        return 'Direct chat';
      case 'c':
        return 'Chat';
      case 'p':
        return 'Private chat';
      case 'l':
        return 'Livechat';
      default:
        return 'unknown';
    }
  }

  bool get isDirectMsgRoom => _t == 'd';

  /// get room name if this is direct message
  String targetUsername({required String curUname}) {
    if (_t == 'd' && usernames != null) {
      return usernames!
          .map((e) => e.toString())
          .toList()
          .firstWhere((element) => element != curUname);
    }

    return 'none';
  }

  String targetUserId({required String curUid}) {
    if (_t == 'd' && uids != null) {
      return uids!
          .map((e) => e.toString())
          .toList()
          .firstWhere((element) => element != curUid);
    }

    return '';
  }
}
