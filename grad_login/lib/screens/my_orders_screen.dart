import 'package:flutter/material.dart';

import '../widgets/order_item.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  int _selectedPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 110,
                child: CustomScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  slivers: [
                    SliverAppBar(
                      backgroundColor: Colors.white,
                      pinned: true,
                      elevation: 0,
                      title: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        child: Text(
                          'My Orders',
                          style: Theme.of(context)
                              .appBarTheme
                              .titleTextStyle!
                              .copyWith(
                                fontSize: mediaQuery.width * 0.07,
                              ),
                        ),
                      ),
                    ),
                    SliverAppBar(
                      primary: false,
                      pinned: true,
                      backgroundColor: Colors.white,
                      elevation: 0,
                      title: topNavBar(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: orderItem(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container topNavBar() {
    // ignore: sized_box_for_whitespace
    return Container(
      height: 35,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          statusItem('Confirmed', 0),
          statusItem('Pending', 1),
          statusItem('Canceled', 2),
          statusItem('Failed', 3),
        ],
      ),
    );
  }

  GestureDetector statusItem(String text, int index) {
    return GestureDetector(
      onTap: () => {
        _selectPage(index),
      },
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(left: 15),
        decoration: _selectedPageIndex == index
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).colorScheme.secondary,
              )
            : null,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: _selectedPageIndex == index ? Colors.white : Colors.grey,
              fontWeight: _selectedPageIndex == index
                  ? FontWeight.bold
                  : FontWeight.normal,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }
}
