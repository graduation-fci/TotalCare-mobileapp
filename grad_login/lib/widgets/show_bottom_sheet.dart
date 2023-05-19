import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cartProvider.dart';
import '../providers/addressProvider.dart';
import '../providers/orders_provider.dart';
import '../screens/address_screen.dart';
import '../screens/my_orders_screen.dart';

class ShowBottomSheet {
  int? _selectedItem = 0;
  int? addressId;
  showBottomSheet(BuildContext context, OrdersProvider ordersProvider,
      List<AddressItem> myAddresses, String cartId) async {
    log(myAddresses.toString());
    addressId = myAddresses.isEmpty ? null : myAddresses[0].id;
    final double listviewHeight = myAddresses.isEmpty ? 325 : 265;
    const double buttonHeight = 60;
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 400,
          child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Column(
              children: [
                SizedBox(
                  height: listviewHeight,
                  child: myAddresses.isEmpty
                      ? const Center(
                          child: Text(
                            'You have no Address',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemBuilder: ((context, index) {
                            return Container(
                              margin: const EdgeInsets.only(
                                  top: 15, left: 20, right: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(color: Colors.black38, width: 1),
                              ),
                              child: RadioListTile(
                                title: Text(
                                  myAddresses[index].title,
                                ),
                                subtitle: Text(
                                    '${myAddresses[index].street}, ${myAddresses[index].city}'),
                                value: index,
                                groupValue: _selectedItem,
                                onChanged: (int? value) {
                                  setState(
                                    () {
                                      _selectedItem = value;
                                      addressId = myAddresses[index].id;
                                    },
                                  );
                                },
                              ),
                            );
                          }),
                          itemCount: myAddresses.length,
                        ),
                ),
                myAddresses.isEmpty
                    ? Container()
                    : Container(
                        width: double.infinity,
                        height: buttonHeight,
                        padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          )),
                          onPressed: () async {
                            await ordersProvider
                                .placeOrder(addressId!, cartId)
                                .then((_) {
                              Provider.of<Cart>(context, listen: false)
                                  .fetchCart();
                              Navigator.of(context).pushReplacementNamed(
                                  MyOrdersScreen.routeName);
                            });
                          },
                          child: Text(
                            'Place order',
                            style: Theme.of(context).textTheme.button!.copyWith(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.045),
                          ),
                        ),
                      ),
                Container(
                  width: double.infinity,
                  height: buttonHeight,
                  margin: const EdgeInsets.only(bottom: 15),
                  padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    )),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.of(context).pushNamed(AddressScreen.routeName);
                    },
                    child: Text(
                      'Add address',
                      style: Theme.of(context).textTheme.button!.copyWith(
                          fontSize: MediaQuery.of(context).size.width * 0.045),
                    ),
                  ),
                ),
              ],
            );
          }),
        );
      },
    );
  }
}
