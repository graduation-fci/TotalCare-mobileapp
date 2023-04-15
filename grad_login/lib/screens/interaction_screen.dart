import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:grad_login/providers/medicineProvider.dart';
import 'package:grad_login/providers/userProvider.dart';
import '.././my_config.dart';

class InteractionScreen extends StatefulWidget {
  static const routeName = '/interaction-screen';
  const InteractionScreen({super.key});

  @override
  State<InteractionScreen> createState() => _InteractionScreenState();
}

class _InteractionScreenState extends State<InteractionScreen> {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController searchController2 = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isVisible = true;

  Map<String, dynamic>? meds;
  Map<String, dynamic>? filteredMeds;

  final simpleMeds = Config.simpleMeds;

  List<dynamic>? results;

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   MedicineProvider().getMedicines();
  //   super.initState();
  // }
  @override
  void initState() {
    // TODO: implement initState
    _focusNode.addListener(() {
      setState(() {
        _isVisible = _focusNode.hasFocus;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _filterDataList(String searchValue) async {
    filteredMeds = await UserProvider()
        .getFilteredData(searchQuery: searchValue) as Map<String, dynamic>;
    if (filteredMeds != null && filteredMeds!['results'] != null) {
      results = filteredMeds!['results'];
      // use the results list as per your requirement
    }
    setState(() {
      if (filteredMeds != null && filteredMeds!['results'] != null) {
        results = filteredMeds!['results'];
        // use the results list as per your requirement
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: const Color(0xFFFCFCFC),
          body: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade300, width: 2),
                ),
                height: mediaQuery.height * 0.45,
                margin: const EdgeInsets.only(
                  top: 10,
                  left: 10,
                  right: 10,
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 40,
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(left: 15),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey, width: 1),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                  )),
                              child: TextFormField(
                                focusNode: _focusNode,
                                onChanged: _filterDataList,
                                // onTap: () async => {
                                //   meds =
                                //       await UserProvider().getFilteredData() as Map,
                                // },
                                controller: searchController,
                                decoration: InputDecoration(
                                  labelText: searchController.text.isNotEmpty
                                      ? ''
                                      : 'Enter a drug name',
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            child: ElevatedButton(
                              onPressed: () {},
                              child: const Text('Add'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Stack(
                      children: [
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      'unsaved interactions list',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
                                SizedBox(
                                  width: 20,
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Start over',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Expanded(
                                  child: TextFormField(
                                    controller: searchController2,
                                    decoration: InputDecoration(
                                      hintText: 'Drug 1 (example)',
                                      border: OutlineInputBorder(),
                                      suffixIcon: IconButton(
                                        icon: Icon(Icons.clear),
                                        onPressed: () {
                                          searchController2.clear();
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    child: Text(
                                      'Check interactions',
                                      // style: ElevatedButton.styleFrom(backgroundColor: Colors.greenAccent),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    child: Text(
                                      'Save',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        results != null
                            ? results!.isNotEmpty
                                ? Visibility(
                                    visible: _isVisible,
                                    child: Container(
                                      constraints: const BoxConstraints(
                                          minHeight: 50, maxHeight: 180),
                                      padding: const EdgeInsets.all(8),
                                      margin: const EdgeInsets.only(top: 3),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                            color: Colors.grey.shade400,
                                            width: 1,
                                          )),
                                      child: ListView.builder(
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            title: Text(
                                                '${results![index]['name']}'),
                                            onTap: () {
                                              searchController.text =
                                                  results![index]['name'];
                                            },
                                          );
                                        },
                                        itemCount: results!.length,
                                      ),
                                    ),
                                  )
                                : Container()
                            : Container(),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
