import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:grad_login/screens/drug_detail_screen.dart';
import '../providers/drugProvider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'love_button.dart';

class DrugItemScreen extends StatefulWidget {
  final int catID;
  const DrugItemScreen({super.key, required this.catID});
  @override
  State<DrugItemScreen> createState() => _DrugItemScreenState();
}

class _DrugItemScreenState extends State<DrugItemScreen> {
  @override
  void initState() {
    // print('widgetID: ${widget.catID}');
    Future.delayed(Duration.zero).then((value) {
      Provider.of<Drugs>(context, listen: false)
          .fetchDrug(catID: widget.catID.toString());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context)!.localeName;
    final drugs = Provider.of<Drugs>(context).items;
    final mediaquery = MediaQuery.of(context).size;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 4 / 5,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: drugs.length,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
          Navigator.of(context).pushNamed(
            DrugDetailScreen.routeName,
            arguments: DrugItem(
              id: drugs[index]['id'],
              name: appLocalization == 'en'
                  ? drugs[index]['name']
                  : drugs[index]['name_ar'],
              price: drugs[index]['price'],
              imgURL: drugs[index]['images'],
              drugsList: drugs[index]['drug'],
            ),
          );
        },
        child: Ink(
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
                side: const BorderSide(
                  width: 1,
                  color: Colors.black12,
                ),
                borderRadius: BorderRadius.circular(20)),
          ),
          child: GridTile(
            footer: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
              ),
              child: GridTileBar(
                title: Text(
                  appLocalization == 'en'
                      ? drugs[index]['name']
                      : drugs[index]['name_ar'],
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  '${drugs[index]['price'].toString()} L.E.',
                  style: const TextStyle(color: Colors.black, fontSize: 11),
                ),
              ),
            ),
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    color: Colors.white,
                  ),
                  width: mediaquery.width * 0.5,
                  height: mediaquery.height * 0.15,
                  child: CachedNetworkImage(
                    imageUrl: drugs[index]['images'].isNotEmpty &&
                            drugs[index]['images'][0]['image'] != null
                        ? drugs[index]['images'][0]['image']
                        : '',
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      'assets/images/temp_med.jpeg',
                      fit: BoxFit.contain,
                    ),
                    fit: BoxFit.contain,
                  ),
                ),
                Positioned(
                  top: 2,
                  right: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    //عايزين نخلي ال 2 دي تبقى ال wishlistID
                    child: LoveBtn(2, drugs[index]['id']),
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
