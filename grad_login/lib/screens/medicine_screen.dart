import 'package:flutter/material.dart';
import 'drug_item.dart';

class MedicinesScreen extends StatelessWidget {
  const MedicinesScreen({super.key});
  static const routeName = '/medicine-screen';

  @override
  Widget build(BuildContext context) {
    final mediaquery = MediaQuery.of(context).size.height;
    final args = ModalRoute.of(context)!.settings.arguments as List;
    return SafeArea(
      child: Scaffold(
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
                                right: mediaquery * 0.09,
                                top: mediaquery * 0.02),
                            child: Text(
                              args[1].toString(),
                              style: const TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
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
                  height: mediaquery * 0.01,
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
                                borderRadius:
                                    BorderRadius.circular(mediaquery * 0.02),
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
                SizedBox(
                  height: mediaquery,
                  width: double.infinity,
                  child: DrugItemScreen(
                    catID: args[0],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
