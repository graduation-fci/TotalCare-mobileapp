import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/orders_provider.dart';
import '../screens/singe_order_screen.dart';

class OrderItem extends StatelessWidget {
  final BuildContext context;
  final List<dynamic> orderResponse;
  final String orderStatus;
  final int index;
  const OrderItem(
      this.context, this.orderResponse, this.orderStatus, this.index,
      {super.key});

  @override
  Widget build(BuildContext context) {
    final singleOrder = orderResponse[index];
    final DateTime orderDate = DateTime.parse(singleOrder['placed_at']);
    final String formattedDate = DateFormat('MM/dd/yyyy').format(orderDate);
    Color? statusColor;
    if (orderStatus == 'Pending') {
      statusColor = Colors.orange;
    }
    if (orderStatus == 'Canceled') {
      statusColor = Colors.red;
    }
    if (orderStatus == 'Confirmed') {
      statusColor = Colors.green;
    }
    if (orderStatus == 'Failed') {
      statusColor = Colors.red;
    }
    return GestureDetector(
      onTap: () async {
        await Provider.of<OrdersProvider>(context, listen: false)
            .getSingleOrder(singleOrder['id'])
            .then((value) => Navigator.of(context).pushNamed(
                SingleOrderScreen.routeName,
                arguments: singleOrder['id']));
      },
      child: Container(
        height: 120,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.black.withOpacity(0.4),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Total price: ',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      TextSpan(
                        text: singleOrder['total_price'].toString(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    // color: Colors.green,
                    boxShadow: [
                      BoxShadow(
                        blurStyle: BlurStyle.inner,
                        blurRadius: 3,
                        color: statusColor!,
                      ),
                    ],
                  ),
                )
              ],
            ),
            Text(
              'Address: ${singleOrder['address']['street']} ${singleOrder['address']['city']}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: customTextStyle(),
            ),
            const Spacer(),
            IntrinsicHeight(
              child: Row(
                children: [
                  RichText(
                      text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Placed at: $formattedDate \n',
                        style: customTextStyle(),
                      ),
                      TextSpan(
                        text: 'Status: $orderStatus',
                        style: customTextStyle(),
                      )
                    ],
                  )),
                  const Spacer(),
                  const VerticalDivider(
                    width: 30,
                    thickness: 0.5,
                    color: Colors.black,
                  ),
                  RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Payment method:\n\n',
                            style: customTextStyle(),
                          ),
                          const TextSpan(
                            text: 'Cash',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

TextStyle customTextStyle() {
  return const TextStyle(
    // fontSize: 12,
    color: Colors.black,
  );
}
