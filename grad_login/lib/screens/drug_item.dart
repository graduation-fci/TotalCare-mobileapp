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
  bool _dataFetched = false;

  @override
  void initState() {
    // print('widgetID: ${widget.catID}');
    Future.delayed(Duration.zero).then((value) {
      Provider.of<Drugs>(context, listen: false)
          .fetchDrug(widget.catID)
          .then((_) {
        setState(() {
          _dataFetched = true;
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context)!.localeName;

    final drugs = Provider.of<Drugs>(context).items;
    //print(drugs.length);
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
        onTap: () => Navigator.of(context).pushNamed(
          DrugDetailScreen.routeName,
          arguments: DrugItem(
            id: drugs[index]['id'],
            name: appLocalization == 'en'
                ? drugs[index]['name']
                : drugs[index]['name_ar'],
            price: drugs[index]['price'],
            imgURL: drugs[index]['medicine_images'],
            drugsList: drugs[index]['drug'],
          ), //medicine images is a list
        ),
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
            footer: GridTileBar(
              title: Text(
                appLocalization == 'en'
                    ? drugs[index]['name']
                    : drugs[index]['name_ar'],
                style: const TextStyle(color: Colors.black),
              ),
              subtitle: Text(
                '${drugs[index]['price'].toString()} L.E.',
                style: const TextStyle(color: Colors.black),
              ),
            ),
            child: Stack(
              alignment: Alignment.topCenter,
              //alignment: Alignment.topRight,
              children: [
                SizedBox(
                  width: mediaquery.width * 0.5,
                  height: mediaquery.height * 0.18,
                  child: Image.network(
                    drugs[index]['medicine_images'][0]['image'],
                    fit: BoxFit.contain,
                  ),
                ),
                const Positioned(
                  top: 2,
                  right: 5,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: LoveBtn(),
                  ),
                ),
              ],
            ),
          ),
          // Column(
          //   mainAxisSize: MainAxisSize.min,
          //   children: [
          //     Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: Stack(
          //         alignment: Alignment.topRight,
          //         children: [
          //           ClipRRect(
          //             borderRadius: BorderRadius.circular(20),
          //             child:
          //                 // Image.asset('assets/images/btn.png')
          //                 Image.network(
          //               drugs[index].imgURL,
          //               width: double.infinity,
          //               height: 150,
          //               fit: BoxFit.cover,
          //             ),
          //           ),
          //           const LoveBtn(),
          //         ],
          //       ),
          //     ),
          //     Padding(
          //       padding: const EdgeInsets.symmetric(horizontal:10),
          //       child: Column(
          //         // mainAxisSize: MainAxisSize.min,
          //         mainAxisAlignment: MainAxisAlignment.spaceAround,
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Text(
          //             drugs[index].name,
          //             maxLines: 1,
          //             overflow: TextOverflow.ellipsis,
          //             style: const TextStyle(fontWeight: FontWeight.bold),
          //           ),
          //           Text(
          //             '${drugs[index].price.toString()}L.E.',
          //             style: const TextStyle(fontWeight: FontWeight.bold),
          //           ),
          //         ],
          //       ),
          //     )
          //   ],
          // ),
        ),
      ),
    );
  }
}
