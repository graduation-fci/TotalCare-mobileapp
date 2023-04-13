import 'package:flutter/material.dart';

class InteractionScreen extends StatefulWidget {
  static const routeName = '/interaction-screen';
  const InteractionScreen({super.key});

  @override
  State<InteractionScreen> createState() => _InteractionScreenState();
}

class _InteractionScreenState extends State<InteractionScreen> {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController searchController2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: const Color(0xFFFCFCFC),
          body: Container(
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
                              border: Border.all(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              )),
                          child: TextFormField(
                            controller: searchController,
                            decoration: const InputDecoration(
                              labelText: 'Enter a drug name',
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
          ),
        ),
      ),
    );
  }
}
