import 'dart:convert';

import 'package:http/http.dart' as http;

import 'rocket_chat/models.dart';

class Api {
  static const HOST = 'http://10.1.38.174:3000';
  Future<User?> login({
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
        final user = User.fromJson(json['data']);

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

  Future<List<Room>> getListChannels({
    required String authToken,
    required String userId,
  }) async {
    try {
      var url = '$HOST/api/v1/channels.info';
      final response = await http.get(
        Uri.parse('$HOST/api/v1/channels.list'),
        headers: {
          'X-Auth-Token': authToken,
          'X-User-Id': userId,
        },
      );

      final channels = jsonDecode(response.body)['channels'] as List;
      final list = channels.map((e) => Room.fromJson(e)).toList();

      return list;
    } catch (e) {
      print('Exception: ${e.toString()}');
      return [];
    }
  }

  Future<List<Room>> getListRooms({
    required String authToken,
    required String userId,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$HOST/api/v1/rooms.get'),
        headers: {
          'X-Auth-Token': authToken,
          'X-User-Id': userId,
        },
      );

      final rooms = jsonDecode(response.body)['update'] as List;
      final list = rooms.map((e) => Room.fromJson(e)).toList();

      return list;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}
