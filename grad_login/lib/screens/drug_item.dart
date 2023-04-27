import 'package:flutter/material.dart';
import '../providers/drugProvider.dart';
import 'package:provider/provider.dart';

class DrugItemScreen extends StatefulWidget {
  final int catID;
  DrugItemScreen({required this.catID});
  @override
  State<DrugItemScreen> createState() => _DrugItemScreenState();
}

class _DrugItemScreenState extends State<DrugItemScreen> {
  @override
  void initState() {
    // print('widgetID: ${widget.catID}');
    Future.delayed(Duration.zero).then((value) {
      Provider.of<Drugs>(context, listen: false).fetchDrug(widget.catID);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final drugs = Provider.of<Drugs>(context).items;
    //print(drugs.length);
    final mediaquery = MediaQuery.of(context).size.height;
    return SizedBox(
        width: mediaquery * 0.3,
        height: mediaquery * 0.1,
        child: drugs == []
            ? Center(
                child: Text(
                  'Category has no Drugs!',
                  style: TextStyle(fontSize: mediaquery * 0.1),
                ),
              )
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 4 / 5,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: drugs.length,
                itemBuilder: (context, index) => InkWell(
                      onTap: () {
                        print('Show Drug Details');
                      },
                      child: GridTile(
                        footer: SizedBox(
                          width: double.infinity,
                          height: mediaquery * 0.15,
                          child: GridTileBar(
                            //trailing: const Text('50 Pounds'),
                            backgroundColor: Colors.white,
                            // backgroundColor: Colors.black45,
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      drugs[index].name,
                                      //softWrap: true,
                                      maxLines: null,
                                      overflow: TextOverflow.visible,
                                      softWrap: true,
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                      //textAlign: TextAlign.start,
                                    ),
                                    Text(
                                      ('${drugs[index].price}L.E.'),
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                ElevatedButton(
                                  style: ButtonStyle(
                                      minimumSize: MaterialStatePropertyAll(
                                          Size(double.infinity,
                                              mediaquery * 0.05)),
                                      elevation:
                                          const MaterialStatePropertyAll(0),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              const Color(0xFFCCE5FF)),
                                      foregroundColor:
                                          MaterialStateProperty.all(
                                              Colors.blueAccent)),
                                  onPressed: () {},
                                  child: const Text('Add to Cart'),
                                ),
                              ],
                            ),
                          ),
                        ),
                        child: Image.network(
                          drugs[index].imgURL,
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
