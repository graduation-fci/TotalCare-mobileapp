import 'package:flutter/material.dart';
import 'category_item.dart';

import 'notification_widget.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home-screen';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final mediaquery = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        drawer: const Drawer(),
        // AppBar(
        //   bottom: const PreferredSize(
        //       preferredSize: Size.fromHeight(10),
        //       child: Text('how are you feeling today?')),
        //   iconTheme: const IconThemeData(color: Colors.black),
        //   elevation: 0,
        //   backgroundColor: Colors.white10,
        //   actions: [
        //     Padding(
        //       padding: EdgeInsets.only(
        //           right: mediaquery * 0.21, top: mediaquery * 0.01),
        //       child: const Text(
        //         'Hi Jenny!',
        //         style: TextStyle(
        //             fontSize: 16,
        //             fontWeight: FontWeight.bold,
        //             color: Colors.black),
        //       ),
        //     ),
        //     IconButton(
        //       onPressed: () {},
        //       icon: Icon(
        //         Icons.notifications_outlined,
        //         size: mediaquery * .04,
        //       ),
        //     )
        //   ],
        // ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(mediaquery * .03),
            child: Column(
              children: [
                SizedBox(
                  height: mediaquery * 0.06,
                  child: CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        actions: [
                          Padding(
                            padding: EdgeInsets.only(
                              top: mediaquery * 0.015,
                              right: mediaquery * 0.09,
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  'Hi Jenny!',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: mediaquery * 0.09),
                                  child: const Text(
                                    'How are you feeling today?',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black38),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(mediaquery * 0.01),
                            child: const NotificationIcon(),
                          ),
                        ],
                        elevation: 0,
                        backgroundColor: Colors.white10,
                        foregroundColor: Colors.black,
                        expandedHeight: 100,
                      )
                    ],
                  ),
                ),
                Center(
                  child: Stack(
                    children: [
                      Image.asset(
                        'assets/images/background.png',
                        height: mediaquery * 0.32,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            // horizontal: mediaquery * 0.01,
                            // vertical: mediaquery * .03
                            right: mediaquery * 0.15,
                            top: mediaquery * .03),
                        child: Column(
                          children: [
                            const Text(
                              'Check\nInteractions',
                              style: TextStyle(
                                  fontSize: 28, fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Stack(
                                children: [
                                  Image.asset(
                                    'assets/images/btn.png',
                                    fit: BoxFit.cover,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: mediaquery * 0.06,
                                        top: mediaquery * .066),
                                    child: const Text(
                                      'Learn more',
                                      softWrap: false,
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              iconSize: mediaquery * 0.25,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // searchBar.build(context),
                SizedBox(
                  width: double.infinity,
                  // margin: const EdgeInsets.only(left: 25, right: 25),
                  child: Column(
                    children: [
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
                                          mediaquery * 0.02),
                                      borderSide: BorderSide.none),
                                  hintText: 'Search',
                                  hintStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                      fontSize: 18),
                                  suffixIcon: Icon(
                                    Icons.search,
                                    color: Colors.grey,
                                    size: mediaquery * .05,
                                  )),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: mediaquery * 0.03,
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     const Text(
                      //       'Our Services',
                      //       style: TextStyle(fontWeight: FontWeight.bold),
                      //     ),
                      //     TextButton(
                      //         onPressed: () {}, child: const Text('See more'))
                      //   ],
                      // ),
                      // SizedBox(
                      //   height: mediaquery * 0.1,
                      //   child: ListView(
                      //     scrollDirection: Axis.horizontal,
                      //     children: const [
                      //       ServiceItem(),
                      //       ServiceItem(),
                      //       ServiceItem(),
                      //       ServiceItem(),
                      //     ],
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: mediaquery * 0.05,
                      // ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Categories',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: mediaquery * 0.02),
                          ),
                        ],
                      ),

                      SizedBox(
                        height: mediaquery * .29,
                        width: double.infinity,
                        child: const CategoryItem(),
                      ),

                      SizedBox(
                        height: mediaquery * .10,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
