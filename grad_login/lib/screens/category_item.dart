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
  int _page = 1;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  void _loadCategories() {
    setState(() {
      _isLoading = true;
    });
    Provider.of<Categories>(context, listen: false).fetchCat(_page).then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final categories = Provider.of<Categories>(context).items;
    final mediaquery = MediaQuery.of(context).size;
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _page = 1;
        });
        _loadCategories();
      },
      child: NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            setState(() {
              _page++;
            });
            _loadCategories();
          }
          return true;
        },
        child: SizedBox(
          width: double.infinity,
          height: mediaquery.height * 0.5,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 4 / 5,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) => _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        MedicinesScreen.routeName,
                        arguments: [
                          categories[index].id,
                          categories[index].name,
                        ],
                      );
                    },
                    child: GridTile(
                      footer: SizedBox(
                        width: double.infinity,
                        height: mediaquery.height * 0.05,
                        child: GridTileBar(
                          backgroundColor: Colors.white,
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
                  ),
          ),
        ),
      ),
    );
  }
}
