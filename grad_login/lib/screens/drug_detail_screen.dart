import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:grad_login/providers/drugProvider.dart';
import 'package:grad_login/screens/love_button.dart';
import 'package:provider/provider.dart';

import '../providers/cartProvider.dart';

class DrugDetailScreen extends StatefulWidget {
  const DrugDetailScreen({super.key});
  static const routeName = '/drug-detail';

  @override
  State<DrugDetailScreen> createState() => _DrugDetailScreenState();
}

class _DrugDetailScreenState extends State<DrugDetailScreen> {
  int number = 1;
  String cartID = '';
  @override
  void initState() {
    Provider.of<Cart>(context, listen: false).getCartID().then((_) {
      final token = Provider.of<Cart>(context, listen: false).cartID;
      cartID = token;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as DrugItem;
    final mediaQuery = MediaQuery.of(context).size;

    return SafeArea(
      child: Stack(
        children: [
          Scaffold(
            // appBar: AppBar(
            //   automaticallyImplyLeading: true,
            // ),
            /*THERE IS NO BACK BUTTON*/
            extendBody: true,
            body: Stack(children: [
              Image.network(
                args.imgURL[0]['image'],
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12, right: 15),
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back)),
                    const Spacer(),
                    const LoveBtn(),
                  ],
                ),
              )
            ]),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 280,
            child: Container(
              height: 580,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
                boxShadow: [
                  BoxShadow(
                    //NEEDS HANDLING
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 35,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Scaffold(
                backgroundColor: Colors.white,
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      args.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: mediaQuery.width * 0.06,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${args.price} L.E.',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: mediaQuery.width * 0.05,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Select Quantity',
                          style: TextStyle(
                            fontSize: mediaQuery.width * 0.05,
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: mediaQuery.width * 0.08,
                          height: mediaQuery.width * 0.08,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey, width: 1),
                            ),
                            child: IconButton(
                              padding: const EdgeInsets.all(0),
                              icon: const Icon(
                                Icons.remove,
                                size: 18,
                              ),
                              color: Colors.grey,
                              onPressed: () {
                                setState(() {
                                  number--;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          number.toString(),
                          style: TextStyle(
                            fontSize: mediaQuery.width * 0.05,
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: mediaQuery.width * 0.08,
                          height: mediaQuery.width * 0.08,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey, width: 1),
                            ),
                            child: IconButton(
                              padding: const EdgeInsets.all(0),
                              icon: const Icon(
                                Icons.add,
                                size: 18,
                              ),
                              color: Colors.grey,
                              onPressed: () {
                                setState(() {
                                  number++;
                                });
                              },
                            ),
                          ),
                        ),

                        // IconButton(
                        //     iconSize: 30,
                        //     onPressed: () {
                        //       setState(() {
                        //         number++;
                        //       });
                        //     },
                        //     icon: widget(
                        //       child: Icon(
                        //         Icons.add,
                        //         color: Colors.white,
                        //         // color: Colors.red,
                        //       ),
                        //     ))
                      ],
                    ),
                    const Text(
                      'Ingredients: ',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    args.drugsList.isEmpty
                        ? const Text(
                            'No ingredients found for this item',
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Text('${args.drugsList[index]['name']}');
                            },
                            itemCount: args.drugsList.length,
                          ),
                  ],
                ),
                floatingActionButton: Padding(
                  padding: const EdgeInsets.only(left: 28),
                  child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: FloatingActionButton.extended(
                        backgroundColor: Theme.of(context).primaryColor,
                        onPressed: () async {
                          await Provider.of<Cart>(context, listen: false)
                              .addCart(cartID, args.id, number)
                              .then((_) {
                            setState(() {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Item added Successfully!')));
                            });
                          });
                          // log(args.id.toString());
                          // log(number.toString());
                        },
                        label: Text(
                          'Add to cart',
                          style: Theme.of(context).textTheme.button,
                        ),
                      )
                      //  ElevatedButton(
                      //   style: ButtonStyle(
                      //       backgroundColor: MaterialStatePropertyAll(
                      //           Theme.of(context).primaryColor)),
                      //   onPressed: () {},
                      //   child: const Text('Add to Cart'),
                      // ),
                      ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
