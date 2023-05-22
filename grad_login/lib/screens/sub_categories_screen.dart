import 'package:flutter/material.dart';

class SubCategoriesScreen extends StatefulWidget {
  const SubCategoriesScreen({super.key});

  @override
  State<SubCategoriesScreen> createState() => _SubCategoriesScreenState();
}

class _SubCategoriesScreenState extends State<SubCategoriesScreen> {
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white10,
          elevation: 0,
          centerTitle: true,
          title: const Text('Sub-Categories'),
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            controller: scrollController,
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 4 / 5,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              // itemCount: categories.length,
              itemBuilder: (context, index) => const InkWell(
                // onTap: () {
                // String? errorMSG =
                // Provider.of<Drugs>(context, listen: false).errorMSG;
                // errorMSG == null
                // ? Navigator.of(context).pushNamed(
                // MedicinesScreen.routeName,
                // arguments: [
                // categories[index]['id'],
                // appLocalization == 'en'
                // ? categories[index]['name']
                // : categories[index]['name_ar'],
                // ],
                // )
                // : ScaffoldMessenger.of(context)
                // .showSnackBar(SnackBar(content: Text(errorMSG)));
                // },
                child: GridTile(
                  footer: SizedBox(
                    width: double.infinity,
                    // height: mediaquery.height * 0.05,
                    child: GridTileBar(
                      backgroundColor: Colors.white,
                      /* title: Text(
                appLocalization == 'en'
                    ? categories[index]['name']
                    : categories[index]['name_ar'],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                style: const TextStyle(
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ), */
                    ),
                  ),
                  child: Placeholder(),
                  // child: CachedNetworkImage(
                  // imageUrl: categories[index]['image']['image'],
                  // placeholder: (context, url) =>
                  // const Center(child: CircularProgressIndicator()),
                  // errorWidget: (context, url, error) => const Center(
                  // child: Icon(
                  // Icons.error,
                  // color: Colors.red,
                ),
              ),
              // fit: BoxFit.cover,
            ),
            // ),
            // ),
            // );,
          );
        }),
      ),
    );
  }
}
