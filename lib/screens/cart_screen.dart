import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:grad_login/widgets/show_bottom_sheet.dart';
import 'package:provider/provider.dart';
import '../providers/cartProvider.dart';
import '../providers/orders_provider.dart';
import '../providers/addressProvider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  static const routeName = '/cart-screen';

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  ShowBottomSheet showBottomSheet = ShowBottomSheet();
  int? addressId;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      Provider.of<Cart>(context, listen: false).fetchCart();

      Provider.of<Address>(context, listen: false).fetchAddress();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<Cart>(context);
    final ordersProvider = Provider.of<OrdersProvider>(context);
    final addressProvider = Provider.of<Address>(context);
    final myAddresses = addressProvider.items;
    final carts = cartProvider.items;
    final cartPrice = cartProvider.cartPrice;
    final cartId = cartProvider.cartID;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Text('Cart'),
          centerTitle: true,
        ),
        body: carts.isEmpty
            ? const Center(
                child: Text(
                  'You have not added items to cart yet!',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              )
            : LayoutBuilder(builder: (context, constraints) {
                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints:
                              BoxConstraints(minHeight: constraints.maxHeight),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 20),
                            child: ListView.builder(
                              itemCount: carts.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                return Column(
                                  children: [
                                    Dismissible(
                                      key: UniqueKey(),
                                      background: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: const Align(
                                          alignment: Alignment.centerRight,
                                          child: Padding(
                                            padding: EdgeInsets.only(right: 20),
                                            child: Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                              size: 30,
                                            ),
                                          ),
                                        ),
                                      ),
                                      direction: DismissDirection.endToStart,
                                      onDismissed: (direction) {
                                        try {
                                          deleteCartItem(context, carts, index);
                                        } catch (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Deleting Failed',
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      child: Ink(
                                        height: 100,
                                        decoration: ShapeDecoration(
                                          shape: RoundedRectangleBorder(
                                              side: const BorderSide(
                                                width: 1,
                                                color: Colors.black12,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ListTile(
                                            leading: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: SizedBox(
                                                height: 90,
                                                width: 90,
                                                child: CachedNetworkImage(
                                                  width: 75,
                                                  height: 75,
                                                  imageUrl: carts[index]
                                                          .imgURL
                                                          .startsWith('http')
                                                      ? carts[index].imgURL
                                                      : '',
                                                  fit: BoxFit.cover,
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Image.asset(
                                                    'assets/images/temp_med.jpeg',
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            title: Text(
                                              carts[index].name,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            subtitle: Text(
                                                '${carts[index].price} L.E.'),
                                            trailing: SizedBox(
                                              height: 100,
                                              width: 100,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                // crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      SizedBox(
                                                        width: 30,
                                                        height: 30,
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            shape:
                                                                BoxShape.circle,
                                                            border: Border.all(
                                                                color:
                                                                    Colors.grey,
                                                                width: 1),
                                                          ),
                                                          child: IconButton(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(0),
                                                            icon: carts[index]
                                                                        .quantity ==
                                                                    1
                                                                ? const Icon(
                                                                    Icons
                                                                        .delete,
                                                                    color: Colors
                                                                        .red,
                                                                    size: 18,
                                                                  )
                                                                : const Icon(
                                                                    Icons
                                                                        .remove,
                                                                    size: 18,
                                                                  ),
                                                            color: Colors.grey,
                                                            onPressed: carts[
                                                                            index]
                                                                        .quantity ==
                                                                    1
                                                                ? () =>
                                                                    deleteCartItem(
                                                                      context,
                                                                      carts,
                                                                      index,
                                                                    )
                                                                : () async {
                                                                    await updateCartItem(
                                                                      carts,
                                                                      index,
                                                                      context,
                                                                    );
                                                                  },
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        carts[index]
                                                            .quantity
                                                            .toString(),
                                                        //number.toString(),
                                                        style: const TextStyle(
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 30,
                                                        height: 30,
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            shape:
                                                                BoxShape.circle,
                                                            border: Border.all(
                                                                color:
                                                                    Colors.grey,
                                                                width: 1),
                                                          ),
                                                          child: IconButton(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(0),
                                                            icon: const Icon(
                                                              Icons.add,
                                                              size: 18,
                                                            ),
                                                            color: Colors.grey,
                                                            onPressed: () {
                                                              carts[index]
                                                                  .quantity++;
                                                              Provider.of<Cart>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .updateCart(
                                                                      carts[index]
                                                                          .id,
                                                                      carts[index]
                                                                          .quantity)
                                                                  .then((_) {
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .removeCurrentSnackBar();
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(const SnackBar(
                                                                        content:
                                                                            Text('Item updated Successfully!')));
                                                                setState(() {});
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                      '${carts[index].totalPrice} L.E.')
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    cartPrice == '0'
                        ? Container()
                        : Container(
                            height: 120,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white70.withOpacity(0.8),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Total Price: ',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      ' $cartPrice L.E.',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 50,
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      await showBottomSheet.showBottomSheet(
                                        context,
                                        ordersProvider,
                                        myAddresses,
                                        cartId,
                                      );
                                    },
                                    child: Text(
                                      'Continue',
                                      style: Theme.of(context)
                                          .textTheme
                                          .button!
                                          .copyWith(
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.05),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ],
                );
              }),
      ),
    );
  }

  Future<void> updateCartItem(
      List<CartItem> carts, int index, BuildContext context) async {
    carts[index].quantity--;
    await Provider.of<Cart>(context, listen: false)
        .updateCart(carts[index].id, carts[index].quantity)
        .then((_) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item updated Successfully!')));
      setState(() {});
    });
  }

  void deleteCartItem(BuildContext context, List<CartItem> carts, int index) {
    Provider.of<Cart>(context, listen: false).deleteCart(carts[index].id);
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Item Deleted Successfully!'),
      ),
    );
  }
}
