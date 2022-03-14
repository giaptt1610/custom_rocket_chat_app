import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rocket_chat_client/pages/direct_chat.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'api.dart';
import 'channel_item.dart';
import 'helper.dart';
import 'rocket_chat/models.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _controller = TextEditingController();
  final _userController = TextEditingController();
  final _passController = TextEditingController();
  final _api = Api();
  User? _user;
  bool _loading = false;

  final _channel = WebSocketChannel.connect(
    Uri.parse('ws://10.1.38.174:3000/websocket'),
  );
  late StreamSubscription _streamSubscription;

  late StreamController messageStream;

  @override
  void initState() {
    super.initState();
    messageStream = StreamController();
    _streamSubscription = _channel.stream.listen((event) {
      _handleMessageFromServer(event);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: _user == null
            ? Column(
                children: [
                  TextFormField(
                    controller: _userController,
                    decoration: const InputDecoration(
                      labelText: 'user',
                      hintText: 'username/email',
                    ),
                  ),
                  TextFormField(
                    controller: _passController,
                    decoration: const InputDecoration(labelText: 'password'),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          _loading = true;
                        });
                        final result = await _api.login(
                          user: _userController.text.trim(),
                          password: _passController.text.trim(),
                        );

                        setState(() {
                          _loading = false;
                        });
                        if (result != null) {
                          setState(() {
                            _user = result;
                          });
                        }
                      },
                      child: Text('Login')),
                  _loading ? CircularProgressIndicator() : SizedBox(),
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('username: ${_user!.me.username}'),
                  Text('userId: ${_user!.userId}'),
                  Text('authToken: ${_user!.authToken}'),
                  Wrap(
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            _channel.sink.add(Helper.connectMsg());
                          },
                          child: const Text('connect')),
                      ElevatedButton(
                          onPressed: () {
                            _channel.sink.add(Helper.subscribeMsg());
                          },
                          child: const Text('subscribe')),
                      ElevatedButton(
                          onPressed: () {
                            _channel.sink.add(Helper.getRoomsMsg());
                          },
                          child: const Text('get rooms')),
                    ],
                  ),
                  Expanded(
                    child: Container(
                      child: FutureBuilder(
                        future: _api.getListRooms(
                            authToken: _user!.authToken, userId: _user!.userId),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return CircularProgressIndicator();
                          }

                          final listRooms = snapshot.data as List<Room>;
                          final directMsgRoom = listRooms
                              .where((element) => element.isDirectMsgRoom)
                              .toList();
                          final channels = listRooms
                              .where((element) => !element.isDirectMsgRoom)
                              .toList();

                          final content = [
                            const Text(
                              'Channels',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            ...channels
                                .map((e) => ChannelItem(
                                      room: e,
                                      curUser: _user!,
                                      onTap: () {},
                                    ))
                                .toList(),
                            const Text(
                              'Direct Messages',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            ...directMsgRoom
                                .map((e) => ChannelItem(
                                      room: e,
                                      curUser: _user!,
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                                builder: (context) =>
                                                    DirectChat(
                                                      userId: e.targetUserId(
                                                          curUid:
                                                              _user!.userId),
                                                      username:
                                                          e.targetUsername(
                                                              curUname: _user!
                                                                  .me.username),
                                                    )));
                                      },
                                    ))
                                .toList(),
                          ];

                          return SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: content,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    height: 100,
                    child: StreamBuilder(
                      stream: messageStream.stream,
                      builder: (context, snapshot) {
                        return Text(snapshot.hasData ? '${snapshot.data}' : '');
                      },
                    ),
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_controller.text.isNotEmpty) {
            _channel.sink.add(_controller.text);
          }
        },
        tooltip: 'Send',
        child: const Icon(Icons.send),
      ),
    );
  }

  @override
  void dispose() {
    _userController.dispose();
    _passController.dispose();
    _channel.sink.close();
    super.dispose();
  }

  void _handleMessageFromServer(String message) {
    final json = _parse(message);
    final msg = json['msg'];
    if (msg == 'ping') {
      _channel.sink.add(Helper.pongMsg());
      print('-- handled ping msg');
    } else if (msg == 'connected') {
      print('--session: ${json['session']}');
    } else {
      print('-- $json');
      messageStream.sink.add(message);
    }
  }

  Map<String, dynamic> _parse(String data) {
    try {
      final json = jsonDecode(data as String);

      return json;
    } catch (e) {
      print('handle ping-pong exception: ${e.toString()}');
      return {'msg': ''};
    }
  }
}
