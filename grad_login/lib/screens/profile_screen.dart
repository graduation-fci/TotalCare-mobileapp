import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../providers/authProvider.dart';
import 'address_screen.dart';
import 'edit_profile_screen.dart';
import 'login_screen.dart';
import 'my_orders_screen.dart';

import '../providers/userProvider.dart';
import 'user_medications.dart';
import 'wish_list_screen.dart';

class Profiles extends StatefulWidget {
  static const routeName = '/profiles-screen';
  const Profiles({Key? key}) : super(key: key);

  @override
  State<Profiles> createState() => _ProfilesState();
}

class _ProfilesState extends State<Profiles> {
  Map<String, dynamic> userData = {};

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) => userData =
        Provider.of<UserProvider>(context, listen: false).userProfileData);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userData =
        Provider.of<UserProvider>(context, listen: false).userProfileData;

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              height: mediaQuery.height * 0.2,
              color: Theme.of(context).colorScheme.primary,
              padding: const EdgeInsets.only(left: 20),
              child: Column(
                children: [
                  Row(
                    children: <Widget>[
                      Text(
                        'Settings',
                        style: Theme.of(context)
                            .appBarTheme
                            .titleTextStyle!
                            .copyWith(
                                fontSize: mediaQuery.width * 0.06,
                                letterSpacing: 0),
                      ),
                      //sliver appBar
                      const Spacer(),
                      IconButton(
                        icon: SvgPicture.asset(
                          'assets/icons/notification-outlined.svg',
                          color: Theme.of(context).colorScheme.secondary,
                          height: 24,
                          width: 24,
                        ),
                        onPressed: () {
                          // handle notifications button press
                        },
                      ),
                      IconButton(
                        icon: SvgPicture.asset(
                          'assets/icons/settings-outlined.svg',
                          color: Theme.of(context).colorScheme.secondary,
                          height: 24,
                          width: 24,
                        ),
                        onPressed: () {
                          // handle settings button press
                        },
                      ),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 6),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3,
                                ),
                              ),
                              child: const CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage(
                                  "http://picsum.photos/200/300",
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${userData['first_name']} ${userData['last_name']}",
                                    style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    "${userData['email']}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(right: 20),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed(EditProfileScreen.routeName);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.secondary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: Text(
                                  "Edit",
                                  style: Theme.of(context)
                                      .textTheme
                                      .button!
                                      .copyWith(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Divider(
            //   thickness: 1,
            // ),
            Expanded(
              child: Container(
                // height: mediaQuery.height * 0.50,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: ListView(
                  children: <Widget>[
                    buildAccountOption(
                        context, 'My Orders', Icons.shopping_cart_outlined,
                        myFunc: () {
                      Navigator.of(context).pushNamed(MyOrdersScreen.routeName);
                    }),
                    buildDivider(),
                    buildAccountOption(
                        context, 'Wishlist', Icons.favorite_border_outlined,
                        myFunc: () {
                      authProvider.logout();
                      Navigator.of(context).pushNamed(WishListScreen.routeName);
                    }),
                    buildDivider(),
                    buildAccountOption(
                        context, 'My Medications', Icons.receipt_outlined,
                        myFunc: () async {
                      await userProvider.getUserMedications().then((_) =>
                          Navigator.of(context)
                              .pushNamed(UserMedicationsScreen.routeName));
                    }),
                    buildDivider(),
                    buildAccountOption(
                        context, 'Payment Methods', Icons.credit_card_outlined),
                    buildDivider(),
                    buildAccountOption(
                      context,
                      'Addresses',
                      Icons.location_on_outlined,
                      myFunc: () => Navigator.of(context)
                          .pushNamed(AddressScreen.routeName),
                    ),
                    buildDivider(),
                    buildAccountOption(
                      context,
                      'Payment History',
                      Icons.history_outlined,
                    ),
                    buildDivider(),
                    buildAccountOption(
                        context, 'Invite Friends', Icons.person_add_outlined),
                    buildDivider(),
                    buildAccountOption(
                        context, 'Change Password', Icons.lock_outlined),
                    buildDivider(),
                    buildAccountOption(
                        context, 'Log Out', Icons.logout_outlined, myFunc: () {
                      authProvider.logout();
                      Navigator.of(context)
                          .pushReplacementNamed(LoginScreen.routeName);
                    }),
                    buildDivider(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDivider() {
    return Divider(
      height: 0.06,
      color: Colors.grey[400],
      // indent: .05,
      // endIndent: 10,
      thickness: 1,
    );
  }

  GestureDetector buildAccountOption(
      BuildContext context, String title, IconData iconData,
      {VoidCallback? myFunc}) {
    return GestureDetector(
      onTap: myFunc,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            iconData,
            color: Theme.of(context).colorScheme.secondary,
            size: 24,
          ),
          const SizedBox(width: 10),
          Expanded(
              child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.secondary,
            ),
          )),
          const IconButton(
            onPressed: null,
            icon: Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
              size: Checkbox.width,
            ),
          )
        ],
      ),
    );
  }
}
