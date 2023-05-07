import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:grad_login/providers/medicineProvider.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../providers/categoriesProvider.dart';
import 'category_item.dart';

import 'notification_widget.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home-screen';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final scrollController = ScrollController();
  int _page = 1;

  bool _isLoading = false;

  TextEditingController searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  Timer? _debounce;
  Map<String, dynamic>? filteredMeds;
  bool _isVisible = true;
  List<dynamic>? results;

  Future<List<dynamic>?> _filterDataList(String searchValue) async {
    _debounce?.cancel(); // Cancel previous debounce timer
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      // Perform search/filtering here
      filteredMeds = await Provider.of<MedicineProvider>(context, listen: false)
          .getFilteredCategories(searchQuery: searchValue);
      if (filteredMeds != null && filteredMeds!['results'] != null) {
        results = filteredMeds!['results'];
      }
      setState(() {});
    });
    return results;
  }

  @override
  void initState() {
    scrollController.addListener(_scrollListener);
    _loadCategories();
    _focusNode.addListener(() {
      setState(() {
        _isVisible = _focusNode.hasFocus;
      });
    });
    super.initState();
  }

  Future<void> _loadCategories() async {
    setState(() {
      _isLoading = true;
    });
    await Provider.of<Categories>(context, listen: false)
        .fetchCat(_page)
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final userName = ModalRoute.of(context)!.settings.arguments as String;
    final mediaquery = MediaQuery.of(context).size;

    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          drawer: const Drawer(),
          body: LayoutBuilder(builder: (context, constraints) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: mediaquery.height * .015,
                  horizontal: mediaquery.width * 0.05,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: mediaquery.height * 0.06,
                      child: CustomScrollView(
                        slivers: [
                          SliverAppBar(
                            pinned: true,
                            title: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Hi $userName!\n',
                                    style: TextStyle(
                                        fontSize: mediaquery.width * 0.045,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  TextSpan(
                                    text: 'How are you feeling today?',
                                    style: TextStyle(
                                        fontSize: mediaquery.width * 0.035,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black38),
                                  )
                                ],
                              ),
                            ),
                            actions: const [
                              NotificationIcon(),
                            ],
                            elevation: 0,
                            backgroundColor: Colors.white10,
                            foregroundColor: Colors.black,
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: mediaquery.height * 0.02),
                    Stack(
                      alignment: AlignmentDirectional.topStart,
                      children: [
                        Image.asset(
                          'assets/images/background.png',
                          width: double.infinity,
                        ),
                        SizedBox(
                          height: mediaquery.height * 0.3,
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: mediaquery.height * 0.02,
                                    top: mediaquery.height * 0.03),
                                child: Text(
                                  'Check\nInteractions',
                                  style: TextStyle(
                                      fontSize: mediaquery.width *
                                          0.075 *
                                          MediaQuery.of(context)
                                              .textScaleFactor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                height: mediaquery.height * 0.16,
                                width: mediaquery.width * 0.5,
                                child: IconButton(
                                  onPressed: () {},
                                  icon: Stack(
                                    children: [
                                      Image.asset(
                                        'assets/images/btn.png',
                                        fit: BoxFit.cover,
                                      ),
                                      Positioned(
                                        top: mediaquery.height * 0.05,
                                        left: mediaquery.width * 0.09,
                                        child: Text(
                                          'Learn more',
                                          softWrap: false,
                                          style: TextStyle(
                                            fontSize: mediaquery.width *
                                                0.055 *
                                                MediaQuery.of(context)
                                                    .textScaleFactor,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: mediaquery.height * 0.01),
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Flexible(
                                flex: 1,
                                child: TextFormField(
                                  focusNode: _focusNode,
                                  controller: searchController,
                                  onChanged: _filterDataList,
                                  cursorColor: Colors.grey,
                                  decoration: InputDecoration(
                                      fillColor: Colors.grey.shade200,
                                      filled: true,
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              mediaquery.height * 0.02),
                                          borderSide: BorderSide.none),
                                      hintText: 'Search',
                                      hintStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                          fontSize: mediaquery.width * 0.05),
                                      suffixIcon: Icon(
                                        Icons.search,
                                        color: Colors.grey,
                                        size: mediaquery.width * 0.075,
                                      )),
                                ),
                              ),
                            ],
                          ),
                          results != null && results!.isNotEmpty
                              ? Visibility(
                                  visible: _isVisible,
                                  child: Container(
                                    height: 200,
                                    padding: const EdgeInsets.all(8),
                                    margin: const EdgeInsets.only(top: 3),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color: Colors.grey.shade400,
                                          width: 1,
                                        )),
                                    child: ListView.builder(
                                      itemExtent: 50,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          title: Text(
                                            '${results![index]['name']}',
                                            style: TextStyle(
                                                fontSize:
                                                    mediaquery.width * 0.045),
                                          ),
                                          onTap: () {
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();

                                            searchController.text = '';
                                          },
                                        );
                                      },
                                      itemCount: results!.length,
                                    ),
                                  ),
                                )
                              : Container(),
                          SizedBox(
                            height: mediaquery.height * 0.03,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Categories',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: mediaquery.width * 0.055),
                              ),
                            ],
                          ),
                          const CategoryItem(),
                          _isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : Container(),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      _page++;
      _loadCategories();
    }
  }
}
