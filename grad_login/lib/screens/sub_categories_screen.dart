import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:grad_login/providers/categoriesProvider.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'medicine_screen.dart';

class SubCategoriesScreen extends StatefulWidget {
  const SubCategoriesScreen({super.key});
  static const routeName = '/sub-category';

  @override
  State<SubCategoriesScreen> createState() => _SubCategoriesScreenState();
}

class _SubCategoriesScreenState extends State<SubCategoriesScreen> {
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final subCategories = Provider.of<Categories>(context).subCatItems;
    final appLocalization = AppLocalizations.of(context)!.localeName;

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
              itemCount: subCategories.length,
              itemBuilder: (context, index) => InkWell(
                onTap: () {
                  // String? errorMSG =
                  // Provider.of<Categories>(context, listen: false).errorMSG;
                  // errorMSG == null
                  // ?
                  Navigator.of(context)
                      .pushNamed(MedicinesScreen.routeName, arguments: [
                    subCategories[index]['id'],
                    appLocalization == 'en'
                        ? subCategories[index]['name']
                        : subCategories[index]['name_ar'],
                  ]);
                  // : ScaffoldMessenger.of(context)
                  // .showSnackBar(SnackBar(content: Text('Error')));
                },
                child: GridTile(
                  footer: SizedBox(
                    width: double.infinity,
                    // height: mediaquery.height * 0.05,
                    child: GridTileBar(
                      backgroundColor: Colors.white,
                      title: Text(
                        appLocalization == 'en'
                            ? subCategories[index]['name']
                            : subCategories[index]['name_ar'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: subCategories[index]['image']['image'],
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => const Center(
                      child: Icon(
                        Icons.error,
                        color: Colors.red,
                      ),
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
