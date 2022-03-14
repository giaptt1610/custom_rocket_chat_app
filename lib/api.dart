import 'dart:convert';

import 'package:rocket_chat_client/rocket_chat_user.dart';
import 'package:http/http.dart' as http;

class Api {
  static const HOST = 'http://10.1.38.174:3000';
  Future<RocketChatUser?> login({
    required String user,
    required String password,
    String? resume,
  }) async {
    try {
      var body = <String, dynamic>{
        'user': user,
        'password': password,
      };
      if (resume != null && resume.isNotEmpty) {
        body.addEntries([MapEntry('resume', resume)]);
      }

      final response = await http.post(
        Uri.parse('$HOST/api/v1/login'),
        body: body,
      );

      final json = jsonDecode(response.body);
      if (json['status'] == 'success') {
        final user = RocketChatUser.fromJson(json['data']);

        return user;
      } else {
        print('Login api status: ${json['status']}, ${json['message']}');
        return null;
      }
    } catch (e) {
      print('Exception: ${e.toString()}');
      return null;
    }
  }
}
