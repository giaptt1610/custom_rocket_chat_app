import 'package:flutter/material.dart';
import 'rocket_chat/models.dart';

class ChannelItem extends StatelessWidget {
  final Room room;
  final User curUser;
  final VoidCallback? onTap;
  const ChannelItem(
      {required this.room, required this.curUser, this.onTap, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(),
        child: Row(
          children: [
            Text(room.name ??
                room.targetUsername(curUname: curUser.me.username)),
          ],
        ),
      ),
    );
  }
}
