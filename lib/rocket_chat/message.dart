class Message {
  final String id;
  final String rid;

  final String msg;
  final String ts;

  Message.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        rid = json['rid'],
        msg = json['msg'],
        ts = json['ts'];
}
