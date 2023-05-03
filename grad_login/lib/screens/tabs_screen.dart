import 'package:flutter/material.dart';
import 'package:grad_login/providers/authProvider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'home_screen.dart';
import 'interaction_screen.dart';
import 'login_screen.dart';

class TabsScreen extends StatefulWidget {
  static const String routeName = 'tabs-screen';
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  List<Map<String, dynamic>> _pages = [];
  String? settings;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      settings = ModalRoute.of(context)!.settings.arguments as String;
    });
    _pages = [
      {
        'page': HomeScreen(
          username: settings,
        ),
        'title': 'Home',
      },
      {
        'page': const InteractionScreen(),
        'title': 'Interactions',
      },
      {
        'page': null,
        'title': 'Doctors',
      },
      {
        'page': null,
        'title': 'Cart',
      },
    ];
    // TODO: implement initState
    super.initState();
  }

  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context)!;
    final settings = ModalRoute.of(context)!.settings.arguments;
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     _pages[_selectedPageIndex]['title'],
      //     style: const TextStyle(
      //       fontFamily: 'Anton-Regular',
      //     ),
      //   ),
      //   backgroundColor: Theme.of(context).primaryColor,
      // ),
      // drawer: MainDrawer(),
      body: Column(
        children: [
          Expanded(
            child: _pages[_selectedPageIndex]['page'],
          ),
          FloatingActionButton(
            onPressed: () async {
              // Handle button press
              await authProvider.logout().then((value) => Navigator.of(context)
                  .pushReplacementNamed(LoginScreen.routeName));
            },
            child: const Icon(Icons.logout),
          ),
        ],
      ),

      bottomNavigationBar: SizedBox(
        height: 65,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: _selectPage,
          backgroundColor: const Color.fromARGB(255, 235, 233, 236),
          selectedFontSize: 12,
          unselectedFontSize: 12,
          selectedLabelStyle: const TextStyle(
            fontFamily: 'Roboto-Medium',
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(
            fontFamily: 'Roboto-Medium',
            fontWeight: FontWeight.w600,
          ),
          unselectedItemColor: const Color.fromARGB(255, 116, 114, 119),
          selectedItemColor: Colors.black,
          currentIndex: _selectedPageIndex,
          items: [
            BottomNavigationBarItem(
              icon: _selectedPageIndex == 0
                  ? Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 218, 216, 219),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      width: 70,
                      height: 35,
                      child: const Icon(
                        Icons.home_outlined,
                        size: 28,
                      ),
                    )
                  : const Icon(
                      Icons.home_outlined,
                      size: 28,
                    ),
              label: appLocalization.home,
            ),
            BottomNavigationBarItem(
              icon: _selectedPageIndex == 1
                  ? Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 218, 216, 219),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      width: 70,
                      height: 35,
                      child: const Icon(
                        MdiIcons.triangleOutline,
                        size: 22,
                      ),
                    )
                  : const Icon(
                      MdiIcons.triangleOutline,
                      size: 22,
                    ),
              label: appLocalization.interactions,
            ),
            BottomNavigationBarItem(
              icon: _selectedPageIndex == 2
                  ? Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 218, 216, 219),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      width: 70,
                      height: 35,
                      child: FractionallySizedBox(
                        heightFactor: 0.75,
                        widthFactor: 0.4,
                        child: Image.asset(
                          'assets/images/stethoscope-96.png',
                          // color: const Color(0xFF615F63),
                        ),
                      ),
                    )
                  : Image.asset(
                      'assets/images/stethoscope-96.png',
                      height: 24,
                      width: 24,
                      color: const Color(0xFF615F63),
                    ),
              label: appLocalization.doctor,
            ),
            BottomNavigationBarItem(
              icon: _selectedPageIndex == 3
                  ? Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 218, 216, 219),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      width: 70,
                      height: 35,
                      child: const Icon(
                        MdiIcons.cartOutline,
                        size: 28,
                      ),
                    )
                  : Container(
                      margin: const EdgeInsets.only(bottom: 3),
                      child: const Icon(
                        MdiIcons.cartOutline,
                        size: 28,
                      ),
                    ),
              label: appLocalization.cart,
            ),
          ],
        ),
      ),
    );
  }
}
