import 'package:flutter/material.dart';
import 'drug_item.dart';

class MedicinesScreen extends StatelessWidget {
  const MedicinesScreen({super.key});
  static const routeName = '/medicine-screen';

  @override
  Widget build(BuildContext context) {
    final mediaquery = MediaQuery.of(context).size;
    final args = ModalRoute.of(context)!.settings.arguments as List;
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
