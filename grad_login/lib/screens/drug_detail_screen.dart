import 'package:flutter/material.dart';
import 'package:grad_login/providers/drugProvider.dart';
import 'package:grad_login/screens/love_button.dart';

class DrugDetailScreen extends StatefulWidget {
  const DrugDetailScreen({super.key});
  static const routeName = '/drug-detail';

  @override
  State<DrugDetailScreen> createState() => _DrugDetailScreenState();
}

class _DrugDetailScreenState extends State<DrugDetailScreen> {
  int number = 1;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as DrugItem;
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
                args.imgURL,
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover,
              ),
              const Positioned(
                top: 30,
                right: 30,
                child: LoveBtn(),
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
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    //NEEDS HANDLING
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
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
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      '${args.price} L.E.',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 80),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text(
                            'Select Quantity',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            width: 30,
                            height: 30,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.grey, width: 1),
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
                          Text(
                            number.toString(),
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            width: 30,
                            height: 30,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.grey, width: 1),
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
                        onPressed: () {
                          print(number);
                        },
                        label: const Text(
                          'Add to cart',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
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
