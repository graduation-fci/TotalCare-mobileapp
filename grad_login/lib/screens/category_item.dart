import 'package:flutter/material.dart';
import '../providers/categories.dart';
import 'package:provider/provider.dart';

class CategoryItem extends StatefulWidget {
  const CategoryItem({super.key});

  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

final List<dynamic> l = [];

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
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) => ChangeNotifierProvider.value(
                  value: categories[index],
                  child: GridTile(
                    footer: SizedBox(
                      width: double.infinity,
                      height: mediaquery.height * 0.04,
                      child: GridTileBar(
                        backgroundColor: Colors.white,
                        // backgroundColor: Colors.black45,
                        title: Text(
                          categories[index].name,
                          style: const TextStyle(color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () {},
                      child: Image.network(
                        categories[index].imgURL,
                        fit: BoxFit.cover,
                      ),
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
