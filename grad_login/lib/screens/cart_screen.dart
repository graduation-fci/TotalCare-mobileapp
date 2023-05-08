import 'package:flutter/material.dart';
import 'package:grad_login/providers/cartProvider.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  static const routeName = '/cart-screen';

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isLoading = true;
  String _cartID = '';
  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      Provider.of<Cart>(context, listen: false).getCartID().then((_) {
        final token = Provider.of<Cart>(context, listen: false).cartID;
        Provider.of<Cart>(context, listen: false).fetchCart(token);
        _cartID = token;
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final carts = Provider.of<Cart>(context).items;
    final cartPrice = Provider.of<Cart>(context).cartPrice;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Text('Cart'),
          centerTitle: true,
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator.adaptive(),
              )
            : carts == []
                ? const Center(
                    child: Text('No items in cart!'),
                  )
                : LayoutBuilder(builder: (context, constraints) {
                    return Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                  minHeight: constraints.maxHeight),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 20),
                                child: ListView.builder(
                                  itemCount: carts.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Column(
                                      children: [
                                        Dismissible(
                                          key: UniqueKey(),
                                          background: Container(
                                            color: Colors.red,
                                            child: const Align(
                                              alignment: Alignment.centerRight,
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.only(right: 20),
                                                child: Icon(
                                                  Icons.delete,
                                                  color: Colors.white,
                                                  size: 30,
                                                ),
                                              ),
                                            ),
                                          ),
                                          direction:
                                              DismissDirection.endToStart,
                                          onDismissed: (direction) {
                                            print('Deleting');
                                            try {
                                              Provider.of<Cart>(context,
                                                      listen: false)
                                                  .deleteCart(
                                                      _cartID, carts[index].id);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      'Item Deleted Successfully!'),
                                                ),
                                              );
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
                                                      BorderRadius.circular(
                                                          20)),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: ListTile(
                                                leading: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Image.network(
                                                    carts[index].imgURL,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                title: Text(
                                                  carts[index].name,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                                            CrossAxisAlignment
                                                                .end,
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
                                                                color: Colors
                                                                    .white,
                                                                shape: BoxShape
                                                                    .circle,
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .grey,
                                                                    width: 1),
                                                              ),
                                                              child: IconButton(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(0),
                                                                icon:
                                                                    const Icon(
                                                                  Icons.remove,
                                                                  size: 18,
                                                                ),
                                                                color:
                                                                    Colors.grey,
                                                                onPressed:
                                                                    () async {
                                                                  carts[index]
                                                                      .quantity--;
                                                                  await Provider.of<
                                                                              Cart>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .updateCart(
                                                                          _cartID,
                                                                          carts[index]
                                                                              .id,
                                                                          carts[index]
                                                                              .quantity)
                                                                      .then(
                                                                          (_) {
                                                                    ScaffoldMessenger.of(
                                                                            context)
                                                                        .showSnackBar(const SnackBar(
                                                                            content:
                                                                                Text('Item upadted Successfully!')));
                                                                    setState(
                                                                        () {});
                                                                  });
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                          Text(
                                                            carts[index]
                                                                .quantity
                                                                .toString(),
                                                            //number.toString(),
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 18,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 30,
                                                            height: 30,
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                shape: BoxShape
                                                                    .circle,
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .grey,
                                                                    width: 1),
                                                              ),
                                                              child: IconButton(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(0),
                                                                icon:
                                                                    const Icon(
                                                                  Icons.add,
                                                                  size: 18,
                                                                ),
                                                                color:
                                                                    Colors.grey,
                                                                onPressed: () {
                                                                  carts[index]
                                                                      .quantity++;
                                                                  Provider.of<Cart>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .updateCart(
                                                                          _cartID,
                                                                          carts[index]
                                                                              .id,
                                                                          carts[index]
                                                                              .quantity)
                                                                      .then(
                                                                          (_) {
                                                                    ScaffoldMessenger.of(
                                                                            context)
                                                                        .showSnackBar(const SnackBar(
                                                                            content:
                                                                                Text('Item upadted Successfully!')));
                                                                    setState(
                                                                        () {});
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
                        Container(
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
                                  onPressed: () {},
                                  child: const Text('Continue'),
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
}
