import 'package:flutter/material.dart';
import 'package:grad_login/screens/sub_categories_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'medicine_screen.dart';
import '../providers/drugProvider.dart';
import '../providers/categoriesProvider.dart';

class CategoryItem extends StatefulWidget {
  const CategoryItem({super.key});

  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context)!.localeName;

    final categoriesProvider = Provider.of<Categories>(context);
    final categories = categoriesProvider.catItems;
    final mediaquery = MediaQuery.of(context).size;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 4 / 5,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) => InkWell(
        onTap: () {
          String? errorMSG =
              Provider.of<Drugs>(context, listen: false).errorMSG;
          categoriesProvider
              .getSubCategories(id: categories[index]['id'])
              .then((_) {
            errorMSG == null
                ? Navigator.of(context).pushNamed(
                    SubCategoriesScreen.routeName,
                    arguments: [
                      appLocalization == 'en'
                          ? categories[index]['name']
                          : categories[index]['name_ar'],
                    ],
                  )
                : ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(errorMSG)));
          });
        },
        child: GridTile(
          footer: SizedBox(
            width: double.infinity,
            height: mediaquery.height * 0.05,
            child: GridTileBar(
              backgroundColor: Colors.white,
              title: Text(
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
              ),
            ),
          ),
          child: CachedNetworkImage(
            imageUrl: categories[index]['image']['image'],
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
    );
  }
}
