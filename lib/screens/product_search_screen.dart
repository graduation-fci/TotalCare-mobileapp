import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../screens/cart_screen.dart';
import '../screens/drug_detail_screen.dart';
import '../providers/drugProvider.dart';
import '../providers/cartProvider.dart';

class ProductSearchScreen extends StatefulWidget {
  static const String routeName = 'product-search-screen';
  const ProductSearchScreen({super.key});

  @override
  State<ProductSearchScreen> createState() => _ProductSearchScreenState();
}

class _ProductSearchScreenState extends State<ProductSearchScreen> {
  TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();
  dynamic drugProvider;
  String? nextUrl;

  void scrollListener() {
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        nextUrl != null) {
      drugProvider.fetchNextDrug(nextUrl);
    }
  }

  @override
  void initState() {
    searchController = TextEditingController();
    scrollController.addListener(scrollListener);
    super.initState();
  }

  void _loadFetchedData(String searchQuery) async {
    await Provider.of<Drugs>(context, listen: false)
        .fetchDrug(searchQuery: searchQuery);
  }

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context)!.localeName;
    final cartProvider = Provider.of<Cart>(context);
    drugProvider = Provider.of<Drugs>(context);
    nextUrl = drugProvider.nextPageEndPoint;
    final medicines = searchController.text.isEmpty ? [] : drugProvider.items;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                searchController.text = '';
              });
            },
            icon: Icon(
              Icons.clear,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ],
        title: TextFormField(
          controller: searchController,
          decoration: const InputDecoration(
            hintText: 'What are you looking for?',
            border: InputBorder.none,
          ),
          cursorColor: Colors.grey,
          onChanged: _loadFetchedData,
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
        child: SingleChildScrollView(
          controller: scrollController,
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(top: 20),
                child: ListTile(
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    Navigator.pushNamed(
                      context,
                      DrugDetailScreen.routeName,
                      arguments: DrugItem(
                        id: medicines[index]['id'],
                        name: appLocalization == 'en'
                            ? medicines[index]['name']
                            : medicines[index]['name_ar'],
                        price: medicines[index]['price'],
                        imgURL: medicines[index]['images'],
                        drugsList: medicines[index]['drug'],
                      ),
                    );
                  },
                  leading: Container(
                    color: Colors.white,
                    width: 90,
                    height: 90,
                    child: CachedNetworkImage(
                      height: 75,
                      width: 75,
                      imageUrl: medicines[index]['images'].isNotEmpty &&
                              medicines[index]['images'][0]['image'] != null
                          ? medicines[index]['images'][0]['image']
                          : '',
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => Image.asset(
                        'assets/images/temp_med.jpeg',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  title: Text(
                    medicines[index]['name'],
                    style: const TextStyle(fontSize: 15),
                  ),
                  trailing: ElevatedButton(
                    onPressed: () async {
                      final cartId = cartProvider.cartID;
                      await Provider.of<Cart>(context, listen: false)
                          .addCart(cartId, medicines[index]['id'], 1);
                    },
                    child: Text(
                      '+ Add',
                      style: Theme.of(context).textTheme.button,
                    ),
                  ),
                ),
              );
            },
            itemCount: medicines.length,
          ),
        ),
      ),
      floatingActionButton: cartProvider.items.isEmpty
          ? Container()
          : GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus!.unfocus();
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(left: 28),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Text(
                      '${cartProvider.items.length} item - EGP ${cartProvider.cartPrice}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      'View Cart',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
