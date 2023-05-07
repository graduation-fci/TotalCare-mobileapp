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
    final mediaquery = MediaQuery.of(context).size;

    return SizedBox(
      width: mediaquery.width * 0.08,
      height: mediaquery.height * 0.04,
      child: Stack(
        children: [
          Icon(
            Icons.notifications,
            color: Colors.black,
            size: mediaquery.width * 0.09,
          ),
          Container(
            width: mediaquery.width * 0.08,
            height: mediaquery.height * 0.04,
            alignment: Alignment.topRight,
            margin: EdgeInsets.only(top: mediaquery.height * 0.003),
            child: Container(
              width: mediaquery.width * 0.05,
              height: mediaquery.height * 0.02,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xffc32c37),
                  border: Border.all(color: Colors.white, width: 1)),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(4.5, 0, 0, 2),
                child: Text(
                  _counter.toString(),
                  style: TextStyle(
                      fontSize: mediaquery.width * 0.031, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
