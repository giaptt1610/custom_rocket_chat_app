import 'package:flutter/material.dart';

class DirectChat extends StatefulWidget {
  final String username;
  final String userId;
  DirectChat({required this.username, required this.userId, Key? key})
      : super(key: key);

  @override
  State<DirectChat> createState() => _DirectChatState();
}

class _DirectChatState extends State<DirectChat> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.username}'),
      ),
      body: Container(
        child: StreamBuilder(
          builder: (context, snapshot) {
            return Text('');
          },
        ),
      ),
    );
  }
}
