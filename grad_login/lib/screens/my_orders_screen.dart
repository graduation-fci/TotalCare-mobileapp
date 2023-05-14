import 'package:flutter/material.dart';
import 'package:grad_login/app_state.dart';
import 'package:grad_login/providers/orders_provider.dart';
import 'package:provider/provider.dart';

import '../widgets/order_item.dart';

class MyOrdersScreen extends StatefulWidget {
  static const String routeName = 'my-orders-screen';
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  int _selectedPageIndex = 0;

  @override
  void initState() {
    Future.delayed(Duration.zero).then(
        (_) => Provider.of<OrdersProvider>(context, listen: false).getOrders());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<OrdersProvider>(context);
    final ordersData = ordersProvider.getOrdersData;
    final mediaQuery = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: ordersProvider.appState == AppState.error
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 110,
                width: double.infinity,
                child: CustomScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  slivers: [
                    SliverAppBar(
                      centerTitle: true,
                      backgroundColor: Colors.white,
                      pinned: true,
                      elevation: 0,
                      leading: IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
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
                  ],
                ),
              ),
              ordersProvider.appState == AppState.error
                  ? Center(
                      child: Text(
                        '${ordersProvider.errorMsg}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(20),
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return orderItem(context ,ordersData, index);
                        },
                        itemCount: ordersData.length,
                      ),
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
