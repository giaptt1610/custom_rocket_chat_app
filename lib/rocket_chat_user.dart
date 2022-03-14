class RocketChatUser {
  final String userId;
  final String authToken;
  final Me me;

  RocketChatUser({
    required this.userId,
    required this.authToken,
    required this.me,
  });

  factory RocketChatUser.fromJson(Map<String, dynamic> json) {
    return RocketChatUser(
      userId: json['userId'] as String,
      authToken: json['authToken'] as String,
      me: Me.fromJson(json['me'] as Map<String, dynamic>),
    );
  }
}

class Me {
  final String id;
  final String name;
  final String username;
  final String avatarUrl;

  Me({this.id = '', this.name = '', this.username = '', this.avatarUrl = ''});

  factory Me.fromJson(Map<String, dynamic> json) {
    return Me(
        id: json['_id'],
        name: json['name'],
        username: json['username'],
        avatarUrl: json['avatarUrl']);
  }
}
