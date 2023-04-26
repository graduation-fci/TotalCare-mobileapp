import 'package:flutter/material.dart';
import 'package:grad_login/screens/medicine_screen.dart';

import 'package:provider/provider.dart';

import '../providers/categoriesProvider.dart';

class CategoryItem extends StatefulWidget {
  const CategoryItem({super.key});

  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      Provider.of<Categories>(context, listen: false).fetchCat();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final categories = Provider.of<Categories>(context).items;
    final mediaquery = MediaQuery.of(context).size;
    return SizedBox(
        width: mediaquery.width * 0.3,
        height: mediaquery.height * 0.1,
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 4 / 5,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(MedicinesScreen.routeName,
                        arguments: categories[index].id);
                    //print('category id: ${categories[index].id}');
                  },
                  child: GridTile(
                    footer: SizedBox(
                      width: double.infinity,
                      height: mediaquery.height * 0.05,
                      child: GridTileBar(
                        backgroundColor: Colors.white,
                        // backgroundColor: Colors.black45,
                        title: Text(
                          categories[index].name,
                          maxLines: null,
                          overflow: TextOverflow.visible,
                          softWrap: true,
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    child: Image.network(
                      categories[index].imgURL,
                      fit: BoxFit.cover,
                    ),
                  ),
                ))
        // GridTile(
        //   footer: Container(
        //     height: mediaquery.height * 0.03,
        //     color: Colors.white10,
        //     child: const Center(
        //       child: Text('Category'),
        //     ),
        //   ),
        //   child: Image.asset(
        //     'assets/images/pill.png',
        //     fit: BoxFit.contain,
        //   ),
        // ),
        // ),
        );
  }
}
