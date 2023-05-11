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
    final userName = '';
    // ModalRoute.of(context)!.settings.arguments as String;
    final mediaquery = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        drawer: const Drawer(),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(mediaquery * .03),
            child: Column(
              children: [
                SizedBox(
                  height: mediaquery * 0.06,
                  width: double.infinity,
                  child: CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // const Drawer(),
                              Padding(
                                  padding: mediaquery <= 596
                                      ? EdgeInsets.only(
                                          top: mediaquery * 0.022,
                                          right: mediaquery * 0.2,
                                        )
                                      : EdgeInsets.only(
                                          top: mediaquery * 0.015,
                                          right: mediaquery * 0.1,
                                        ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Hi $userName!',
                                        style: TextStyle(
                                            fontSize: mediaquery * 0.02,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                      // const SizedBox(height: 8),
                                      Text(
                                        'How are you feeling today?',
                                        style: TextStyle(
                                            fontSize: mediaquery * 0.015,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black38),
                                      ),
                                    ],
                                  )),
                              const NotificationIcon(),
                            ],
                          )
                        ],
                        elevation: 0,
                        backgroundColor: Colors.white10,
                        foregroundColor: Colors.black,
                        expandedHeight: 100,
                      )
                    ],
                  ),
                ),
                SizedBox(height: mediaquery * 0.02),
                Stack(
                  alignment: AlignmentDirectional.topStart,
                  children: [
                    Image.asset(
                      'assets/images/background.png',
                      width: double.infinity,
                    ),
                    Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: mediaquery * 0.05),
                          child: Text(
                            'Check\nInteractions',
                            style: TextStyle(
                                fontSize: mediaquery * 0.03,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: mediaquery <= 596
                              ? mediaquery * 0.3
                              : mediaquery * 0.2,
                          child: IconButton(
                            onPressed: () {},
                            icon: Stack(
                              children: [
                                Image.asset(
                                  'assets/images/btn.png',
                                  fit: BoxFit.cover,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: mediaquery * 0.05,
                                      top: mediaquery * .064),
                                  child: Text(
                                    'Learn more',
                                    softWrap: false,
                                    style: TextStyle(
                                      fontSize: mediaquery * 0.03,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            iconSize: mediaquery * 0.25,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: mediaquery * 0.01),
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