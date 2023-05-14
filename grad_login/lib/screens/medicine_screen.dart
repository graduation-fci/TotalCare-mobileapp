import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/cartProvider.dart';
import 'cart_screen.dart';
import 'drug_item.dart';

class MedicinesScreen extends StatelessWidget {
  const MedicinesScreen({super.key});
  static const routeName = '/medicine-screen';

  @override
  Widget build(BuildContext context) {
    final mediaquery = MediaQuery.of(context).size;
    final args = ModalRoute.of(context)!.settings.arguments as List;
    final cartItems = Provider.of<Cart>(context).items;
    return SafeArea(
      child: Scaffold(
        body: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: EdgeInsets.all(mediaquery.height * .03),
                child: Column(
                  children: [
                    SizedBox(
                      height: mediaquery.height * 0.06,
                      child: CustomScrollView(
                        slivers: [
                          SliverAppBar(
                            title: Text(
                              args[1].toString(), //static value
                              style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontSize: mediaquery.width * 0.04,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            actions: [
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed(CartScreen.routeName);
                                },
                                icon: Stack(
                                  children: [
                                    Icon(
                                      MdiIcons.cartOutline,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      size: 28,
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.red,
                                        ),
                                        width: 13,
                                        height: 13,
                                        child: Text(
                                          cartItems.length.toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                            elevation: 0,
                            backgroundColor: Colors.white10,
                            foregroundColor: Colors.black,
                            expandedHeight: 100,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: mediaquery.height * 0.01,
                    ),
                    Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: TextField(
                            cursorColor: Colors.grey,
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade200,
                                filled: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        mediaquery.height * 0.02),
                                    borderSide: BorderSide.none),
                                hintText: 'Search',
                                hintStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                    fontSize: mediaquery.width * 0.05),
                                suffixIcon: Icon(
                                  Icons.search,
                                  color: Colors.grey,
                                  size: mediaquery.width * .1,
                                )),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: mediaquery.height * 0.03,
                    ),
                    DrugItemScreen(
                      catID: args[0],
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
