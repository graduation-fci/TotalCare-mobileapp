// import 'dart:developer';

// import 'package:flutter/material.dart';

// import 'package:provider/provider.dart';
// import '../providers/wishListProvider.dart';
// import '../providers/wishProvider.dart';

// class WishListScreen extends StatefulWidget {
//   const WishListScreen({super.key});
//   static const routeName = '/wishlist';

//   @override
//   State<WishListScreen> createState() => _WishListScreenState();
// }

// class _WishListScreenState extends State<WishListScreen> {
//   @override
//   void initState() {
//     Future.delayed(Duration.zero).then((value) {
//       Provider.of<Wish>(context, listen: false).getWishID().then((_) {
//         log('Done');
//         setState(() {});
//       });
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final wishListProvider = Provider.of<Wish>(context);
//     final items = wishListProvider.items;
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           leading: IconButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               icon: const Icon(
//                 Icons.arrow_back,
//                 color: Colors.black87,
//               )),
//           centerTitle: true,
//           elevation: 0,
//           backgroundColor: Colors.white10,
//           title: const Text('Wish List'),
//         ),
//         body: Center(
//           child: Text(items.length.toString()),
//         ),
//       ),
//     );
//   }
// }

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:grad_login/providers/wishProvider.dart';
import 'package:provider/provider.dart';

class WishListScreen extends StatefulWidget {
  static const routeName = '/wishList';

  const WishListScreen({super.key});

  @override
  State<WishListScreen> createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      Provider.of<Wish>(context, listen: false).getWishID().then((_) {
        setState(() {});
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final wishProvider = Provider.of<Wish>(context);
    final items = wishProvider.items;
    log('message');
    log(items.toString());
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text('WISH LIST'),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black87,
            )),
      ),
      body: items.isEmpty
          ? const Center(
              child: Text(
                'WISH LIST IS EMPTY!',
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
                          itemCount: items.length,
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
                                      borderRadius: BorderRadius.circular(20),
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
                                      deleteWishItem(
                                          context, items[index]['id']);
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
                                                imageUrl: items[index]
                                                    ['product']['images'][0],
                                                fit: BoxFit.cover,
                                              ),
                                            )),
                                        title: Text(
                                          items[index]['product']['name'],
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        subtitle: Text(
                                            '${items[index]['product']['price']} L.E.'),
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
                  ))
                ],
              );
            }
              //                                 child: Padding(
              //                                   padding: const EdgeInsets.all(8.0),
              //                                   child: ListTile(
              //                                     leading: ClipRRect(
              //                                         borderRadius:
              //                                             BorderRadius.circular(10),
              //                                         child: SizedBox(
              //                                           height: 90,
              //                                           width: 90,
              //                                           child: CachedNetworkImage(
              //                                             width: 75,
              //                                             height: 75,
              //                                             imageUrl:
              //                                                 items[index].imgURL,
              //                                             fit: BoxFit.cover,
              //                                           ),
              //                                         )),
              //                                     title: Text(
              //                                       items[index].name,
              //                                       maxLines: 2,
              //                                       overflow: TextOverflow.ellipsis,
              //                                     ),
              //                                     subtitle: Text(
              //                                         '${items[index].price} L.E.'),
              //                                     trailing: SizedBox(
              //                                       height: 100,
              //                                       width: 100,
              //                                       child: Column(
              //                                         mainAxisAlignment:
              //                                             MainAxisAlignment.end,
              //                                         // crossAxisAlignment: CrossAxisAlignment.end,
              //                                         children: [
              //                                           Row(
              //                                             crossAxisAlignment:
              //                                                 CrossAxisAlignment
              //                                                     .end,
              //                                             mainAxisAlignment:
              //                                                 MainAxisAlignment
              //                                                     .spaceBetween,
              //                                             children: [
              //                                               SizedBox(
              //                                                 width: 30,
              //                                                 height: 30,
              //                                                 child: Container(
              //                                                   decoration:
              //                                                       BoxDecoration(
              //                                                     color:
              //                                                         Colors.white,
              //                                                     shape: BoxShape
              //                                                         .circle,
              //                                                     border: Border.all(
              //                                                         color: Colors
              //                                                             .grey,
              //                                                         width: 1),
              //                                                   ),
              //                                                   child: IconButton(
              //                                                     padding:
              //                                                         const EdgeInsets
              //                                                             .all(0),
              //                                                     icon: items[index]
              //                                                                 .quantity ==
              //                                                             1
              //                                                         ? const Icon(
              //                                                             Icons
              //                                                                 .delete,
              //                                                             color: Colors
              //                                                                 .red,
              //                                                             size: 18,
              //                                                           )
              //                                                         : const Icon(
              //                                                             Icons
              //                                                                 .remove,
              //                                                             size: 18,
              //                                                           ),
              //                                                     color:
              //                                                         Colors.grey,
              //                                                     onPressed: items[
              //                                                                     index]
              //                                                                 .quantity ==
              //                                                             1
              //                                                         ? () {}
              //                                                         // deleteCartItem(
              //                                                         //   context,
              //                                                         //   items,
              //                                                         //   index,
              //                                                         // )
              //                                                         : () async {
              //                                                             // await updateCartItem(
              //                                                             //   items,
              //                                                             //   index,
              //                                                             //   context,
              //                                                             // );
              //                                                           },
              //                                                   ),
              //                                                 ),
              //                                               ),
              //                                               Text(
              //                                                 items[index]
              //                                                     .quantity
              //                                                     .toString(),
              //                                                 //number.toString(),
              //                                                 style:
              //                                                     const TextStyle(
              //                                                   fontSize: 18,
              //                                                 ),
              //                                               ),
              //                                               SizedBox(
              //                                                 width: 30,
              //                                                 height: 30,
              //                                                 child: Container(
              //                                                   decoration:
              //                                                       BoxDecoration(
              //                                                     color:
              //                                                         Colors.white,
              //                                                     shape: BoxShape
              //                                                         .circle,
              //                                                     border: Border.all(
              //                                                         color: Colors
              //                                                             .grey,
              //                                                         width: 1),
              //                                                   ),
              //                                                   child: IconButton(
              //                                                     padding:
              //                                                         const EdgeInsets
              //                                                             .all(0),
              //                                                     icon: const Icon(
              //                                                       Icons.add,
              //                                                       size: 18,
              //                                                     ),
              //                                                     color:
              //                                                         Colors.grey,
              //                                                     onPressed: () {
              //                                                       // items[index]
              //                                                       //     .quantity++;
              //                                                       // Provider.of<Cart>(
              //                                                       //         context,
              //                                                       //         listen:
              //                                                       //             false)
              //                                                       //     .updateCart(
              //                                                       //         items[index]
              //                                                       //             .id,
              //                                                       //         items[index]
              //                                                       //             .quantity)
              //                                                       //     .then((_) {
              //                                                       //   ScaffoldMessenger.of(
              //                                                       //           context)
              //                                                       //       .removeCurrentSnackBar();
              //                                                       //   ScaffoldMessenger.of(
              //                                                       //           context)
              //                                                       //       .showSnackBar(const SnackBar(
              //                                                       //           content:
              //                                                       //               Text('Item updated Successfully!')));
              //                                                       //   setState(
              //                                                       //       () {});
              //                                                       // });
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                               ),
              //                                             ],
              //                                           ),
              //                                           Text(
              //                                               '${items[index].totalPrice} L.E.')
              //                                         ],
              //                                       ),
              //                                     ),
              //                                   ),
              //                                 ),
              //                               ),
              //                             ),
              //                             const SizedBox(
              //                               height: 30,
              //                             ),
              //                           ],
              //                         );
              //                       },
              //                     ),
              //                   ),
              //                 ),
              //               ),
              //             ),
              //           ],
              //         );
              // })
              ),
    ));
  }

  void deleteWishItem(BuildContext context, int index) {
    Provider.of<Wish>(context, listen: false).deleteWish(2, index);
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Item Deleted Successfully!'),
      ),
    );
  }
}
