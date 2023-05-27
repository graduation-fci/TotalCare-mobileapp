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
                height: 60,
                width: double.infinity,
                child: CustomScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  slivers: [
                    SliverAppBar(
                      centerTitle: true,
                      backgroundColor: Colors.transparent,
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
                          String? orderStatus;
                          if (ordersData[index]['order_status'] == 'PEN') {
                            orderStatus = 'Pending';
                          } else if (ordersData[index]['order_status'] ==
                              'CAN') {
                            orderStatus = 'Canceled';
                          } else if (ordersData[index]['order_status'] ==
                              'CON') {
                            orderStatus = 'Confirmed';
                          } else {
                            orderStatus = 'Failed';
                          }
                          return OrderItem(
                              context, ordersData, orderStatus, index);
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
}
