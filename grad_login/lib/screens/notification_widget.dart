import 'package:flutter/material.dart';

class NotificationIcon extends StatefulWidget {
  const NotificationIcon({super.key});

  @override
  State<NotificationIcon> createState() => _NotificationIconState();
}

class _NotificationIconState extends State<NotificationIcon> {
  final _counter = 0;

  @override
  Widget build(BuildContext context) {
    final mediaquery = MediaQuery.of(context).size.height;

    return SizedBox(
      width: mediaquery * 0.04,
      height: mediaquery * 0.04,
      child: Stack(
        children: [
          Icon(
            Icons.notifications,
            color: Colors.black,
            size: mediaquery * 0.04,
          ),
          Container(
            width: mediaquery * 0.04,
            height: mediaquery * 0.04,
            alignment: Alignment.topRight,
            margin: EdgeInsets.only(top: mediaquery * 0.003),
            child: Container(
              width: mediaquery * 0.02,
              height: mediaquery * 0.02,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xffc32c37),
                  border: Border.all(color: Colors.white, width: 1)),
              child: Center(
                child: Text(
                  _counter.toString(),
                  style: TextStyle(
                      fontSize: mediaquery * 0.015, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
