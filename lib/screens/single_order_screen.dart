import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:grad_login/providers/orders_provider.dart';
import 'package:grad_login/widgets/show_bottom_sheet.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../widgets/show_custom_dialog.dart';

class SingleOrderScreen extends StatefulWidget {
  static const String routeName = 'single-order-screen';
  const SingleOrderScreen({super.key});

  @override
  State<SingleOrderScreen> createState() => _SingleOrderScreenState();
}

class _SingleOrderScreenState extends State<SingleOrderScreen> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    final ordersProvider = Provider.of<OrdersProvider>(context);
    final orderData = Provider.of<OrdersProvider>(context).getSingleOrderData;
    final medicineList = orderData['items'];
    final DateTime orderDate = DateTime.parse(orderData['placed_at']);
    final String formattedDate = DateFormat('MM/dd/yyyy').format(orderDate);

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
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
                          formattedDate,
                          style: Theme.of(context)
                              .appBarTheme
                              .titleTextStyle!
                              .copyWith(
                                fontSize: mediaQuery.width * 0.05,
                              ),
                        ),
                      ),
                      actions: [
                        orderData['order_status'] == 'PEN'
                            ? TextButton(
                                onPressed: () {
                                  showCustomDialog(
                                    context,
                                    const Text(
                                      'Are you sure?',
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text(
                                      'Do you want to cancel this order?',
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                    <Widget>[
                                      Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 20, 12),
                                        width: 120,
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                            backgroundColor: Colors.red,
                                          ),
                                          onPressed: () => cancelOrder(
                                              ordersProvider, orderData['id']),
                                          child: const Text(
                                            'Yes',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 20, 12),
                                        width: 120,
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                            backgroundColor: Colors.grey,
                                          ),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text(
                                            'No',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                                child: Text(
                                  'Cancel Order',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.red.shade800),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ],
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CachedNetworkImage(
                      width: 50,
                      height: 50,
                      imageUrl: medicineList[index]['product']['images'][0],
                      fit: BoxFit.cover,
                    ),
                    title: Text(medicineList[index]['product']['name']),
                    subtitle: Text(
                        medicineList[index]['product']['price'].toString()),
                  );
                },
                itemCount: medicineList.length,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void cancelOrder(OrdersProvider ordersProvider, int id) async {
    await ordersProvider.cancelOrder(id).then((_) => Navigator.pop(context));
  }
}
