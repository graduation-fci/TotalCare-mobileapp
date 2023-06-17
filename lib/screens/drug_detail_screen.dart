import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/drugProvider.dart';
import '../providers/cartProvider.dart';
import 'love_button.dart';

class DrugDetailScreen extends StatefulWidget {
  const DrugDetailScreen({Key? key}) : super(key: key);
  static const routeName = '/drug-detail';

  @override
  State<DrugDetailScreen> createState() => _DrugDetailScreenState();
}

class _DrugDetailScreenState extends State<DrugDetailScreen>
    with SingleTickerProviderStateMixin {
  int number = 1;
  String cartID = '';
  late AnimationController _animationController;
  int currentIndex = 0;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    Provider.of<Cart>(context, listen: false).getCartID().then((_) {
      final cartId = Provider.of<Cart>(context, listen: false).cartID;
      cartID = cartId;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as DrugItem;
    final mediaQuery = MediaQuery.of(context);
    final error = Provider.of<Cart>(context).errorMSG;
    final totalImages = args.imgURL.isNotEmpty ? args.imgURL.length : 1;

    return SafeArea(
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.white,
            extendBody: true,
            body: SizedBox(
              height: mediaQuery.size.height * 0.32,
              width: double.infinity,
              child: Stack(children: [
                PageView.builder(
                  itemCount: totalImages,
                  onPageChanged: (index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return CachedNetworkImage(
                      imageUrl: args.imgURL.isNotEmpty &&
                              args.imgURL[index]['image'] != null
                          ? args.imgURL[index]['image']
                          : '',
                      width: double.infinity,
                      height: mediaQuery.size.height * 0.4,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Image.asset(
                        'assets/images/temp_med.jpeg',
                        fit: BoxFit.contain,
                      ),
                      fit: BoxFit.contain,
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12, right: 15),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back),
                      ),
                      const Spacer(),
                       LoveBtn(2,9),
                    ],
                  ),
                )
              ]),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 280,
            child: Container(
              height: mediaQuery.size.height * 0.65,
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
                        fontSize: mediaQuery.size.width * 0.06,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${args.price} L.E.',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: mediaQuery.size.width * 0.05,
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
                            fontSize: mediaQuery.size.width * 0.05,
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: mediaQuery.size.width * 0.08,
                          height: mediaQuery.size.width * 0.08,
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
                              onPressed: number == 1
                                  ? null
                                  : () {
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
                            fontSize: mediaQuery.size.width * 0.05,
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: mediaQuery.size.width * 0.08,
                          height: mediaQuery.size.width * 0.08,
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
                        : Expanded(
                            child: Scrollbar(
                              child: SizedBox(
                                height: double.infinity,
                                child: ListView.builder(
                                  itemExtent: 25,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return SizedBox(
                                      child: Text(
                                        '- ${args.drugsList[index]['name']}',
                                      ),
                                    );
                                  },
                                  itemCount: args.drugsList.length,
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
                bottomNavigationBar: Container(
                  margin: const EdgeInsets.only(bottom: 30),
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      fixedSize: Size(
                        mediaQuery.size.width * 0.85,
                        mediaQuery.size.height * 0.06,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    onPressed: () async {
                      await Provider.of<Cart>(context, listen: false)
                          .addCart(cartID, args.id, number)
                          .then((_) {
                        if (error == null) {
                          setState(() {
                            ScaffoldMessenger.of(context).showSnackBar(
                              customSnackBar(),
                            );
                          });
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                contentPadding: const EdgeInsets.all(20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                title: const Text('Something went wrong...'),
                                content: Text(error),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'Ok',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      });
                    },
                    child: Text(
                      'Add to cart',
                      style: Theme.of(context)
                          .textTheme
                          .button!
                          .copyWith(fontSize: mediaQuery.size.width * 0.038),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 250,
            child: DotsIndicator(
              dotsCount: totalImages,
              position: currentIndex,
              decorator: DotsDecorator(
                color: Colors.grey, // Inactive dot color
                activeColor: Theme.of(context).primaryColor, // Active dot color
              ),
            ),
          ),
        ],
      ),
    );
  }

  SnackBar customSnackBar() {
    return SnackBar(
      animation:
          Tween<double>(begin: 0.0, end: 1).animate(_animationController),
      // backgroundColor: Colors.transparent,
      elevation: 0,
      content: const Text(
        'Item added Successfully!',
      ),
      duration: const Duration(milliseconds: 1200),
      behavior: SnackBarBehavior.floating,
    );
  }
}
